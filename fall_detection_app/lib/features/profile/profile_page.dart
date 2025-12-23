import 'package:fall_detection_app/core/constants/user_info.dart';
import 'package:fall_detection_app/core/widgets/app_bar.dart';
import 'package:fall_detection_app/core/widgets/nav_bar.dart';
import 'package:fall_detection_app/features/profile/edit_profile_page.dart';
import 'package:flutter/material.dart';

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
          Row(
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
            const SizedBox(height: 20),
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
            ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
            ListTile(leading: Icon(Icons.logout), title: Text('Logout')),
        ],
      ),
    );
  }
}
