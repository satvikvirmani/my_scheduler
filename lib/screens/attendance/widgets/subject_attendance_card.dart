import 'package:flutter/material.dart';
import '../../../core/constants/spacing.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../models/subject_attendance.dart';
import '../../../core/utils/color_cycler.dart';

class SubjectAttendanceCard extends StatelessWidget {
  final SubjectAttendance subject;
  final int index;

  const SubjectAttendanceCard({
    super.key,
    required this.subject,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      decoration: BoxDecoration(
        color: ColorCycler.byIndex(index),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subject name
          Text(
            subject.subjectName,
            style: AppTextStyles.body.copyWith(
              color: AppColors.body,
            ),
          ),

          const SizedBox(height: AppSpacing.labelGap),

          Row(
            children: [
              // Left column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total: ${subject.total}', style: AppTextStyles.assist.copyWith(
                      color: AppColors.subHeading,
                    )),
                    Text('Attended: ${subject.attended}', style: AppTextStyles.assist.copyWith(
                      color: AppColors.subHeading,
                    )),
                    Text('Missed: ${subject.missed}', style: AppTextStyles.assist.copyWith(
                      color: AppColors.subHeading,
                    )),
                  ],
                ),
              ),

              // Right column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cancelled: ${subject.cancelled}', style: AppTextStyles.assist.copyWith(
                      color: AppColors.subHeading,
                    )),
                    Text('Extra: ${subject.extra}', style: AppTextStyles.assist.copyWith(
                      color: AppColors.subHeading,
                    )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}