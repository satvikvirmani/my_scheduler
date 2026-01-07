import 'package:flutter/material.dart';

/// ===============================
/// Report (one semester summary)
/// ===============================
class Report {
  final String semesterId;
  final String semesterName;
  final double gpa;
  final Color color;
  final List<SubjectReport> subjects;

  Report({
    required this.semesterId,
    required this.semesterName,
    required this.gpa,
    required this.color,
    required this.subjects,
  });
}

/// =================================
/// Subject report (per exam category)
/// =================================
class SubjectReport {
  final String subjectName;
  final String category;

  final int? theoryScored;
  final int? theoryMax;

  final int? practicalScored;
  final int? practicalMax;

  final int? teacherAssessmentScored;
  final int? teacherAssessmentMax;

  final int credits;
  final int semester;

  SubjectReport({
    required this.subjectName,
    required this.category,
    required this.credits,
    required this.semester,
    this.theoryScored,
    this.theoryMax,
    this.practicalScored,
    this.practicalMax,
    this.teacherAssessmentScored,
    this.teacherAssessmentMax
  });

  bool get hasTheory =>
      theoryScored != null && theoryMax != null;

  bool get hasPractical =>
      practicalScored != null && practicalMax != null;

  bool get hasTeacherAssessment =>
      teacherAssessmentScored != null && teacherAssessmentMax != null;

  bool get hasCompleteMarks =>
      hasTheory && hasTeacherAssessment;
}