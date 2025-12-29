import 'package:flutter/material.dart';
import 'package:eldercare/core/constants/colors.dart';
import '../controller/notification_controller.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationController _controller = NotificationController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.notifications.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada notifikasi",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _controller.notifications.length,
            itemBuilder: (context, index) {
              final item = _controller.notifications[index];
              final isFall = item['status'] == 'Jatuh Terdeteksi';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    // ignore: deprecated_member_use
                    backgroundColor: isFall ? AppColors.danger.withOpacity(0.1) : AppColors.primaryBlue.withOpacity(0.1),
                    child: Icon(
                      isFall ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                      color: isFall ? AppColors.danger : AppColors.primaryBlue,
                    ),
                  ),
                  title: Text(
                    item['status'] ?? 'Unknown',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isFall ? AppColors.danger : AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    item['time'] ?? '-',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
