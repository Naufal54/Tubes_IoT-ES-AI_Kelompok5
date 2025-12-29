import 'package:eldercare/core/constants/user_info.dart';
import 'package:eldercare/core/constants/home_info.dart';
import 'package:flutter/material.dart';
import 'package:eldercare/services/home_service.dart';
import 'package:latlong2/latlong.dart';

class HomeController extends ChangeNotifier {
  final HomeService _service = HomeService();

  // State Variables
  bool isLoading = true;
  
  // Menggunakan getter agar UI tetap bisa mengakses data lewat controller
  String get currentStatus => HomeInfo.currentStatus;
  String get lastUpdate => HomeInfo.lastUpdate;
  // Home page hanya menampilkan 3 riwayat terakhir, tapi data aslinya lengkap di HomeInfo
  List<Map<String, String>> get history => HomeInfo.history.take(3).toList();
  LatLng get initialLocation => HomeInfo.location;

  HomeController() {
    UserInfo.onUpdate.addListener(loadData);
  }

  @override
  void dispose() {
    UserInfo.onUpdate.removeListener(loadData);
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
      
      // Simpan data ke HomeInfo (Pusat Data)
      HomeInfo.currentStatus = data['status'];
      HomeInfo.lastUpdate = data['lastUpdate'];
      
      // Konversi List dynamic ke List<Map<String, String>>
      final List<dynamic> historyData = data['history'];
      // Simpan SEMUA history ke HomeInfo agar bisa dipakai di halaman Notifikasi
      HomeInfo.history = historyData.map((item) => Map<String, String>.from(item)).toList();
      
      HomeInfo.location = data['location'];
      HomeInfo.update(); 
      debugPrint("HomeController: Data berhasil dimuat.");
      
    } catch (e) {
      debugPrint('Error loading home data: $e');
      HomeInfo.currentStatus = 'Error';
    } finally {
      debugPrint("HomeController: Selesai, mematikan loading.");
      isLoading = false;
      notifyListeners(); 
    }
  }
}