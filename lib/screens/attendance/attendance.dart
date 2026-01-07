import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/spacing.dart';
import '../home/widgets/attendence_chart.dart';
import 'widgets/attendance_bar_chart.dart';
import 'widgets/subject_attendance_card.dart';
import '../../../providers/attendance_provider.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overallAttendance = ref.watch(overallAttendanceProvider);
    final attendances = ref.watch(semesterAttendanceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    // Left: Radial chart
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.peach,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.cardRadius,
                          ),
                        ),
                        child: AttendanceChart(attendance: overallAttendance),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Right: Bar chart
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.mint,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.cardRadius,
                          ),
                        ),
                        child: attendances.when(
                          loading: () => const CircularProgressIndicator(),
                          error: (e, _) => Text('Error: $e'),
                          data: (subjects) => AttendanceBarChart(
                            subjects: subjects,
                          ),
),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.sectionGap),

              attendances.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error: $e'),
                data: (subjects) {
                  if (subjects.isEmpty) {
                    return const Text('No attendance data available');
                  }

                  return Column(
                    children: List.generate(
                      subjects.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: SubjectAttendanceCard(
                          subject: subjects[index],
                          index: index,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
