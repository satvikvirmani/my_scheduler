import 'package:flutter/material.dart';
import '../../../core/constants/spacing.dart';
import '../../../core/utils/time_utils.dart';
import '../../../models/timeline_event.dart';
import 'timeline_event_card.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';

class TimelineSection extends StatelessWidget {
  const TimelineSection({super.key, required this.events});

  final List<TimelineEvent> events;

  static const int startHour = 8;
  static const int endHour = 18;

  @override
  Widget build(BuildContext context) {
    final totalHeight =
        (endHour - startHour + 1) * AppSpacing.timelineHourHeight;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        children: [
          // Hour lines
          for (int h = startHour; h <= endHour; h++)
            Positioned(
              top: (h - startHour) * AppSpacing.timelineHourHeight,
              left: 0,
              right: 0,
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Text('${h.toString().padLeft(2, '0')}:00', style: AppTextStyles.assist.copyWith(color: AppColors.subHeading),),
                  ),
                  const Expanded(child: Divider(color: AppColors.subHeading,)),
                ],
              ),
            ),

          // Events
          for (final e in events)
            Positioned(
              top: timeToOffset(
                e.start,
                startHour,
                AppSpacing.timelineHourHeight,
              ) + AppSpacing.eventInset,
              left: 50,
              right: 0,
              height: durationToHeight(
                e.start,
                e.end,
                AppSpacing.timelineHourHeight,
              ),
              child: TimelineEventCard(event: e),
            ),
        ],
      ),
    );
  }
}