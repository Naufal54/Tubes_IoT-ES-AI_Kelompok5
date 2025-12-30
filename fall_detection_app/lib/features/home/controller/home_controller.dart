import 'package:eldercare/core/constants/home_info.dart';
import 'package:eldercare/core/constants/user_info.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:eldercare/services/home_service.dart';
import 'package:latlong2/latlong.dart';

class HomeController extends ChangeNotifier {
  final HomeService _service = HomeService();

  // State Variables
  bool isLoading = true; // Untuk loading saat pertama kali buka
  StreamSubscription? _dashboardSubscription;
  
  // Menggunakan getter agar UI tetap bisa mengakses data lewat controller
  String get currentStatus => HomeInfo.currentStatus;
  String get lastUpdate => HomeInfo.lastUpdate;
  // Home page hanya menampilkan 3 riwayat terakhir, tapi data aslinya lengkap di HomeInfo
  List<Map<String, String>> get history => HomeInfo.history.take(3).toList();
  LatLng get initialLocation => HomeInfo.location;

  HomeController() {
    _listenToDashboardData();
    // Dengarkan perubahan UserInfo agar UI (Header Nama) bisa rebuild
    UserInfo.onUpdate.addListener(notifyListeners);
    // Dengarkan perubahan HomeInfo agar UI terupdate
    HomeInfo.onUpdate.addListener(notifyListeners);
  }

  @override
  void dispose() {
    UserInfo.onUpdate.removeListener(notifyListeners);
    HomeInfo.onUpdate.removeListener(notifyListeners);
    _dashboardSubscription?.cancel();
    super.dispose();
  }

  void _listenToDashboardData() {
    debugPrint("HomeController: Starting to listen for dashboard data...");
    if (_dashboardSubscription != null) return; // Hindari duplikasi listener

    _dashboardSubscription = _service.getDashboardDataStream().listen((data) {
      _processData(data);
    }, onError: (error) {
      debugPrint('Error in dashboard stream: $error');
      HomeInfo.currentStatus = 'Error';
      HomeInfo.lastUpdate = 'Error';
      HomeInfo.update();
      if (isLoading) {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  // Method untuk memproses data yang masuk dari stream
  void _processData(Map<String, dynamic> data) {
    try {
      // Simpan data ke HomeInfo (Pusat Data)
      HomeInfo.currentStatus = data['status'];
      
      // Handle lastUpdate (bisa berupa int epoch atau string)
      // Hanya simpan timestamp tanpa prefix, prefix akan ditambah di UI
      if (data['lastUpdate'] != null && data['lastUpdate'] is int) {
        HomeInfo.lastUpdate = _formatTimestamp(data['lastUpdate']);
      } else {
        HomeInfo.lastUpdate = data['lastUpdate']?.toString() ?? '-';
      }
      
      // Konversi List dynamic ke List<Map<String, String>>
      final List<dynamic> historyData = data['history'] ?? [];
      // Simpan SEMUA history ke HomeInfo agar bisa dipakai di halaman Notifikasi
      HomeInfo.history = historyData.map((item) {
        String timeStr = '-';
        // Cek jika data menggunakan key 'timestamp' (Epoch)
        if (item['timestamp'] != null && item['timestamp'] is int) {
          timeStr = _formatTimestamp(item['timestamp']);
        } else if (item['time'] != null) {
          timeStr = item['time'].toString();
        }
        return {
          'status': item['status']?.toString() ?? '-',
          'time': timeStr,
        };
      }).toList();
      
      HomeInfo.location = data['location'];
      HomeInfo.update(); 
      debugPrint("HomeController: Data berhasil dimuat. Status: ${HomeInfo.currentStatus}");
      
    } catch (e) {
      debugPrint('Error processing home data: $e');
      HomeInfo.currentStatus = 'Error';
      HomeInfo.lastUpdate = 'Error';
      HomeInfo.update();
    } finally {
      if (isLoading) isLoading = false; // Matikan loading hanya pada pemuatan pertama
      notifyListeners(); 
    }
  }

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$hour12:$minute $period';
  }
}