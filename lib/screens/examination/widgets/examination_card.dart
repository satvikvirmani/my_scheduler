import 'package:flutter/material.dart';
import 'package:my_scheduler/core/constants/spacing.dart';
import '../../../core/utils/color_cycler.dart';
import '../../../models/exam.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/constants/colors.dart';

String formatExamCategory(String category) {
  switch (category.toLowerCase()) {
    case 'mid_sem_1':
      return 'Mid Semester 1';
    case 'mid_sem_2':
      return 'Mid Semester 2';
    case 'end_sem':
      return 'End Semester';
    default:
      // fallback for unexpected values
      return category.replaceAll('_', ' ').toUpperCase();
  }
}

class ExamCard extends StatelessWidget {
  final Exam exam;
  final int index;

  const ExamCard({super.key, required this.exam, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: ColorCycler.byIndex(index),
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date
          Text(
            '${exam.date.day} ${_month(exam.date.month)}',
            style: AppTextStyles.bodyEmphasis.copyWith(color: AppColors.body),
          ),
          const SizedBox(height: AppSpacing.labelGap),
          IntrinsicHeight(
            child: Row(
              children: [
                // Time
                Text(
                  _formatTime(exam.startTime),
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.subHeading,
                  ),
                ),

                const SizedBox(width: AppSpacing.cardPadding),

                const VerticalDivider(thickness: 4, color: AppColors.subHeading,),

                const SizedBox(width: AppSpacing.cardPadding),

                // Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: AppSpacing.cardPadding,
                      bottom: AppSpacing.cardPadding,
                      right: AppSpacing.cardPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category
                        Text(
                          formatExamCategory(exam.category),
                          style: AppTextStyles.assist.copyWith(
                            color: AppColors.subHeading,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.labelGap),

                        // Subject Name
                        Text(
                          exam.subjectName,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.body,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: AppSpacing.labelGap),

                        // Code + Venue Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Subject Code (left)
                            Expanded(
                              child: Text(
                                exam.subjectCode,
                                style: AppTextStyles.assist.copyWith(
                                  color: AppColors.subHeading,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Venue (right)
                            Flexible(
                              child: Text(
                                exam.venue,
                                textAlign: TextAlign.right,
                                style: AppTextStyles.assist.copyWith(
                                  color: AppColors.subHeading,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _month(int m) => const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][m - 1];

  String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}
