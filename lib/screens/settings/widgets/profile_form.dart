import 'package:flutter/material.dart';
import 'package:my_scheduler/core/constants/spacing.dart';
import 'package:my_scheduler/widgets/text_input_field.dart';
import 'package:my_scheduler/core/constants/colors.dart';
import 'package:my_scheduler/core/constants/text_styles.dart';

class ProfileForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final String email;
  final bool saving;
  final VoidCallback onSave;

  const ProfileForm({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.email,
    required this.saving,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.pagePadding),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextInputField(controller: nameController, label: 'Name'),

            const SizedBox(height: AppSpacing.labelGap),

            TextInputField(
              enabled: false,
              controller: TextEditingController(text: email),
              label: 'Email',
            ),

            const SizedBox(height: AppSpacing.labelGap),

            TextInputField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              label: 'Phone Number',
            ),

            const SizedBox(height: AppSpacing.labelGap),

              FilledButton(
                style: FilledButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.fieldXPadding + 5,
                    vertical: AppSpacing.fieldYPadding + 5,
                  ),
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radius),
                  ),
                ),

                onPressed: saving ? null : onSave,

                child: saving
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.light,
                        ),
                      )
                    : const Text('Update', style: AppTextStyles.body),
              ),

            const Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              dense: true,
              title: Text('Support', style: AppTextStyles.body.copyWith(color: AppColors.subHeading)),
              onTap: () {},
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              dense: true,
              title: Text('FAQs', style: AppTextStyles.body.copyWith(color: AppColors.subHeading)),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
