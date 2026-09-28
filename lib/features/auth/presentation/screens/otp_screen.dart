import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/otp_bloc.dart';
import '../bloc/otp_event.dart';
import '../bloc/otp_state.dart';
import '../widgets/otp_box_input.dart';

/// The SMS body is exactly "Your verification code is {code}" today — a
/// plain 4-digit number — but matching by shape rather than position means
/// this keeps working if the wording changes later.
final _otpCodeRegex = RegExp(r'\b\d{4}\b');

class OtpScreenArgs {
  final String phone;
  final OtpFlow flow;
  const OtpScreenArgs({required this.phone, required this.flow});
}

class OtpScreen extends StatelessWidget {
  final OtpScreenArgs args;

  const OtpScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OtpBloc>()..add(OtpStarted(phone: args.phone, flow: args.flow)),
      child: const _OtpView(),
    );
  }
}

class _OtpView extends StatefulWidget {
  const _OtpView();

  @override
  State<_OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<_OtpView> {
  final _smsAutoFill = SmsAutoFill();
  StreamSubscription<String>? _smsSubscription;
  bool _listening = false;

  @override
  void initState() {
    super.initState();
    // Android: listens via the SMS User Consent API — no permissions, no
    // app-signature hash needed. iOS gets its autofill from the
    // `autofillHints: [AutofillHints.oneTimeCode]` on the boxes themselves
    // (see OtpBoxInput), which needs no package at all.
    _smsAutoFill.listenForCode(smsCodeRegexPattern: _otpCodeRegex.pattern);
    _listening = true;
    _smsSubscription = _smsAutoFill.code.listen((code) {
      final match = _otpCodeRegex.firstMatch(code)?.group(0) ?? code;
      if (!mounted) return;
      context.read<OtpBloc>().add(OtpCodeChanged(match));
    });
  }

  void _stopListening() {
    if (!_listening) return;
    _listening = false;
    _smsSubscription?.cancel();
    _smsAutoFill.unregisterListener();
  }

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify your number')),
      body: BlocConsumer<OtpBloc, OtpState>(
        listener: (context, state) {
          if (state.status == OtpStatus.verified) {
            _stopListening();
            context.go('/home');
          } else if (state.status == OtpStatus.error && state.errorMessage != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          final bloc = context.read<OtpBloc>();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('Enter the 4-digit code', style: AppTextStyles.titleLarge),
                const SizedBox(height: 6),
                Text(
                  'Sent via SMS to ${state.phone}',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 36),
                Center(
                  child: OtpBoxInput(
                    value: state.code,
                    enabled: state.status != OtpStatus.submitting && state.status != OtpStatus.verified,
                    shake: state.shake && state.status == OtpStatus.error,
                    success: state.status == OtpStatus.verified,
                    onChanged: (code) => bloc.add(OtpCodeChanged(code)),
                  ),
                ),
                const SizedBox(height: 28),
                Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: state.status == OtpStatus.submitting
                        ? const SizedBox(
                            key: ValueKey('loading'),
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 2.4),
                          )
                        : state.status == OtpStatus.verified
                            ? Icon(
                                Icons.check_circle_rounded,
                                key: const ValueKey('success'),
                                color: AppColors.success,
                                size: 36,
                              ).animate().scale(duration: 300.ms, curve: Curves.elasticOut)
                            : const SizedBox(key: ValueKey('empty'), height: 24),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: state.canResend
                      ? TextButton(
                          onPressed: state.status == OtpStatus.resending
                              ? null
                              : () => bloc.add(const OtpResendRequested()),
                          child: Text(
                            state.status == OtpStatus.resending ? 'Sending…' : 'Resend code',
                            style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryDark),
                          ),
                        )
                      : Text(
                          'Resend code in ${state.cooldownSeconds}s',
                          style: AppTextStyles.bodyMedium,
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
