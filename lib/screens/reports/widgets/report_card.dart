import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/report.dart';

class ReportCard extends StatelessWidget {
  final Report report;

  const ReportCard({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: report.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                report.semesterName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${report.gpa.toStringAsFixed(2)} GPA',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _buildLink(context, 'Mid Semester 1', 'mid_sem_1'),
          _buildLink(context, 'Mid Semester 2', 'mid_sem_2'),
          _buildLink(context, 'End Semester', 'end_sem'),
        ],
      ),
    );
  }

  Widget _buildLink(BuildContext context, String category, String categoryKey) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () {
        context.push(
          '/reports/detail',
          extra: {
            'semesterId': report.semesterId,
            'category': category,
            'categoryKey': categoryKey,
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          category,
          style: const TextStyle(
            fontSize: 14,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}