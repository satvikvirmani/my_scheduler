import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_scheduler/providers/auth_provider.dart';
import 'package:my_scheduler/widgets/dropdown_input_field.dart';
import 'package:my_scheduler/widgets/text_input_field.dart';
import 'package:my_scheduler/widgets/custom_app_bar.dart';

import 'package:my_scheduler/core/constants/colors.dart';
import 'package:my_scheduler/core/constants/spacing.dart';
import 'package:my_scheduler/core/constants/text_styles.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  String? _selectedBranch;
  String? _selectedSection;
  String? _selectedSubsection;
  bool _isLoading = false;

  final TextEditingController _phoneController = TextEditingController();

  // Dummy branches (match DB `branches` table)
  final Map<String, String> _branches = {
    'CS': 'Computer Engineering',
    'IT': 'Information Technology',
    'ME': 'Mechanical Engineering',
    'CE': 'Civil Engineering',
  };

  /// ✅ Branch → Sections
  final Map<String, List<String>> branchSections = {
    'CS': ['A', 'B'],
    'IT': ['A', 'B', 'C'],
    'ME': ['A'],
    'CE': ['A', 'B'],
  };

  /// ✅ Section → Subsections
  final Map<String, List<String>> sectionSubsections = {
    'CS-A': ['1', '2', '3', '4'],
    'CS-B': ['1', '2', '3'],
    'IT-A': ['1', '2'],
    'IT-B': ['1', '2', '3'],
    'IT-C': ['1'],
    'ME-A': ['1', '2', '3', '4', '5'],
    'CE-A': ['1', '2'],
    'CE-B': ['1', '2', '3'],
  };

  /// 🟢 Dynamic options
  List<String> availableSections = [];
  List<String> availableSubsections = [];

  // -----------------------------
  // 🔄 Handlers
  // -----------------------------

  void onBranchChanged(String? value) {
    setState(() {
      _selectedBranch = value;
      _selectedSection = null;
      _selectedSubsection = null;

      availableSections = branchSections[value] ?? [];
      availableSubsections = [];
    });
  }

  void onSectionChanged(String? value) {
    setState(() {
      _selectedSection = value;
      _selectedSubsection = null;

      final key = '$_selectedBranch-$value';
      availableSubsections = sectionSubsections[key] ?? [];
    });
  }

  // -----------------------------
  // Existing methods unchanged
  // -----------------------------

  Future<void> _saveProfile() async {
    if (_selectedBranch == null ||
        _selectedSection == null ||
        _selectedSubsection == null ||
        _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    if (_phoneController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid phone number')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final branchId = await ref
          .read(authRepositoryProvider)
          .getBranchIdByCode(_selectedBranch!);

      await ref
          .read(authRepositoryProvider)
          .updateProfile(
            branchId: branchId,
            section: _selectedSection!,
            subsection: _selectedSubsection!,
            phone: _phoneController.text.trim(),
          );

      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    if (mounted) context.go('/login');
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // -----------------------------
  // UI
  // -----------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: CustomAppBar(
  title: 'Complete Your Profile',
  actions: [
    IconButton(
      icon: const Icon(Icons.logout),
      onPressed: _signOut,
    ),
  ],
),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Set up your academic profile',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyEmphasis,
            ),
            const SizedBox(height: AppSpacing.gap),

            DropdownInputField<String>(
              label: 'Branch',
              placeholder: 'Select branch',
              value: _selectedBranch,
              items: _branches.entries
                  .map(
                    (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                  )
                  .toList(),
              onChanged: onBranchChanged,
            ),

            const SizedBox(height: AppSpacing.gap),

            DropdownInputField<String>(
              label: 'Section',
              placeholder: 'Select section',
              value: _selectedSection,
              items: availableSections
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: availableSections.isEmpty ? null : onSectionChanged,
            ),

            const SizedBox(height: AppSpacing.gap),

            // 📗 Subsection (depends on section)
            DropdownInputField<String>(
              label: 'Subsection',
              placeholder: 'Select subsection',
              value: _selectedSubsection,
              items: availableSubsections
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: availableSubsections.isEmpty
                  ? null
                  : (v) => setState(() => _selectedSubsection = v),
            ),

            const SizedBox(height: AppSpacing.gap),

            // 📞 Phone
            TextInputField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              label: 'Phone Number',
            ),

            const SizedBox(height: AppSpacing.gap),

              FilledButton(
                style: FilledButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.fieldXPadding + 5,
                    vertical: AppSpacing.fieldYPadding + 5,
                  ),
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radius),
                  ),
                ),

                onPressed: _isLoading ? null : _saveProfile,

                child: const Text('Save & Continue', style: AppTextStyles.body),
              ),
          ],
        ),
      ),
    );
  }
}
