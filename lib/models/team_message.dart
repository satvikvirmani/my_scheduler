class TeamMessage {
  final String id;
  final String teamId;
  final String senderId;
  final String message;
  final DateTime createdAt;

  TeamMessage({
    required this.id,
    required this.teamId,
    required this.senderId,
    required this.message,
    required this.createdAt,
  });

  factory TeamMessage.fromMap(Map<String, dynamic> map) {
    return TeamMessage(
      id: map['id'],
      teamId: map['team_id'],
      senderId: map['sender_id'],
      message: map['message'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}