import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../home/widgets/timeline_section.dart';
import '../../providers/schedule_provider.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/spacing.dart';
import 'package:intl/intl.dart';
import 'package:my_scheduler/widgets/custom_app_bar.dart';

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
    final scheduleAsync = ref.watch(scheduleForDayProvider(weekday));

    return Scaffold(
      appBar: CustomAppBar(title: 'Schedule',),
      body: SafeArea(
        child: SingleChildScrollView(
          // ✅ makes whole screen scrollable
          child: Column(
            children: [
              // 📅 Calendar
              TableCalendar(
                daysOfWeekVisible: false,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: AppTextStyles.accent.copyWith(
                    color: AppColors.body,
                  ),
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                ),

                calendarStyle: CalendarStyle(
                  selectedTextStyle: AppTextStyles.bold.copyWith(
                    color: AppColors.accent,
                  ),

                  todayTextStyle: AppTextStyles.bold.copyWith(
                    color: AppColors.accent,
                  ),
                ),

                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    final weekdayLabel = DateFormat.E().format(day);

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${day.day}',
                          style: AppTextStyles.bold.copyWith(
                            color: AppColors.body,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          weekdayLabel,
                          style: AppTextStyles.assist.copyWith(
                            color: AppColors.body,
                          ),
                        ),
                      ],
                    );
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    final weekdayLabel = DateFormat.E().format(day);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${day.day}',
                          style: AppTextStyles.bold.copyWith(
                            color: AppColors.chartTrue,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          weekdayLabel,
                          style: AppTextStyles.assist.copyWith(
                            color: AppColors.chartTrue,
                          ),
                        ),
                      ],
                    );
                  },
                  todayBuilder: (context, day, focusedDay) {
                    final weekdayLabel = DateFormat.E().format(day);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${day.day}',
                          style: AppTextStyles.bold.copyWith(
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          weekdayLabel,
                          style: AppTextStyles.assist.copyWith(
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,

                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },

                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
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
