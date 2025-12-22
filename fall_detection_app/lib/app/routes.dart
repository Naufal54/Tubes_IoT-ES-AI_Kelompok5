import 'package:flutter/material.dart';
import 'package:fall_detection_app/features/emergency/emergency_page.dart';
import 'package:fall_detection_app/features/home/home_page.dart';
import 'package:fall_detection_app/features/profile/profile_page.dart';

class AppRoutes {
  static const home = '/';
  static const emergency = '/emergency';
  static const profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case emergency:
        return MaterialPageRoute(builder: (_) => const EmergencyPage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
