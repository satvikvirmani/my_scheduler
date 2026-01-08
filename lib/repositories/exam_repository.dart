import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/exam.dart';

class ExamRepository {
  final SupabaseClient _supabase;

  ExamRepository(this._supabase);

  Future<int> getUpcomingExamCount() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return 0;

    final profile = await _supabase
        .from('profiles')
        .select('branch_id, section, subsection')
        .eq('id', user.id)
        .single();

    final today = DateTime.now().toIso8601String().split('T').first;

    final exams = await _supabase
        .from('exams')
        .select('id')
        .eq('branch_id', profile['branch_id'])
        .eq('section', profile['section'])
        .eq('subsection', profile['subsection'])
        .gte('exam_date', today);

    return exams.length;
  }

    Future<List<Exam>> getUpcomingExams() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    // Fetch profile once
    final profile = await _supabase
        .from('profiles')
        .select('branch_id, section, subsection')
        .eq('id', user.id)
        .single();

    final today = DateTime.now().toIso8601String().split('T').first;

    final res = await _supabase
        .from('exams')
        .select('''
          id,
          exam_date,
          category,
          venue,
          start_time,
          end_time,
          subjects (
            subject_name,
            subject_code
          )
        ''')
        .eq('branch_id', profile['branch_id'])
        .eq('section', profile['section'])
        .eq('subsection', profile['subsection'])
        .gte('exam_date', today)
        .order('exam_date', ascending: true)
        .order('start_time');

    return (res as List)
        .map((e) => Exam.fromMap(e))
        .toList();
  }
}