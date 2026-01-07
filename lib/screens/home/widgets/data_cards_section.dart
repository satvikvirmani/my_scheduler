import 'package:flutter/material.dart';
import 'data_cards/attendence_card.dart';
import 'data_cards/team_card.dart';
import 'data_cards/upcoming_card.dart';

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
                  const SizedBox(height: 16),
                  AttendanceCard(),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: TeamsCard()),
          ],
        ),
      ),
    );
  }
}
