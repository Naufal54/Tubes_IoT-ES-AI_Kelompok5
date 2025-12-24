import 'package:flutter/material.dart';
import 'package:eldercare/core/constants/icons.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

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
      onTap: onTap,
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
