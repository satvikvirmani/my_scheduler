import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/report.dart';
import '../core/utils/color_cycler.dart';

class ReportsRepository {
  final SupabaseClient _supabase;

  ReportsRepository(this._supabase);

  /// Fetch all reports for logged-in user
  Future<List<Report>> getReports() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    final response = await _supabase
        .from('reports')
        .select('''
          semester,
          category,
          theory_scored,
          theory_max,
          practical_scored,
          practical_max,
          teacher_assessment_scored,
          teacher_assessment_max,
          subjects (
            subject_name,
            credits
          )
        ''')
        .eq('user_id', user.id)
        .order('semester');

    final rows = (response as List).cast<Map<String, dynamic>>();

    if (rows.isEmpty) return [];

    /// Group rows by semester
    final Map<int, List<Map<String, dynamic>>> grouped = {};

    for (final row in rows) {
      final semesterRaw = row['semester'];
      final semester = semesterRaw is int ? semesterRaw : 0;

      grouped.putIfAbsent(semester, () => []).add(row);
    }

    int colorIndex = 0;

    return grouped.entries.map((entry) {
      final semester = entry.key;
      final semesterRows = entry.value;

      // ---------- Subjects ----------
      final subjects = semesterRows.map((row) {
        final subjectMap = row['subjects'] as Map<String, dynamic>?;

        return SubjectReport(
          subjectName: (subjectMap?['subject_name'] ?? 'Unknown').toString(),

          credits: (subjectMap?['credits'] ?? 0) as int,
          semester: (row['semester'] ?? 0) as int,

          category: (row['category'] ?? 'Unknown').toString(),

          theoryScored: row['theory_scored'] as int?,
          theoryMax: row['theory_max'] as int?,

          practicalScored: row['practical_scored'] as int?,
          practicalMax: row['practical_max'] as int?,

          teacherAssessmentScored: row['teacher_assessment_scored'] as int?,
          teacherAssessmentMax: row['teacher_assessment_max'] as int?,
        );
      }).toList();

      // ---------- GPA Calculation ----------
      final double gpa = _calculateSemesterGpa(subjects);

      return Report(
        semesterId: semester.toString(),
        semesterName: 'Semester $semester',
        gpa: gpa,
        color: ColorCycler.byIndex(colorIndex++),
        subjects: subjects,
      );
    }).toList();
  }

  double _calculateSubjectFinalScore(SubjectReport s) {
    if (!s.hasCompleteMarks) return 0;

    final theoryTotal =
        (s.theoryScored ?? 0) + (s.teacherAssessmentScored ?? 0);

    final practicalTotal = s.hasPractical ? (s.practicalScored ?? 0) : 0;

    if (!s.hasPractical) {
      return theoryTotal.toDouble();
    }

    return (0.75 * theoryTotal) + (0.25 * practicalTotal);
  }

double _gradePointFromMarks(double finalMarks) {
  if (finalMarks >= 85) return 10;
  if (finalMarks >= 75) return 9;
  if (finalMarks >= 65) return 8;
  if (finalMarks >= 50) return 6;
  if (finalMarks >= 40) return 4;

  // ❌ Fail
  return 0;
}

double _calculateSemesterGpa(List<SubjectReport> subjects) {
  double weightedPoints = 0;
  int totalCredits = 0;

  for (final s in subjects) {
    if (s.credits == 0) continue;

    final finalScore = _calculateSubjectFinalScore(s);
    final gradePoint = _gradePointFromMarks(finalScore);

    // ❌ Fail in any subject → no GPA for semester
    if (gradePoint == 0) {
      return 0;
    }

    weightedPoints += gradePoint * s.credits;
    totalCredits += s.credits;
  }

  if (totalCredits == 0) return 0;

  return weightedPoints / totalCredits;
}

double calculateCgpa(List<Report> reports) {
  double weightedPoints = 0;
  int totalCredits = 0;

  for (final report in reports) {
    final semesterGpa =
        _calculateSemesterGpa(report.subjects);

    // ❌ If any semester has no GPA → no CGPA
    if (semesterGpa == 0) {
      return 0;
    }

    for (final s in report.subjects) {
      if (s.credits == 0) continue;

      final finalScore = _calculateSubjectFinalScore(s);
      final gradePoint = _gradePointFromMarks(finalScore);

      weightedPoints += gradePoint * s.credits;
      totalCredits += s.credits;
    }
  }

  if (totalCredits == 0) return 0;

  return weightedPoints / totalCredits;
}
}
