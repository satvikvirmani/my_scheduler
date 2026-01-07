import 'package:flutter/material.dart';
import 'data_cards/attendence_card.dart';
import 'data_cards/team_card.dart';
import 'data_cards/upcoming_card.dart';
import 'package:my_scheduler/core/constants/spacing.dart';

class DataCardsSection extends StatelessWidget {
  const DataCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                children: [
                  UpcomingCard(),
                  const SizedBox(height: AppSpacing.gap),
                  AttendanceCard(),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.gap),
            Expanded(child: TeamsCard()),
          ],
        ),
      ),
    );
  }
}
