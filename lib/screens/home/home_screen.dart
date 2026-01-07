import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../widget/app_sidebar.dart';
import '../../providers/schedule_provider.dart';

import 'package:go_router/go_router.dart';
import 'package:my_scheduler/screens/home/widgets/greeting_section.dart';
import 'package:my_scheduler/screens/home/widgets/data_cards_section.dart';
import 'package:my_scheduler/screens/home/widgets/date_header.dart';
import 'package:my_scheduler/screens/home/widgets/timeline_section.dart';

import 'package:my_scheduler/screens/home/widgets/hamburger.dart';
import 'package:my_scheduler/screens/home/widgets/user_avatar.dart';

import 'package:my_scheduler/widgets/custom_app_bar.dart';
import 'package:my_scheduler/core/constants/colors.dart';
import 'package:my_scheduler/core/constants/text_styles.dart';

// Global key for drawer (used by hamburger)
final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();
    final weekday = today.weekday;

    final scheduleAsync = ref.watch(scheduleForDayProvider(weekday));

    return Scaffold(
      key: homeScaffoldKey,
      drawer: const AppSidebar(),
      appBar: CustomAppBar(
        centerTitle: true,

        leading: SizedBox(
          height: double.infinity,
          child: Center(
            child: SizedBox(width: 48, height: 48, child: Hamburger()),
          ),
        ),
        customTitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('myScheduler', style: AppTextStyles.accent),

            Baseline(
              baseline: 16,
              baselineType: TextBaseline.alphabetic,
              child: CircleAvatar(radius: 4, backgroundColor: AppColors.accent),
            ),
          ],
        ),

        actions: [
          InkWell(
            onTap: () => context.push('/settings'),
            child: Stack(
              clipBehavior: Clip.none,
              children: const [
                UserAvatar(size: 32),

                Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          children: [
            const GreetingSection(),
            const SizedBox(height: AppSpacing.gap),

            const DataCardsSection(),
            const SizedBox(height: AppSpacing.gap),

            const DateHeader(),
            const SizedBox(height: AppSpacing.gap),

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
