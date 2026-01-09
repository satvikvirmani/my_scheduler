import 'package:flutter/material.dart';
import 'package:my_scheduler/core/constants/spacing.dart';
import '../../core/constants/colors.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/text_styles.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final double drawerWidth = MediaQuery.of(context).size.width * 0.5;

    return Drawer(
      width: drawerWidth,
      backgroundColor: AppColors.superlight,
      elevation: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          decoration: const BoxDecoration(
            color: AppColors.superlight,
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'myScheduler',
                    style: AppTextStyles.accent.copyWith(fontSize: 16, color: AppColors.body),
                  ),
                  const SizedBox(width: 6),
                  Baseline(
                    baseline: 16,
                    baselineType: TextBaseline.alphabetic,
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: AppColors.accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.labelGap),
              const Divider(),
              const SizedBox(height: AppSpacing.labelGap),

              _SidebarItem(
                title: 'Examination',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/examination');
                },
              ),
              _SidebarItem(
                title: 'Schedule',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/schedule');
                },
              ),
              _SidebarItem(
                title: 'Attendance',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/attendance');
                },
              ),
              _SidebarItem(
                title: 'Reports',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/reports');
                },
              ),
              const SizedBox(height: AppSpacing.labelGap),

              const Divider(),
              const SizedBox(height: AppSpacing.labelGap),

              _SidebarItem(
                title: 'Settings',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/settings');
                },
              ),
              const SizedBox(height: AppSpacing.labelGap),

              const Divider(),
              const SizedBox(height: AppSpacing.labelGap),

              _SidebarItem(title: 'Support'),
              _SidebarItem(title: 'FAQs'),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const _SidebarItem({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      dense: true,
      title: Text(
        title,
        style: AppTextStyles.body.copyWith(color: AppColors.subHeading),
      ),
      onTap: onTap,
    );
  }
}
