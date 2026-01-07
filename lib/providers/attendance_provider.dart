import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../repositories/attendance_repository.dart';
import '../models/subject_attendance.dart';

final attendanceRepositoryProvider =
    Provider<AttendanceRepository>((ref) {
  return AttendanceRepository(Supabase.instance.client);
});

/// 🔹 Attendance of current semester (Semester 7 for now)
final semesterAttendanceProvider =
    FutureProvider<List<SubjectAttendance>>((ref) async {
  return ref
      .read(attendanceRepositoryProvider)
      .getSemesterAttendance(semester: 7);
});

/// 🔹 Overall attendance percentage
final overallAttendanceProvider = Provider<double>((ref) {
  final attendanceAsync = ref.watch(semesterAttendanceProvider);

  return attendanceAsync.maybeWhen(
    data: (subjects) => ref
        .read(attendanceRepositoryProvider)
        .calculateOverallAttendance(subjects),
    orElse: () => 0,
  );
});