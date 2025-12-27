import 'package:eldercare/features/emergency/page/emergency_page.dart';
import 'package:eldercare/features/home/page/home_page.dart';
import 'package:eldercare/features/profile/page/profile_page.dart';
import 'package:flutter/material.dart';

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
