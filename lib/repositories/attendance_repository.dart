import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/subject_attendance.dart';

class AttendanceRepository {
  final SupabaseClient _supabase;

  AttendanceRepository(this._supabase);

Future<List<SubjectAttendance>> getSemesterAttendance({
  required int semester, // kept for future
}) async {
  final user = _supabase.auth.currentUser;
  if (user == null) return [];

  final res = await _supabase
      .from('attendance')
      .select('''
        subject_id,
        total_classes,
        attended,
        missed,
        cancelled,
        extra,
        subjects (
          subject_code,
          subject_name
        )
      ''')
      .eq('user_id', user.id);

  return (res as List)
      .map((e) => SubjectAttendance.fromMap(e))
      .toList();
}
double calculateOverallAttendance(
  List<SubjectAttendance> subjects,
) {
  if (subjects.isEmpty) return 0;

  int totalClasses = 0;
  int totalAttended = 0;

  for (final s in subjects) {
    totalClasses += s.total;
    totalAttended += s.attended;
  }

  if (totalClasses == 0) return 0;

  return (totalAttended / totalClasses);
}
}