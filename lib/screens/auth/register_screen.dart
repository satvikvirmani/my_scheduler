import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sign_in_button/sign_in_button.dart';

// Constants
import 'package:my_scheduler/core/constants/spacing.dart';
import 'package:my_scheduler/core/constants/colors.dart';
import 'package:my_scheduler/core/constants/text_styles.dart';

import 'package:my_scheduler/widgets/custom_app_bar.dart';
import 'package:my_scheduler/widgets/text_input_field.dart';

import 'package:go_router/go_router.dart';
import 'package:my_scheduler/providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    setState(() => _isLoading = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .signUpEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            fullName: _fullNameController.text.trim(),
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Registration successful! Please login or check your email.',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.danger,
          ),
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
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Register'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextInputField(
                controller: _fullNameController,
                label: 'Full Name',
                placeholder: 'Enter your full name',
              ),
              const SizedBox(height: AppSpacing.gap),
              TextInputField(
                controller: _emailController,
                label: 'Email',
                placeholder: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.gap),
              TextInputField(
                controller: _passwordController,
                label: 'Password',
                placeholder: 'Enter your password',
                obscureText: true,
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
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.light,
                        ),
                      )
                    : const Text('Register', style: AppTextStyles.body),
              ),
              const SizedBox(height: AppSpacing.gap),
              SignInButton(
                Buttons.google,
                text: 'Sign Up with Google',
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

                onPressed: () => context.go('/login'),

                child: const Text('Already have an account? Login', style: AppTextStyles.body),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
