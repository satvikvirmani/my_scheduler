import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_scheduler/core/constants/text_styles.dart';
import '../../../models/report.dart';
import '../../../../core/constants/spacing.dart';
import '../../../../core/constants/colors.dart';

class ReportCard extends StatelessWidget {
  final Report report;

  const ReportCard({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      decoration: BoxDecoration(
        color: report.color,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                report.semesterName,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.body,
                ),
              ),
              Row(
                children: [
                  Text(
                    report.gpa.toStringAsFixed(2),
                    style: AppTextStyles.bodyEmphasis.copyWith(
                      color: AppColors.body,
                    ),
                  ),
                  Text(
                    ' GPA',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.subHeading,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          _buildLink(context, 'Mid Semester 1', 'mid_sem_1'),
          const SizedBox(height: AppSpacing.labelGap),
          _buildLink(context, 'Mid Semester 2', 'mid_sem_2'),
          const SizedBox(height: AppSpacing.labelGap),
          _buildLink(context, 'End Semester', 'end_sem'),
        ],
      ),
    );
  }

  Widget _buildLink(BuildContext context, String category, String categoryKey) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () {
        context.push(
          '/reports/detail',
          extra: {
            'semesterId': report.semesterId,
            'category': category,
            'categoryKey': categoryKey,
          },
        );
      },
      child: Text(
          category,
          style: AppTextStyles.assist.copyWith(
            color: AppColors.subHeading,
            decoration: TextDecoration.underline,
          ),
        ),
    );
  }
}