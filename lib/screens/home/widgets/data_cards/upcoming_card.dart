import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import 'base_card.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/exam_provider.dart';
import 'package:my_scheduler/core/constants/spacing.dart';
import 'package:my_scheduler/core/constants/text_styles.dart';

class UpcomingCard extends ConsumerWidget {
  const UpcomingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcomingExams = ref.watch(upcomingExamCountProvider);

    return InkWell(
      onTap: () => context.push('/examination'),
      child: BaseCard(
        color: AppColors.card1,
        child: Column(
          children: [
            Text('Upcoming', style: AppTextStyles.body.copyWith(
              color: AppColors.body,
            ),),
            const SizedBox(height: AppSpacing.labelGap),
            upcomingExams.when(
              loading: () => const CircularProgressIndicator(strokeWidth: 2),
              error: (e, _) => const Text(
                '—',
                style: AppTextStyles.showcase,
              ),
              data: (count) => Text(
                count.toString(),
                style: AppTextStyles.showcase.copyWith(
                  color: AppColors.body,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.labelGap),
            Text('exams', style: AppTextStyles.body.copyWith(
              color: AppColors.body,
            ),),
          ],
        ),
      ),
    );
  }
}
