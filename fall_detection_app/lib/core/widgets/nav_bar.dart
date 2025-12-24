import 'package:flutter/material.dart';
import 'package:eldercare/app/routes.dart';
import 'package:eldercare/core/constants/icons.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.emergency);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.profile);
        break;
    }
  }

  BottomNavigationBarItem _buildItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          // Garis biru di atas jika aktif
          Container(
            height: 3,
            width: 30,
            decoration: BoxDecoration(
              color: currentIndex == index ? Colors.blue[800] : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 4),
          Icon(icon),
        ],
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue[800],
      unselectedItemColor: Colors.grey,
      onTap: (index) => _onTap(context, index),
      items: [
        _buildItem(AppIcons.home, 'Home', 0),
        _buildItem(AppIcons.emergency, 'Emergency', 1),
        _buildItem(AppIcons.profile, 'Profile', 2),
      ],
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
    );
  }
}
