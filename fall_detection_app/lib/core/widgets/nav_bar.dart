import 'package:flutter/material.dart';
import 'package:fall_detection_app/app/routes.dart';
import 'package:fall_detection_app/core/constants/icons.dart';

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

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue[800],
      unselectedItemColor: Colors.grey,
      onTap: (index) => _onTap(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(AppIcons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(AppIcons.emergency),
          label: 'Emergency',
        ),
        BottomNavigationBarItem(
          icon: Icon(AppIcons.profile),
          label: 'Profile',
        ),
        
      ],
    );
  }
}
