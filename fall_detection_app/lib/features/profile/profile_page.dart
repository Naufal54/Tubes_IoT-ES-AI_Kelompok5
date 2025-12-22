import 'package:fall_detection_app/core/widgets/app_bar.dart';
import 'package:fall_detection_app/core/widgets/nav_bar.dart';
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
          Row(
            children: [
              CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('User Name', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('user@example.com', style: TextStyle(color: Colors.grey[600])),
                  ],
              ),
            ],
          ),
            SizedBox(height: 20),
            ListTile(leading: Icon(Icons.edit), title: Text('Edit Profile')),
            ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
            ListTile(leading: Icon(Icons.logout), title: Text('Logout')),
        ],
      ),
    );
  }
}
