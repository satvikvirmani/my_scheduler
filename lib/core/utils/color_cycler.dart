import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ColorCycler {
  static const List<Color> _palette = [
    AppColors.lavender,
    AppColors.mint,
    AppColors.peach,
    AppColors.skyBlue,
    AppColors.softYellow,
    AppColors.softPink,
  ];

  /// Returns a color based on index, cycling through palette
  static Color byIndex(int index) {
    return _palette[index % _palette.length];
  }
}