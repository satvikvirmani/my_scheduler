import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/colors.dart';

class UserAvatar extends StatefulWidget {
  const UserAvatar({super.key, this.size = 32});

  final double size;

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  String? _avatarUrl;
  bool _loading = true;

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final profile = await supabase
          .from('profiles')
          .select('avatar_url')
          .eq('id', user.id)
          .maybeSingle();

      if (mounted) {
        setState(() {
          _avatarUrl = profile?['avatar_url'] as String?;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('Failed to load avatar: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size;

    return GestureDetector(
      onTap: () {
        // Optional: open settings page
        context.push('/settings');
      },
      child: SizedBox(
        width: size,
        height: size,
        child: ClipOval(
          child: _loading
              ? Container(color: AppColors.mint)
              : _avatarUrl != null
              ? Image.network(
                  Uri.encodeFull(_avatarUrl!),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  errorBuilder: (_, __, ___) => _placeholder(),
                )
              : _placeholder(),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.mint,
      child: Icon(Icons.person, size: widget.size * 0.6),
    );
  }
}
