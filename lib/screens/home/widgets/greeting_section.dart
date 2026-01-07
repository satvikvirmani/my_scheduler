import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/text_styles.dart';
import '../../../providers/auth_provider.dart';

class GreetingSection extends ConsumerWidget {
  const GreetingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullNameAsync = ref.watch(fullNameProvider);

    return Align(
      alignment: Alignment.centerLeft,
      child: fullNameAsync.when(
        loading: () => const Text('Hello', style: AppTextStyles.heading),
        error: (_, __) =>
            const Text('Hello', style: AppTextStyles.heading),
        data: (fullName) {
          final firstName = fullName.trim().split(' ').first;
          return Text(
            'Hello, $firstName',
            style: AppTextStyles.heading,
          );
        },
      ),
    );
  }
}