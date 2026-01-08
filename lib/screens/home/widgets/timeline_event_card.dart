import 'package:flutter/material.dart';
import '../../../core/constants/spacing.dart';
import '../../../core/utils/time_utils.dart';
import '../../../models/timeline_event.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';

class TimelineEventCard extends StatelessWidget {
  final TimelineEvent event;

  const TimelineEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: event.color,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ───────── Row 1 ─────────
          Row(
            children: [
              // Type (left)
              Expanded(
                child: Text(
                  event.type,
                  style: AppTextStyles.assist.copyWith(color: AppColors.body),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Venue (right)
              Text(
                event.venue,
                style: AppTextStyles.assist.copyWith(color: AppColors.body),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),

          const Spacer(),

          // ───────── Row 2 ─────────
          Row(
            children: [
              // Title (left)
              Expanded(
                child: Text(
                  event.title,
                  style: AppTextStyles.bodyEmphasis.copyWith(
                    color: AppColors.body,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Text(
                '${formatTime(event.start)} - ${formatTime(event.end)}',
                style: AppTextStyles.assist.copyWith(color: AppColors.body),
                maxLines: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
