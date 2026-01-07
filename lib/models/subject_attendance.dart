class SubjectAttendance {
  final String subjectId;
  final String subjectCode;
  final String subjectName;

  final int total;
  final int attended;
  final int missed;
  final int cancelled;
  final int extra;

  SubjectAttendance({
    required this.subjectId,
    required this.subjectCode,
    required this.subjectName,
    required this.total,
    required this.attended,
    required this.missed,
    required this.cancelled,
    required this.extra,
  });

  double get percentage {
    if (total == 0) return 0;
    return (attended / total) * 100;
  }

  factory SubjectAttendance.fromMap(Map<String, dynamic> map) {
    final subject = map['subjects'] as Map<String, dynamic>;

    return SubjectAttendance(
      subjectId: map['subject_id'],
      subjectCode: subject['subject_code'],
      subjectName: subject['subject_name'],
      total: map['total_classes'],
      attended: map['attended'],
      missed: map['missed'],
      cancelled: map['cancelled'],
      extra: map['extra'],
    );
  }
}