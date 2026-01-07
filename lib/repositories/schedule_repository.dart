import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/timeline_event.dart';

class ScheduleRepository {
  final SupabaseClient _supabase;

  ScheduleRepository(this._supabase);

  /// Fetch schedule for a weekday (1 = Monday ... 6 = Saturday)
  Future<List<TimelineEvent>> getScheduleForDay({
    required int weekday,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    // Fetch user's profile for filtering
    final profile = await _supabase
        .from('profiles')
        .select('branch_id, section, subsection')
        .eq('id', user.id)
        .single();

final res = await _supabase
    .from('schedule')
    .select('''
      start_time,
      end_time,
      venue,
      subjects (
        subject_name
      )
    ''')
    .eq('branch_id', profile['branch_id'])
    .eq('section', profile['section'])
    .eq('subsection', profile['subsection'])
    .eq('day_of_week', weekday)
    .order('start_time');

    final list = res as List;

    return List.generate(
      list.length,
      (index) => TimelineEvent.fromMap(list[index], index),
    );
  }
}