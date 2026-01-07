import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'package:go_router/go_router.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final double drawerWidth = MediaQuery.of(context).size.width * 0.5;

    return Drawer(
      width: drawerWidth,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Name
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'myScheduler',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            const Divider(),
            _SidebarItem(
              title: 'Examination',
              onTap: () {
                Navigator.pop(context);
                context.push('/examination');
              },
            ),
            _SidebarItem(title: 'Schedule',
            onTap: () {
              Navigator.pop(context);
              context.push('/schedule');
            },),
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

            const Divider(),

            // Settings
            _SidebarItem(
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                context.push('/settings');
              },
            ),

            const Divider(),

            // Bottom 2 links
            _SidebarItem(title: 'Help'),
            _SidebarItem(title: 'Logout'),
          ],
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
    return ListTile(title: Text(title), onTap: onTap);
  }
}
