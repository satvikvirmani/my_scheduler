import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 2,
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 18,
              height: 2,
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
