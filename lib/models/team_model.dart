class Team {
  final String id;
  final String name;
  final String category;

  Team({
    required this.id,
    required this.name,
    required this.category,
  });

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'],
      name: map['name'],
      category: map['category'],
    );
  }
}