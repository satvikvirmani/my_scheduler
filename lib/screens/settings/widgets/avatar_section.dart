import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../services/avatar_service.dart';
import '../../../core/constants/colors.dart';

class AvatarSection extends StatefulWidget {
  final String? avatarUrl;

  const AvatarSection({super.key, this.avatarUrl});

  @override
  State<AvatarSection> createState() => _AvatarSectionState();
}

class _AvatarSectionState extends State<AvatarSection> {
  bool _uploading = false;
  String? _avatarUrl;

  final _picker = ImagePicker();
  final _avatarService = AvatarService(Supabase.instance.client);

  @override
  void initState() {
    super.initState();
    _avatarUrl = widget.avatarUrl;
  }

  Future<void> _pickAndUpload() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() => _uploading = true);

    try {
      final bytes = await image.readAsBytes();

      final url = await _avatarService.uploadAvatar(
        bytes: bytes,
        userId: user.id,
      );

      await _avatarService.saveAvatarUrl(userId: user.id, avatarUrl: url);

      setState(() => _avatarUrl = url);
    } catch (e) {
      debugPrint('Avatar upload failed: $e');
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Widget _placeholderAvatar() {
    return Container(
      color: AppColors.mint,
      child: const Center(child: Icon(Icons.person, size: 48)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _uploading ? null : _pickAndUpload,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            SizedBox(
              width: 104,
              height: 104,
              child: ClipOval(
                child: _avatarUrl != null
                    ? Image.network(
                        Uri.encodeFull(
                          _avatarUrl!,
                        ), // ✅ avoids bad URL encoding issues
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        gaplessPlayback: true,

                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        },

                        errorBuilder: (context, error, stackTrace) {
                          debugPrint('Avatar image error: $error');
                          return _placeholderAvatar();
                        },
                      )
                    : _placeholderAvatar(),
              ),
            ),

            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.black,
              child: _uploading
                  ? const SizedBox(
                      height: 12,
                      width: 12,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.camera_alt, size: 14, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
