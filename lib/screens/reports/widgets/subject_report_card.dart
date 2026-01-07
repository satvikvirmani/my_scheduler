import 'package:flutter/material.dart';
import 'package:my_scheduler/core/utils/color_cycler.dart';
import '../../../core/constants/spacing.dart';
import '../../../models/report.dart';

class SubjectReportCard extends StatelessWidget {
  final SubjectReport subject;
  final int index;

  const SubjectReportCard({
    super.key,
    required this.subject,
    required this.index,
  });

  bool get _showTeacherAssessment {
    return subject.hasTeacherAssessment &&
        subject.category.toLowerCase().replaceAll(' ', '') ==
            'end_sem';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorCycler.byIndex(index),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📘 Subject name
          Text(
            subject.subjectName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // 📝 Theory marks
          if (subject.hasTheory)
            Text(
              'Theory: ${subject.theoryScored}/${subject.theoryMax}',
            )
          else
            const Text(
              'Theory: N/A',
              style: TextStyle(color: Colors.black54),
            ),

          // 🧪 Practical marks (optional)
          if (subject.hasPractical) ...[
            const SizedBox(height: 4),
            Text(
              'Practical: ${subject.practicalScored}/${subject.practicalMax}',
            ),
          ],

          // 🧑‍🏫 Teacher Assessment (only for End Semester)
          if (_showTeacherAssessment) ...[
            const SizedBox(height: 4),
            Text(
              'Teacher Assessment: '
              '${subject.teacherAssessmentScored}/${subject.teacherAssessmentMax}',
            ),
          ],
        ],
      ),
    );
  }
}