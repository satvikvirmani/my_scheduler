import 'package:flutter/material.dart';

class SettingsFooter extends StatelessWidget {
  final VoidCallback onSignOut;

  const SettingsFooter({super.key, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // ✅ important
      children: [
        const Divider(),

        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: onSignOut,
            child: const Text(
              'Sign out',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}