import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/spacing.dart';
import '../home_screen.dart';

class Hamburger extends StatelessWidget {
  const Hamburger({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (scaffoldContext) => GestureDetector(
        behavior: HitTestBehavior.opaque, // 👈 important for web clicks
        onTap: () {
          homeScaffoldKey.currentState?.openDrawer();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 20,
              height: 2,
              decoration: BoxDecoration(
                color: AppColors.body,
                borderRadius: BorderRadius.circular(AppSpacing.radius),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 10,
              height: 2,
              decoration: BoxDecoration(
                color: AppColors.body,
                borderRadius: BorderRadius.circular(AppSpacing.radius),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
