import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/exam_repository.dart';
import '../models/exam.dart';

/// Repository provider
final examRepositoryProvider = Provider<ExamRepository>((ref) {
  return ExamRepository(Supabase.instance.client);
});

/// ✅ THIS is what returns AsyncValue<int>
final upcomingExamCountProvider = FutureProvider<int>((ref) async {
  return ref.read(examRepositoryProvider).getUpcomingExamCount();
});


final upcomingExamsProvider = FutureProvider<List<Exam>>((ref) async {
  return ref.read(examRepositoryProvider).getUpcomingExams();
});