import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/colors.dart';
import 'base_card.dart';
import '../attendence_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../../providers/attendance_provider.dart';

class AttendanceCard extends ConsumerWidget {
  const AttendanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final overallAttendance = ref.watch(overallAttendanceProvider);

    return InkWell(
      onTap: () => context.push('/attendance'),
      child: BaseCard(
        color: AppColors.peach,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [AttendanceChart(attendance: overallAttendance)],
        ),
      ),
    );
  }
}
