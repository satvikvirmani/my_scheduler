import 'package:flutter/material.dart';

String formatTime(TimeOfDay t) {
  final h = t.hour.toString().padLeft(2, '0');
  final m = t.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

double timeToOffset(TimeOfDay t, int startHour, double hourHeight) {
  final minutes = (t.hour - startHour) * 60 + t.minute;
  return (minutes / 60) * hourHeight;
}

double durationToHeight(TimeOfDay s, TimeOfDay e, double hourHeight) {
  final duration =
      (e.hour * 60 + e.minute) - (s.hour * 60 + s.minute);
  return (duration / 60) * hourHeight;
}