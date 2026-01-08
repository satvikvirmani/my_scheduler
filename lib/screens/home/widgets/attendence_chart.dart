import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import './data_cards/base_card.dart';

class AttendanceChart extends StatelessWidget {
  final double attendance; // value from 0.0 to 1.0

  const AttendanceChart({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    final List<_ChartData> chartData = [
      _ChartData('Present', attendance, AppColors.chartTrue),
      _ChartData(
        'Absent',
        1 - attendance,
        AppColors.chartFalse,
      ),
    ];

    return BaseCard(
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

          const SizedBox(height: 16),

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
                          '${(attendance * 100).toInt()}%',
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
                  strokeWidth: 1.5,
                  innerRadius: '80%',
                  radius: '100%',
                  dataLabelSettings: const DataLabelSettings(isVisible: false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartData {
  final String category;
  final double value;
  final Color color;

  _ChartData(this.category, this.value, this.color);
}
