import 'package:eldercare/core/constants/colors.dart';
import 'package:eldercare/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:eldercare/core/widgets/app_bar.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController _controller = ProfileController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          appBar: const AppBarWidget(title: 'Profile'),
          body: SafeArea(
            child: _profileContent(),
          ),
        );
      },
    );
  }

  Widget _profileContent() {
    return ListView(
        padding: const EdgeInsets.all(8.0),
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
                          leading: const Icon(Icons.person, color: AppColors.primaryBlue),
                          title: const Text('Nama Pengguna'),
                          subtitle: Text(_controller.username),
                        ),
                        ListTile(
                          leading: const Icon(Icons.email, color: Colors.green),
                          title: const Text('Email'),
                          subtitle: Text(_controller.email),
                        ),
                        ListTile(
                          leading: const Icon(Icons.phone, color: Colors.orange),
                          title: const Text('Nomor Telepon'),
                          subtitle: Text(_controller.phoneNumber),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.tertiaryBlue,
                  child: Icon(Icons.person, size: 36, color: AppColors.primaryBlue),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_controller.username, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(_controller.email, style: TextStyle(color: Colors.grey[600])),
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
              onTap: () {
                context.go('/profile/edit-profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                context.go('/profile/settings');
              },
            ),
            ListTile(leading: Icon(Icons.logout), title: Text('Logout')),
        ],
    );
  }
}
