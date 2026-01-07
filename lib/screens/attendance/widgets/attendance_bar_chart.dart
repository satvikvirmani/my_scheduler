import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../models/subject_attendance.dart';
import '../../../core/utils/color_cycler.dart';

class AttendanceBarChart extends StatelessWidget {
  final List<SubjectAttendance> subjects;

  const AttendanceBarChart({
    super.key,
    required this.subjects,
  });

  @override
  Widget build(BuildContext context) {
    if (subjects.isEmpty) {
      return const SizedBox.shrink();
    }

    return SfCartesianChart(
      // 🔑 horizontal bars
      isTransposed: false,

      // X-axis → NUMERIC (0–100)
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 100,
        interval: 20,
        labelFormat: '{value}%',
        labelStyle: const TextStyle(fontSize: 10),
      ),

      // Y-axis → CATEGORY (subject codes)
      primaryXAxis: CategoryAxis(
        maximumLabelWidth: 60,
        labelStyle: const TextStyle(
          fontSize: 9,
        ),
      ),


      series: <BarSeries<SubjectAttendance, String>>[
        BarSeries<SubjectAttendance, String>(
          dataSource: subjects,

          // category
          xValueMapper: (SubjectAttendance data, _) => data.subjectCode,

          // numeric value
          yValueMapper: (SubjectAttendance data, _) => data.percentage,

          width: 0.55, // 👈 slimmer bars
          spacing: 0, // 👈 tighter columns

          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.outer,
            textStyle: TextStyle(fontSize: 9),
          ),

          pointColorMapper: (_, index) =>
              ColorCycler.byIndex(index),
        ),
      ],
    );
  }
}