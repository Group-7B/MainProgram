import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Appearance',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: false,
            onChanged: (value) {},
          ),
          const Divider(),
          const Text('Account',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ListTile(
            title: const Text('Change Password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Privacy Settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}
