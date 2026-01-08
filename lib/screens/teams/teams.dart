import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/teams_provider.dart';
import 'widgets/team_card.dart';
import '../../core/constants/spacing.dart';
import '../../widgets/custom_app_bar.dart';

class TeamsScreen extends ConsumerWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(myTeamsProvider);

    return Scaffold(
      appBar: CustomAppBar(title: 'Teams'),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: teamsAsync.when(
          loading: () =>
              const Center(child: CircularProgressIndicator()),

          error: (e, _) => Center(
            child: Text('Error loading teams: $e'),
          ),

          data: (teams) {
            if (teams.isEmpty) {
              return const Center(
                child: Text('You are not part of any team'),
              );
            }

            return ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    TeamCard(
                      team: teams[index],
                      index: index,
                    ),
                    const SizedBox(height: AppSpacing.pagePadding),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}