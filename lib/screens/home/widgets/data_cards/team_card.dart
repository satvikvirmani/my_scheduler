import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_scheduler/core/constants/text_styles.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/spacing.dart';
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
        color: AppColors.card2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Teams',
              style: AppTextStyles.body.copyWith(color: AppColors.body),
            ),
            const SizedBox(height: AppSpacing.gap),

            teamsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text(
                'Error loading teams: $e',
                style: AppTextStyles.assist.copyWith(color: AppColors.body),
              ),
              data: (teams) {
                if (teams.isEmpty) {
                  return Text(
                    'You are not part of any team',
                    style: AppTextStyles.assist.copyWith(color: AppColors.body),
                  );
                }

                return Column(
                  children: teams.map((team) => _TeamItem(team: team)).toList(),
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
      padding: const EdgeInsets.only(bottom: AppSpacing.gap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            team.category,
            style: AppTextStyles.assist.copyWith(color: AppColors.body),
          ),
          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  team.name,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: AppTextStyles.bold.copyWith(color: AppColors.body),
                ),
              ),

              unreadAsync.when(
                data: (count) {
                  if (count == 0) return const SizedBox();
                  return Text(
                    '+$count',
                    style: AppTextStyles.assist.copyWith(color: AppColors.body),
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
