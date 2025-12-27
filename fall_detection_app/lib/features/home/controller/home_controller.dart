import 'package:eldercare/features/emergency/controller/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:eldercare/services/home_service.dart';
import 'package:latlong2/latlong.dart';

class HomeController extends ChangeNotifier {
  final HomeService _service = HomeService();

  // State Variables
  bool isLoading = true;
  String currentStatus = '-';
  String lastUpdate = '-';
  List<Map<String, String>> history = [];
  LatLng initialLocation = const LatLng(-6.9690, 107.6282); // Default location

  HomeController() {
    userUpdateNotifier.addListener(loadData);
  }

  @override
  void dispose() {
    userUpdateNotifier.removeListener(loadData);
    super.dispose();
  }

  // Method untuk memuat data
  Future<void> loadData() async {
    debugPrint("HomeController: Memulai loadData...");
    isLoading = true;
    notifyListeners(); // Beritahu UI untuk menampilkan loading

    try {
      debugPrint("HomeController: Mengambil data dari service...");
      final data = await _service.getDashboardData();
      
      currentStatus = data['status'];
      lastUpdate = data['lastUpdate'];
      
      // Konversi List dynamic ke List<Map<String, String>>
      final List<dynamic> historyData = data['history'];
      history = historyData.map((item) => Map<String, String>.from(item)).toList();
      
      initialLocation = data['location'];
      debugPrint("HomeController: Data berhasil dimuat.");
      
    } catch (e) {
      debugPrint('Error loading home data: $e');
      currentStatus = 'Error';
    } finally {
      debugPrint("HomeController: Selesai, mematikan loading.");
      isLoading = false;
      notifyListeners(); // Beritahu UI data sudah siap
    }
  }
}