import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/colors.dart';
import '../../../../providers/teams_provider.dart';
import 'base_card.dart';
import '../../../../models/team_model.dart';

class TeamsCard extends ConsumerWidget {
  const TeamsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(myTeamsProvider);

    return InkWell(
      onTap: () => context.push('/teams'),
      child: BaseCard(
        color: AppColors.mint,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Teams',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            teamsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Text('Error loading teams: $e'),
              data: (teams) {
                if (teams.isEmpty) {
                  return const Text(
                    'You are not part of any team',
                    style: TextStyle(color: AppColors.textMuted),
                  );
                }

                /// ✅ Use Column instead of ListView (fixes web hit-test crash)
                return Column(
                  children: teams
                      .map((team) => _TeamItem(team: team))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamItem extends ConsumerWidget {
  final Team team;

  const _TeamItem({required this.team});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadAsync = ref.watch(unreadCountProvider(team.id));

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            team.category,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
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

              unreadAsync.when(
                data: (count) {
                  if (count == 0) return const SizedBox();
                  return Text(
                    '+$count',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  );
                },
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}