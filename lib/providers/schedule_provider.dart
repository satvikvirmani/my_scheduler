import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../repositories/schedule_repository.dart';
import '../models/timeline_event.dart';

final scheduleRepositoryProvider =
    Provider<ScheduleRepository>((ref) {
  return ScheduleRepository(Supabase.instance.client);
});

/// 🔹 Fetch schedule for a weekday
final scheduleForDayProvider =
    FutureProvider.family<List<TimelineEvent>, int>((ref, weekday) async {
  return ref
      .read(scheduleRepositoryProvider)
      .getScheduleForDay(weekday: weekday);
});