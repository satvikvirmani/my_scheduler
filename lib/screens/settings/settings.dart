import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/spacing.dart';
import 'widgets/avatar_section.dart';
import 'widgets/profile_form.dart';
import 'widgets/settings_footer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _loading = true;
  bool _saving = false;

  late final String email;
  String? avatarUrl;

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    email = supabase.auth.currentUser?.email ?? '';
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final profile = await supabase
        .from('profiles')
        .select('full_name, phone, avatar_url')
        .eq('id', user.id)
        .maybeSingle();

    if (profile != null) {
      _nameController.text = (profile['full_name'] ?? '').toString();
      _phoneController.text = (profile['phone'] ?? '').toString();
      avatarUrl = profile['avatar_url'] as String?;
    }

    if (mounted) setState(() => _loading = false);
  }

  Future<void> _updateProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    setState(() => _saving = true);

    await supabase
        .from('profiles')
        .update({
          'full_name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', user.id);

    if (mounted) setState(() => _saving = false);
  }

  Future<void> _signOut() async {
    await supabase.auth.signOut();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            children: [
              AvatarSection(avatarUrl: avatarUrl),

              const SizedBox(height: 32),

              ProfileForm(
                nameController: _nameController,
                phoneController: _phoneController,
                email: email,
                saving: _saving,
                onSave: _updateProfile,
              ),

              const Spacer(), // ✅ SAFE here (parent has bounded height)

              SettingsFooter(onSignOut: _signOut),
            ],
          ),
        ),
      ),
    );
  }
}
