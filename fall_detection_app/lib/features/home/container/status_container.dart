import 'package:flutter/material.dart';
import 'package:eldercare/core/constants/colors.dart';

class StatusRiwayatContainer extends StatelessWidget {
  final String currentStatus;
  final String lastUpdate;
  final List<Map<String, String>> history; 

  const StatusRiwayatContainer({
    super.key,
    required this.currentStatus,
    required this.lastUpdate,
    required this.history,
  });

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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Saat Ini
            Row(
              children: [
                Icon(
                  getStatusIcon(currentStatus),
                  color: getStatusColor(currentStatus),
                  size: 32,
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentStatus,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: getStatusColor(currentStatus),
                      ),
                    ),
                    Text(
                      'Update terakhir: $lastUpdate',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 8),
            // Riwayat Singkat
            Text(
              'Riwayat Singkat',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              children: history.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Text(
                        item['time'] ?? '',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(width: 12),
                      Icon(
                        getStatusIcon(item['status'] ?? ''),
                        color: getStatusColor(item['status'] ?? ''),
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      Text(
                        item['status'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: getStatusColor(item['status'] ?? ''),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
