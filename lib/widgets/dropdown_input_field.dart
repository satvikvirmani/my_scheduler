import 'package:flutter/material.dart';
import 'package:my_scheduler/core/constants/colors.dart';
import 'package:my_scheduler/core/constants/spacing.dart';
import 'package:my_scheduler/core/constants/text_styles.dart';

class DropdownInputField<T> extends StatelessWidget {
  final String label;
  final String? placeholder;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final IconData? prefixIcon;

  const DropdownInputField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.placeholder,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onChanged == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 Label
        Text(
          label,
          style: AppTextStyles.assist,
        ),

        const SizedBox(height: AppSpacing.labelGap),

        /// 🔹 Dropdown
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          hint: placeholder != null ? Text(placeholder!) : null,
          dropdownColor: Colors.white,
          style: AppTextStyles.body,

          decoration: InputDecoration(
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            filled: true,
            fillColor: isDisabled
                ? AppColors.superlight.withOpacity(0.5)
                : AppColors.superlight,

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