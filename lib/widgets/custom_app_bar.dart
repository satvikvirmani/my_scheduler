import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_scheduler/core/constants/text_styles.dart';
import 'package:my_scheduler/core/constants/colors.dart';
import 'package:my_scheduler/core/constants/spacing.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? customTitle;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final double height;

  /// 🔹 Horizontal padding inside AppBar
  final double horizontalPadding;

  const CustomAppBar({
    super.key,
    this.title,
    this.customTitle,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.height = kToolbarHeight,
    this.horizontalPadding = AppSpacing.pagePadding, // default padding
  }) : assert(
          title != null || customTitle != null,
          'Either title or customTitle must be provided',
        );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.superlight,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      centerTitle: centerTitle,
      leading: leading != null
          ? Padding(
              padding: EdgeInsets.only(left: horizontalPadding),
              child: leading,
            )
          : null,

      /// ➡️ Right padding control
      actions: actions
          ?.map(
            (w) => Padding(
              padding: EdgeInsets.only(right: horizontalPadding),
              child: w,
            ),
          )
          .toList(),

      titleSpacing: horizontalPadding,

      title: customTitle ??
          Text(
            title!,
            style: AppTextStyles.accent.copyWith(
              color: AppColors.body,
            ),
          ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}