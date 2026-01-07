import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../home/widgets/timeline_section.dart';
import '../../providers/schedule_provider.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  static final DateTime kFirstDay = DateTime(2026, 1, 1);
  static final DateTime kLastDay = DateTime(2026, 12, 31);

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Weekday: Monday = 1 ... Sunday = 7
    final weekday = _selectedDay.weekday;

    // ✅ Fetch real schedule from Supabase
    final scheduleAsync = ref.watch(
      scheduleForDayProvider(weekday),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // ✅ makes whole screen scrollable
          child: Column(
            children: [
              // 📅 Calendar
              TableCalendar(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,

                selectedDayPredicate: (day) =>
                    isSameDay(_selectedDay, day),

                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },

                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },

                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month'
                },
              ),

              const SizedBox(height: 16),

              // 🕒 Timeline (REAL DATA)
              scheduleAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Error loading schedule: $e'),
                ),
                data: (events) {
                  if (events.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('No classes for this day'),
                    );
                  }

                  return TimelineSection(events: events);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}