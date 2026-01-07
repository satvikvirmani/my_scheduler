import 'package:flutter/material.dart';
import '../../../core/constants/text_styles.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text('Hello Satvik', style: AppTextStyles.heading),
    );
  }
}