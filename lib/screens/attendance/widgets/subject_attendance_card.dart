import 'package:flutter/material.dart';
import '../../../core/constants/spacing.dart';
import '../../../models/subject_attendance.dart';
import '../../../core/utils/color_cycler.dart';

class SubjectAttendanceCard extends StatelessWidget {
  final SubjectAttendance subject;
  final int index;

  const SubjectAttendanceCard({
    super.key,
    required this.subject,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorCycler.byIndex(index),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subject name
          Text(
            subject.subjectName, // ✅ FIXED
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          // Subject code (optional but useful)
          Text(
            subject.subjectCode,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              // Left column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total: ${subject.total}'),
                    Text('Attended: ${subject.attended}'),
                    Text('Missed: ${subject.missed}'),
                  ],
                ),
              ),

              // Right column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cancelled: ${subject.cancelled}'),
                    Text('Extra: ${subject.extra}'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}