import 'package:flutter/material.dart';
import '../../../../../core/constants/spacing.dart';


class BaseCard extends StatelessWidget {


  final Color color;
  final Widget child;

  const BaseCard({super.key, required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: child,
    );
  }
}