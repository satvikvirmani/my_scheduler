import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/constants/spacing.dart';

class DateHeader extends StatelessWidget {
  const DateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('/schedule'); // 👈 navigation
      },
      child: Row(
        children: [
          Text(
            'Today, ',
            style: AppTextStyles.heading.copyWith(color: AppColors.body),
          ),
          Text(
            '10 July',
            style: AppTextStyles.subheading.copyWith(color: AppColors.subHeading),
          ),
          const SizedBox(width: AppSpacing.gap)
        ],
      ),
    );
  }
}
