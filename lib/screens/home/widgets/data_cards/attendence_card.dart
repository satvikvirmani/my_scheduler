import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/colors.dart';
import 'base_card.dart';
import 'package:go_router/go_router.dart';
import '../../../../providers/attendance_provider.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../core/constants/spacing.dart';
import '../../../../core/constants/text_styles.dart';

class AttendanceCard extends ConsumerWidget {
  const AttendanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final overallAttendance = ref.watch(overallAttendanceProvider);

    final List<_ChartData> chartData = [
      _ChartData('Present', overallAttendance, AppColors.chartTrue),
      _ChartData(
        'Absent',
        1 - overallAttendance,
        AppColors.chartFalse,
      ),
    ];

    return InkWell(
      onTap: () => context.push('/attendance'),
      child: BaseCard(
      color: AppColors.card4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Overall Attendance',
            style: AppTextStyles.body.copyWith(
              color: AppColors.body,
            ),
          ),

          const SizedBox(height: AppSpacing.gap),

          SizedBox(
            width: 120,
            height: 120,
            child: SfCircularChart(
              annotations: <CircularChartAnnotation>[
                CircularChartAnnotation(
                  widget: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(overallAttendance * 100).toInt()}%',
                          style: AppTextStyles.heading.copyWith(
                          color: AppColors.body,
                        ),
                      )
                    ],
                  ),
                ),
            )],
              series: <CircularSeries>[
                DoughnutSeries<_ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (_ChartData data, _) => data.category,
                  yValueMapper: (_ChartData data, _) => data.value,
                  pointColorMapper: (_ChartData data, _) => data.color,
                  strokeColor: AppColors.body,
                  strokeWidth: 1,
                  innerRadius: '80%',
                  radius: '100%',
                  dataLabelSettings: const DataLabelSettings(isVisible: false),
                ),
              ],
            ),
          ),
        ],
      ),
    )
    );
  }
}

class _ChartData {
  final String category;
  final double value;
  final Color color;

  _ChartData(this.category, this.value, this.color);
}
