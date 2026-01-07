import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import 'base_card.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/exam_provider.dart';

class UpcomingCard extends ConsumerWidget {
  const UpcomingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcomingExams = ref.watch(upcomingExamCountProvider);

    return InkWell(
      onTap: () => context.push('/examination'),
      child: BaseCard(
        color: AppColors.cyan,
        child: Column(
          children: [
            Text('Upcoming'),
            SizedBox(height: 8),

            upcomingExams.when(
              loading: () => const CircularProgressIndicator(strokeWidth: 2),
              error: (e, _) => const Text(
                '—',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              data: (count) => Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text('exams'),
          ],
        ),
      ),
    );
  }
}
