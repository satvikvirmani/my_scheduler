import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sign_in_button/sign_in_button.dart';

// Constants
import 'package:my_scheduler/core/constants/spacing.dart';
import 'package:my_scheduler/core/constants/colors.dart';
import 'package:my_scheduler/core/constants/text_styles.dart';

import 'package:my_scheduler/widgets/text_input_field.dart';
import 'package:my_scheduler/widgets/custom_app_bar.dart';

import 'package:go_router/go_router.dart';
import 'package:my_scheduler/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .signInEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
      // Router will handle redirect
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.danger),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _googleSignIn() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
      // Router will handle redirect
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.danger),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Login'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextInputField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                placeholder: 'Enter your email',
              ),
              const SizedBox(height: AppSpacing.gap),
              TextInputField(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
                placeholder: 'Enter your password',
              ),
              const SizedBox(height: AppSpacing.gap),
              FilledButton(
                style: FilledButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.fieldXPadding + 5,
                    vertical: AppSpacing.fieldYPadding + 5,
                  ),
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radius),
                  ),
                ),

                onPressed: _isLoading ? null : _signIn,

                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.light,
                        ),
                      )
                    : const Text('Login', style: AppTextStyles.body),
              ),
              const SizedBox(height: AppSpacing.gap),
              SignInButton(
                Buttons.google,
                textStyle: AppTextStyles.body,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.fieldXPadding,
                  vertical: AppSpacing.fieldYPadding,
                ),
                elevation: 2,
                onPressed: () => _googleSignIn(),
              ),
              const SizedBox(height: AppSpacing.gap),
              TextButton(
                style: FilledButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.fieldXPadding + 5,
                    vertical: AppSpacing.fieldYPadding + 5,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radius),
                  ),
                ),

                onPressed: () => context.go('/register'),

                child: const Text('Don\'t have an account? Register', style: AppTextStyles.body),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
