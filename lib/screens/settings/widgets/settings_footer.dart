import 'package:flutter/material.dart';

import 'package:my_scheduler/core/constants/colors.dart';
import 'package:my_scheduler/core/constants/text_styles.dart';

class SettingsFooter extends StatelessWidget {
  final VoidCallback onSignOut;

  const SettingsFooter({super.key, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // ✅ important
      children: [
        const Divider(),

        Align(
          alignment: Alignment.centerLeft,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 0,
            dense: true,
            title: Text(
              'Sign out',
              style: AppTextStyles.body.copyWith(color: AppColors.danger),
            ),
            onTap: onSignOut,
          ),
        ),
      ],
    );
  }
}
