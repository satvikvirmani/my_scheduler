import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ColorCycler {
  static const List<Color> _palette = [
    AppColors.card1,
    AppColors.card2,
    AppColors.card3,
    AppColors.card4,
    AppColors.card5,
    AppColors.card6,
  ];

  /// Returns a color based on index, cycling through palette
  static Color byIndex(int index) {
    return _palette[index % _palette.length];
  }
}