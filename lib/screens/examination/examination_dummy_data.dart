import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class Examination {
  final String date;
  final String time;
  final String type;
  final String name;
  final String subjectCode;
  final String center;
  final Color color;

  Examination({
    required this.date,
    required this.time,
    required this.type,
    required this.name,
    required this.subjectCode,
    required this.center,
    required this.color,
  });
}

final List<Examination> examDummyData = [
  Examination(
    date: '12 March 2026',
    time: '09:30',
    type: 'Mid Semester',
    name: 'Computer Systems',
    subjectCode: 'MSIC 43',
    center: 'MCA 301',
    color: AppColors.cyan,
  ),
  Examination(
    date: '18 March 2026',
    time: '02:00',
    type: 'Mid Semester',
    name: 'Database Systems',
    subjectCode: 'MSIC 52',
    center: 'MCA 205',
    color: AppColors.peach,
  ),
];