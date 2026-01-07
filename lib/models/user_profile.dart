class UserProfile {
  final String id;
  final String? fullName;
  final String? email;
  final String? phone;

  final String? branchId;
  final String? section;
  final String? subsection;

  final String? avatarUrl;
  final DateTime? updatedAt;

  UserProfile({
    required this.id,
    this.fullName,
    this.email,
    this.phone,
    this.branchId,
    this.section,
    this.subsection,
    this.avatarUrl,
    this.updatedAt,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      fullName: map['full_name'] as String?,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      branchId: map['branch_id'] as String?,
      section: map['section'] as String?,
      subsection: map['subsection'] as String?,
      avatarUrl: map['avatar_url'] as String?,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'branch_id': branchId,
      'section': section,
      'subsection': subsection,
      'avatar_url': avatarUrl,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}