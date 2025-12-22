import 'package:flutter/material.dart';
import 'package:fall_detection_app/core/widgets/app_bar.dart';
import 'package:fall_detection_app/core/widgets/nav_bar.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Emergency'),
      body: const Center(child: Text('EMERGENCY PAGE')),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }
}
