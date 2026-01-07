import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../widget/app_sidebar.dart';
import '../../providers/schedule_provider.dart';

import 'widgets/top_bar.dart';
import 'widgets/greeting_section.dart';
import 'widgets/data_cards_section.dart';
import 'widgets/date_header.dart';
import 'widgets/timeline_section.dart';

// Global key for drawer (used by hamburger)
final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();
    final weekday = today.weekday;

    // ✅ Fetch today's schedule from Supabase
    final scheduleAsync = ref.watch(
      scheduleForDayProvider(weekday),
    );

    return Scaffold(
      key: homeScaffoldKey,
      drawer: const AppSidebar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          children: [
            const TopBar(),
            const SizedBox(height: AppSpacing.sectionGap),

            const GreetingSection(),
            const SizedBox(height: AppSpacing.sectionGap),

            const DataCardsSection(),
            const SizedBox(height: AppSpacing.sectionGap),

            const DateHeader(),
            const SizedBox(height: AppSpacing.sectionGap),

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
                    child: Text('No classes today'),
                  );
                }

                return TimelineSection(events: events);
              },
            ),
          ],
        ),
      ),
    );
  }
}