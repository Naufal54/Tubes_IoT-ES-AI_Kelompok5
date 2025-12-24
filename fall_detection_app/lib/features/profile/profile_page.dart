import 'package:flutter/material.dart';
import 'package:eldercare/core/constants/user_info.dart';
import 'package:eldercare/core/widgets/app_bar.dart';
import 'package:eldercare/core/widgets/nav_bar.dart';
import 'package:eldercare/features/profile/edit_profile_page.dart';
import 'package:eldercare/features/profile/settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Profile'),
      body: SafeArea(
        child: _profileContent(),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }

  Widget _profileContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(height: 8),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Pengguna',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        ListTile(
                          leading: const Icon(Icons.person, color: Colors.blue),
                          title: const Text('Nama Pengguna'),
                          subtitle: Text(UserInfo.username),
                        ),
                        ListTile(
                          leading: const Icon(Icons.email, color: Colors.green),
                          title: const Text('Email'),
                          subtitle: Text(UserInfo.email),
                        ),
                        ListTile(
                          leading: const Icon(Icons.phone, color: Colors.orange),
                          title: const Text('Nomor Telepon'),
                          subtitle: Text(UserInfo.phoneNumber),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Row(
              children: [
                CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(UserInfo.username, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(UserInfo.email, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ),
            const SizedBox(height: 10),
            const Divider(thickness: 1, color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfilePage()),
                );
                if (result == true) {
                  setState(() {});
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            ListTile(leading: Icon(Icons.logout), title: Text('Logout')),
        ],
      ),
    );
  }
}
