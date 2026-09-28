import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/otp_event.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import '../widgets/phone_field.dart';
import 'otp_screen.dart';

class LoginScreen extends StatelessWidget {
  final String? initialPhone;

  const LoginScreen({super.key, this.initialPhone});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginCubit>(),
      child: _LoginView(initialPhone: initialPhone),
    );
  }
}

class _LoginView extends StatefulWidget {
  final String? initialPhone;
  const _LoginView({this.initialPhone});

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  String _phone = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log in')),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            if (state.notRegistered) {
              _showNotRegisteredDialog(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          } else if (state is LoginSuccess) {
            context.push('/otp', extra: OtpScreenArgs(phone: state.phone, flow: OtpFlow.login));
          }
        },
        builder: (context, state) {
          final loading = state is LoginLoading;
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enter your phone number', style: AppTextStyles.titleLarge),
                const SizedBox(height: 4),
                Text("We'll text you a one-time code.", style: AppTextStyles.bodyMedium),
                const SizedBox(height: 24),
                PhoneField(
                  initialValue: widget.initialPhone,
                  onChanged: (value) => _phone = value,
                ),
                const SizedBox(height: 28),
                AppButton(
                  label: 'Continue',
                  loading: loading,
                  onPressed: () {
                    if (_phone.isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Enter a valid phone number')));
                      return;
                    }
                    context.read<LoginCubit>().submit(phone: _phone);
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => context.pushReplacement('/register'),
                    child: Text(
                      "Don't have an account? Register",
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryDark),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showNotRegisteredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('No account found'),
        content: const Text("This phone number isn't registered yet. Would you like to create an account?"),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.pushReplacement('/register', extra: _phone);
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
