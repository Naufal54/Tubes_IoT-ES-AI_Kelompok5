import 'package:flutter/material.dart';
import 'package:eldercare/core/constants/user_info.dart';
import 'package:eldercare/features/home/notification_page.dart';
import 'package:eldercare/features/home/map_container.dart';
import 'package:eldercare/features/home/status_container.dart';
import 'package:eldercare/core/constants/colors.dart';
import 'package:eldercare/core/widgets/nav_bar.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: SafeArea(
        child: _homeContent(),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }

  Widget _homeContent() {
  return Column(
    children: [
      // ===== HEADER =====
      Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
        child: Column(
          children: [
            // Title & Notification
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fall Detection App',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textWhitePrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Welcome ${UserInfo.username}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textWhiteSecondary,
                      ),
                    ),
                  ],
                ),
                // Notification icon
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondaryBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationPage(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.notifications,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),

      // ===== STATUS + RIWAYAT CONTAINER =====
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: StatusRiwayatContainer(
          currentStatus: 'Normal',
          lastUpdate: '10:32 AM',
          history: [
            {'time': '10:15 AM', 'status': 'Normal'},
            {'time': '09:50 AM', 'status': 'Jatuh Terdeteksi'},
            {'time': '09:00 AM', 'status': 'Jatuh Terdeteksi'},
          ],
        ),
      ),

      const SizedBox(height: 8),

      // ===== CONTENT AREA (MAP) =====
      Expanded(
        child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          child: Container(
            color: AppColors.cardBackground,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location Tracking',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: MapContainer(
                    initialPosition: const LatLng(-6.9690, 107.6282), 
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
}