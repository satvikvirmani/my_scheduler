import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/team_repository.dart';
import '../models/team_message.dart';
import '../models/team_model.dart';

final teamsRepositoryProvider = Provider<TeamsRepository>((ref) {
  return TeamsRepository(Supabase.instance.client);
});

/// Stream messages for a team
final teamMessagesProvider =
    StreamProvider.family<List<TeamMessage>, String>((ref, teamId) {
  final repo = ref.read(teamsRepositoryProvider);
  return repo.subscribeToMessages(teamId);
});

final unreadCountProvider =
    FutureProvider.family<int, String>((ref, teamId) {
  return ref.read(teamsRepositoryProvider).getUnreadCount(teamId);
});

final myTeamsProvider = FutureProvider<List<Team>>((ref) {
  return ref.read(teamsRepositoryProvider).getMyTeams();
});