import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class HomeInfo {
  // Notifier terpusat untuk memantau perubahan data dashboard
  static final ValueNotifier<int> onUpdate = ValueNotifier(0);

  static void update() {
    onUpdate.value++;
  }

  // Data Dashboard
  static String currentStatus = '-';
  static String lastUpdate = '-';
  static List<Map<String, String>> history = [];
  static LatLng location = const LatLng(-6.9690, 107.6282); // Default location
}