import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/teams_provider.dart';
import 'widgets/team_card.dart';

class TeamsScreen extends ConsumerWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(myTeamsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Teams")),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
                return TeamCard(
                  team: teams[index],
                  index: index,
                );
              },
            );
          },
        ),
      ),
    );
  }
}