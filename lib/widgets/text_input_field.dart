import 'package:flutter/material.dart';
import 'package:my_scheduler/core/constants/colors.dart';
import 'package:my_scheduler/core/constants/spacing.dart';
import 'package:my_scheduler/core/constants/text_styles.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final String? placeholder;
final ValueChanged<String>? onSubmitted;
final TextInputAction textInputAction;
final int maxLines;
final bool enabled;

  const TextInputField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.placeholder,
    this.onSubmitted,
    this.textInputAction = TextInputAction.done,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Label Above
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: AppTextStyles.assist.copyWith(
              color: AppColors.subHeading,
            ),
          ),
          const SizedBox(height: AppSpacing.labelGap),
        ],

        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
            onSubmitted: onSubmitted,
            enabled: enabled,
            textInputAction: textInputAction, // ✅
  maxLines: maxLines,              
          decoration: InputDecoration(
            hintText: placeholder,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            filled: true,
            fillColor: AppColors.superlight,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radius),
              borderSide: BorderSide(
                color: AppColors.subHeading,
                width: 1,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),

            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.fieldXPadding,
              vertical: AppSpacing.fieldYPadding,
            ),
          ),
        ),
      ],
    );
  }
}
