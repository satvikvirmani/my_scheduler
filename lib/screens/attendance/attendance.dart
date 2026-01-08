import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import 'widgets/attendance_chart.dart';
import 'widgets/attendance_bar_chart.dart';
import 'widgets/subject_attendance_card.dart';
import '../../../providers/attendance_provider.dart';
import '../../../widgets/custom_app_bar.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overallAttendance = ref.watch(overallAttendanceProvider);
    final attendances = ref.watch(semesterAttendanceProvider);

    return Scaffold(
      appBar: CustomAppBar(title: 'Attendance'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    AttendanceChartScreen(attendance: overallAttendance),
                    Expanded(
                      child: Container(
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

              const SizedBox(height: 2 * AppSpacing.gap),

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
                        padding: const EdgeInsets.only(bottom: AppSpacing.gap),
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
