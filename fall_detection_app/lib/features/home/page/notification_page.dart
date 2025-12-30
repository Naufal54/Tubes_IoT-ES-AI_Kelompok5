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

  // Helper function untuk mendapatkan warna berdasarkan status
  Color getStatusColor(String status) {
    final statusLower = status.toLowerCase().trim();
    if (statusLower.contains('normal')) {
      return AppColors.safe;
    } else if (statusLower.contains('risiko') || statusLower.contains('risk')) {
      return AppColors.warning;
    } else if (statusLower.contains('jatuh') || statusLower.contains('fall')) {
      return AppColors.danger;
    }
    return AppColors.grey;
  }

  // Helper function untuk mendapatkan icon berdasarkan status
  IconData getStatusIcon(String status) {
    final statusLower = status.toLowerCase().trim();
    if (statusLower.contains('normal')) {
      return Icons.check_circle;
    } else if (statusLower.contains('risiko') || statusLower.contains('risk')) {
      return Icons.warning;
    } else if (statusLower.contains('jatuh') || statusLower.contains('fall')) {
      return Icons.error;
    }
    return Icons.info;
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
              final status = item['status'] ?? 'Unknown';
              final statusColor = getStatusColor(status);
              final statusIcon = getStatusIcon(status);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    // ignore: deprecated_member_use
                    backgroundColor: statusColor.withOpacity(0.1),
                    child: Icon(
                      statusIcon,
                      color: statusColor,
                    ),
                  ),
                  title: Text(
                    status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: statusColor,
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
