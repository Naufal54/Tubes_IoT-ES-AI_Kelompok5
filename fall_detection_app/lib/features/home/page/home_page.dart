import 'package:flutter/material.dart';
import 'package:eldercare/core/constants/colors.dart';
import 'package:eldercare/core/constants/user_info.dart';
import 'package:eldercare/features/home/page/notification_page.dart';
import 'package:eldercare/features/home/container/map_container.dart';
import 'package:eldercare/features/home/container/status_container.dart';
import 'package:eldercare/features/home/controller/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            if (_controller.isLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }
            return RefreshIndicator(
              color: AppColors.primaryBlue,
              onRefresh: () async {
                UserInfo.update(); 
                await Future.delayed(const Duration(seconds: 1));
              },
              child: _homeContent(),
            );
          },
        ),
      ),
    );
  }

  Widget _homeContent() {
  // Menggunakan ListView agar bisa di-scroll (syarat RefreshIndicator)
  return ListView(
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
          currentStatus: _controller.currentStatus,
          lastUpdate: _controller.lastUpdate,
          history: _controller.history,
        ),
      ),

      const SizedBox(height: 8),

      // ===== CONTENT AREA (MAP) =====
      SizedBox(
        height: 400, // Memberikan tinggi tetap agar peta tampil di dalam ListView
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
                    initialPosition: _controller.initialLocation, 
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