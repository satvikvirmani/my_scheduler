import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/team_message.dart';
import '../models/team_model.dart';

class TeamsRepository {
  final SupabaseClient _supabase;

  TeamsRepository(this._supabase);

  /// Fetch existing messages
  Future<List<TeamMessage>> fetchMessages(String teamId) async {
    final res = await _supabase
        .from('team_messages')
        .select()
        .eq('team_id', teamId)
        .order('created_at');

    return (res as List).map((e) => TeamMessage.fromMap(e)).toList();
  }

  /// Send message
  Future<void> sendMessage({
    required String teamId,
    required String text,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase.from('team_messages').insert({
      'team_id': teamId,
      'sender_id': user.id,
      'message': text,
    });
  }

  /// Update last seen timestamp
  Future<void> markTeamSeen(String teamId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase
        .from('team_members')
        .update({'last_seen_at': DateTime.now().toUtc().toIso8601String()})
        .eq('team_id', teamId)
        .eq('user_id', user.id);
  }

  /// Count unread messages
  Future<int> getUnreadCount(String teamId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return 0;

    final res = await _supabase.rpc(
      'get_unread_count',
      params: {'p_team_id': teamId, 'p_user_id': user.id},
    );
    
    return res;
  }

  Future<List<Team>> getMyTeams() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    final res = await _supabase
        .from('team_members')
        .select('teams ( id, name, category )')
        .eq('user_id', user.id);

    return (res as List).map((row) => Team.fromMap(row['teams'])).toList();
  }

  /// Realtime stream
  Stream<List<TeamMessage>> subscribeToMessages(String teamId) {
    final controller = StreamController<List<TeamMessage>>();
    final List<TeamMessage> buffer = [];

    final channel = _supabase.channel('team-$teamId');

    /// Initial load
    fetchMessages(teamId).then((initial) {
      buffer.addAll(initial);
      controller.add(List.from(buffer));
    });

    /// Realtime listener
    channel.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'team_messages',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'team_id',
        value: teamId,
      ),
      callback: (payload) {
        final msg = TeamMessage.fromMap(payload.newRecord);
        buffer.add(msg);
        controller.add(List.from(buffer));
      },
    );

    channel.subscribe();

    controller.onCancel = () {
      _supabase.removeChannel(channel);
    };

    return controller.stream;
  }
}
