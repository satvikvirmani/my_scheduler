import 'package:flutter/material.dart';
import 'package:my_scheduler/core/utils/color_cycler.dart';
import '../../../core/constants/spacing.dart';
import '../../../models/report.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/constants/colors.dart';

class SubjectReportCard extends StatelessWidget {
  final SubjectReport subject;
  final int index;

  const SubjectReportCard({
    super.key,
    required this.subject,
    required this.index,
  });

  bool get _showTeacherAssessment {
    return subject.hasTeacherAssessment &&
        subject.category.toLowerCase().replaceAll(' ', '') ==
            'end_sem';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorCycler.byIndex(index),
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📘 Subject name
          Text(
            subject.subjectName,
            style: AppTextStyles.body.copyWith(
              color: AppColors.body,
            ),
          ),

          const SizedBox(height: AppSpacing.labelGap),

          // 📝 Theory marks
          if (subject.hasTheory)
            Row(children: [
              Text(
                'Theory: ',
                style: AppTextStyles.assist.copyWith(
                  color: AppColors.body,
                ),
              ),
              Text(
                '${subject.theoryScored}/${subject.theoryMax}',
                style: AppTextStyles.assist.copyWith(
                  color: AppColors.body,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ])
          else
            Text(
              'Theory: N/A',
              style: AppTextStyles.assist.copyWith(
                color: AppColors.body,
              ),
            ),

          // 🧪 Practical marks (optional)
          if (subject.hasPractical) ...[
            Row(children: [
              Text(
                'Practical: ',
                style: AppTextStyles.assist.copyWith(
                  color: AppColors.body,
                ),
              ),
              Text(
                '${subject.practicalScored}/${subject.practicalMax}',
                style: AppTextStyles.assist.copyWith(
                  color: AppColors.body,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],)
          ],

          // 🧑‍🏫 Teacher Assessment (only for End Semester)
          if (_showTeacherAssessment) ...[
            Row(children: [
              Text(
                'Teacher Assessment: ',
                style: AppTextStyles.assist.copyWith(
                  color: AppColors.body,
                ),
              ),
              Text(
                '${subject.teacherAssessmentScored}/${subject.teacherAssessmentMax}',
                style: AppTextStyles.assist.copyWith(
                  color: AppColors.body,
                  fontWeight: FontWeight.w600
                ),
              ),
            ],)
          ],
        ],
      ),
    );
  }
}