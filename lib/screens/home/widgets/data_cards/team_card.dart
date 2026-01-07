import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import 'base_card.dart';

class TeamsCard extends StatelessWidget {
  const TeamsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final teams = [
      TeamGroup(
        category: 'Technical Society',
        name: 'I & E Cell',
        count: 2,
      ),
      TeamGroup(
        category: 'Cultural Society',
        name: 'Anamika',
        count: 1,
      ),
      TeamGroup(
        category: 'Sports',
        name: 'Kabaddi',
      ),
      TeamGroup(
        category: 'Cultural Club',
        name: 'MAD',
        count: 2,
      ),
    ];

    return BaseCard(
      color: AppColors.mint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Teams',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Team list
          ...teams.map((team) => _TeamItem(team: team)),
        ],
      ),
    );
  }
}

// =============================
// Team Item Widget
// =============================

class _TeamItem extends StatelessWidget {
  final TeamGroup team;

  const _TeamItem({required this.team});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            team.category,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                team.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (team.count != null)
                Text(
                  '+${team.count}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================
// Simple Model (local for now)
// =============================

class TeamGroup {
  final String category;
  final String name;
  final int? count;

  TeamGroup({
    required this.category,
    required this.name,
    this.count,
  });
}