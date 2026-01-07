import 'package:flutter/material.dart';
import '../core/utils/color_cycler.dart';

class TimelineEvent {
  final TimeOfDay start;
  final TimeOfDay end;
  final String title;
  final String type;
  final String venue; // ✅ NEW
  final Color color;

  TimelineEvent({
    required this.start,
    required this.end,
    required this.title,
    required this.type,
    required this.venue,
    required this.color,
  });

  factory TimelineEvent.fromMap(
    Map<String, dynamic> map,
    int colorIndex,
  ) {
    final start = map['start_time'] as String; // "09:00:00"
    final end = map['end_time'] as String;

    TimeOfDay parseTime(String t) {
      final parts = t.split(':');
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }

    return TimelineEvent(
      start: parseTime(start),
      end: parseTime(end),
      title: map['subjects']['subject_name'],
      type: 'Lecture', // can extend later
      venue: map['venue'] ?? 'TBD', // ✅ NEW
      color: ColorCycler.byIndex(colorIndex),
    );
  }
}