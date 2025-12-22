import 'package:flutter/material.dart';
import 'package:fall_detection_app/core/constants/colors.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            Navigator.pop(context); // kembali ke halaman sebelumnya
          },
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(color: AppColors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Contoh daftar notifikasi
            Card(
              child: ListTile(
                leading: const Icon(Icons.warning, color: AppColors.danger),
                title: const Text('Fall detected!'),
                subtitle: const Text('Today, 08:45 AM'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.warning, color: AppColors.danger),
                title: const Text('Fall detected!'),
                subtitle: const Text('Yesterday, 10:30 PM'),
              ),
            ),
            // Tambahkan notifikasi lainnya sesuai kebutuhan
          ],
        ),
      ),
    );
  }
}
