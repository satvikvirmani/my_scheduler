class Exam {
  final String id;
  final DateTime date;
  final String category;
  final String subjectName;
  final String subjectCode;
  final String venue;
  final DateTime startTime;
  final DateTime endTime;

  Exam({
    required this.id,
    required this.date,
    required this.category,
    required this.subjectName,
    required this.subjectCode,
    required this.venue,
    required this.startTime,
    required this.endTime,
  });

  factory Exam.fromMap(Map<String, dynamic> map) {
    return Exam(
      id: map['id'],
      date: DateTime.parse(map['exam_date']),
      category: map['category'],
      subjectName: map['subjects']['subject_name'],
      subjectCode: map['subjects']['subject_code'],
      venue: map['venue'],
      startTime: DateTime.parse(
        '${map['exam_date']} ${map['start_time']}',
      ),
      endTime: DateTime.parse(
        '${map['exam_date']} ${map['end_time']}',
      ),
    );
  }
}