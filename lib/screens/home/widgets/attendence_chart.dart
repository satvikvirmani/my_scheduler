import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../core/constants/colors.dart';
import './data_cards/base_card.dart';

class AttendanceChart extends StatelessWidget {
  final double attendance; // value from 0.0 to 1.0

  const AttendanceChart({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    final List<_ChartData> chartData = [
      _ChartData('Present', attendance, AppColors.accentOrange),
      _ChartData(
        'Absent',
        1 - attendance,
        AppColors.textMuted.withOpacity(0.2),
      ),
    ];

    return BaseCard(
      color: AppColors.peach,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Overall Attendance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: 140,
            height: 140,
            child: SfCircularChart(
              annotations: <CircularChartAnnotation>[
                CircularChartAnnotation(
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(attendance * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Present',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
              series: <CircularSeries>[
                DoughnutSeries<_ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (_ChartData data, _) => data.category,
                  yValueMapper: (_ChartData data, _) => data.value,
                  pointColorMapper: (_ChartData data, _) => data.color,
                  innerRadius: '70%',
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
