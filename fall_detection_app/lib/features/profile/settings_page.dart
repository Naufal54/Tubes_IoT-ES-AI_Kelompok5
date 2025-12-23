import 'package:flutter/material.dart';
import 'package:fall_detection_app/core/constants/colors.dart';
import 'package:fall_detection_app/core/constants/user_info.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.notifications_active),
            title: const Text('Notifikasi'),
            subtitle: const Text('Atur preferensi notifikasi'),
            trailing: Switch(
              value: UserInfo.isNotificationOn,
              activeThumbColor: AppColors.primaryBlue,
              onChanged: (val) {
                setState(() {
                  UserInfo.isNotificationOn = val;
                });
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Tentang Aplikasi'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
