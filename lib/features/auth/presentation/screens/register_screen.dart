import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/otp_event.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';
import '../widgets/phone_field.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatelessWidget {
  final String? initialPhone;

  const RegisterScreen({super.key, this.initialPhone});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RegisterCubit>(),
      child: _RegisterView(initialPhone: initialPhone),
    );
  }
}

class _RegisterView extends StatefulWidget {
  final String? initialPhone;
  const _RegisterView({this.initialPhone});

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  late String _phone = widget.initialPhone ?? '';
  late final _privacyPolicyTap = TapGestureRecognizer()
    ..onTap = () => context.push('/privacy-policy');
  late final _termsOfServiceTap = TapGestureRecognizer()
    ..onTap = () => context.push('/terms-of-service');
  late final _antiSpamPolicyTap = TapGestureRecognizer()
    ..onTap = () => context.push('/anti-spam-policy');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _privacyPolicyTap.dispose();
    _termsOfServiceTap.dispose();
    _antiSpamPolicyTap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is RegisterSuccess) {
            context.push('/otp', extra: OtpScreenArgs(phone: state.phone, flow: OtpFlow.register));
          }
        },
        builder: (context, state) {
          final loading = state is RegisterLoading;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tell us a bit about you', style: AppTextStyles.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    "We'll text you a code to verify your number.",
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  AppTextField(
                    controller: _nameController,
                    label: 'Full name',
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  PhoneField(
                    initialValue: widget.initialPhone,
                    onChanged: (value) => _phone = value,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _emailController,
                    label: 'Email (optional)',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 28),
                  AppButton(
                    label: 'Continue',
                    loading: loading,
                    onPressed: () {
                      if (!(_formKey.currentState?.validate() ?? false)) return;
                      if (_phone.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('Enter a valid phone number')));
                        return;
                      }
                      context.read<RegisterCubit>().submit(
                            name: _nameController.text.trim(),
                            phone: _phone,
                            email: _emailController.text.trim(),
                          );
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        style: AppTextStyles.bodyMedium,
                        children: [
                          const TextSpan(text: 'By continuing, you agree to our '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primaryDark,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: _privacyPolicyTap,
                          ),
                          const TextSpan(text: ', '),
                          TextSpan(
                            text: 'Terms of Service',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primaryDark,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: _termsOfServiceTap,
                          ),
                          const TextSpan(text: ', and '),
                          TextSpan(
                            text: 'Anti-Spam Policy',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primaryDark,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: _antiSpamPolicyTap,
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () => context.pushReplacement('/login'),
                      child: Text(
                        'Already have an account? Log in',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryDark),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
