import 'package:flutter/material.dart';
import 'package:my_scheduler/screens/home/widgets/hamburger.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/spacing.dart';
import 'user_avatar.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.topBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Hamburger(),

          Row(
            children: [
              const Text(
                'myScheduler',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              const CircleAvatar(
                radius: 4,
                backgroundColor: AppColors.accentOrange,
              ),
            ],
          ),

          const UserAvatar(size: 32), // ✅ REAL AVATAR
        ],
      ),
    );
  }
}