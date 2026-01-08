import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../models/subject_attendance.dart';
import '../../../core/utils/color_cycler.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/constants/colors.dart';

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
        labelFormat: '{value}',
        labelStyle: AppTextStyles.chart.copyWith(
          color: AppColors.body,
        ),
      ),

      // Y-axis → CATEGORY (subject codes)
      primaryXAxis: CategoryAxis(
        maximumLabelWidth: 60,
        labelStyle: AppTextStyles.chart.copyWith(
          color: AppColors.body,
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
          spacing: 0.1, // 👈 tighter columns
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),

          dataLabelMapper: (SubjectAttendance data, _) =>
              data.percentage.toStringAsFixed(2),

          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.outer,
            textStyle: AppTextStyles.chart.copyWith(
              color: AppColors.body,
            ),
          ),

          pointColorMapper: (_, index) =>
              ColorCycler.byIndex(index),
        ),
      ],
    );
  }
}