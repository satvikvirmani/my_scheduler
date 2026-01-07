import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';

class DateHeader extends StatelessWidget {
  const DateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        context.push('/schedule'); // 👈 navigation
      },
      child: Row(
        children: const [
          Text(
            'Today, ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '10 July',
            style: TextStyle(fontSize: 18, color: AppColors.textMuted),
          ),
          SizedBox(width: 16)
        ],
      ),
    );
  }
}
