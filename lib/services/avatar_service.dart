import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class AvatarService {
  final SupabaseClient _client;

  AvatarService(this._client);

  Future<String> uploadAvatar({
    required Uint8List bytes,
    required String userId,
  }) async {
    final filePath = '$userId.png';

    await _client.storage.from('avatars').uploadBinary(
      filePath,
      bytes,
      fileOptions: const FileOptions(upsert: true),
    );

final baseUrl =
    _client.storage.from('avatars').getPublicUrl(filePath);

// ✅ Add cache-busting query param
return '$baseUrl?v=${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> saveAvatarUrl({
    required String userId,
    required String avatarUrl,
  }) async {
    await _client.from('profiles').update({
      'avatar_url': avatarUrl,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);
  }
}