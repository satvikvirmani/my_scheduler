import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/spacing.dart';
import 'widgets/examination_card.dart';
import '../../providers/exam_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/colors.dart';

class ExaminationScreen extends ConsumerWidget {
  const ExaminationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exams = ref.watch(upcomingExamsProvider);

    return Scaffold(
      appBar: CustomAppBar(title: 'Examination'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.pagePadding,
            right: AppSpacing.pagePadding,
            bottom: AppSpacing.pagePadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upcoming',
                style: AppTextStyles.heading.copyWith(color: AppColors.body),
              ),

              const SizedBox(height: AppSpacing.gap),

              Expanded(
                child: exams.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) =>
                      Center(child: Text('Error: $e')),
                  data: (examList) {
                    if (examList.isEmpty) {
                      return const Center(
                        child: Text('No upcoming exams'),
                      );
                    }

                    return ListView.separated(
                      itemCount: examList.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.gap),
                      itemBuilder: (context, index) {
                        return ExamCard(
                          exam: examList[index],
                          index: index,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}