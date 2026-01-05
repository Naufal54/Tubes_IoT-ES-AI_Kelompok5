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
      if (data['lastUpdate'] != null) {
        if (data['lastUpdate'] is int) {
          HomeInfo.lastUpdate = _formatDateTime(DateTime.fromMillisecondsSinceEpoch(data['lastUpdate'] * 1000));
        } else {
          HomeInfo.lastUpdate = _tryFormatString(data['lastUpdate'].toString());
        }
      } else {
        HomeInfo.lastUpdate = '-';
      }
      
      // Konversi List dynamic ke List<Map<String, String>>
      final List<dynamic> historyData = data['history'] ?? [];
      // Simpan SEMUA history ke HomeInfo agar bisa dipakai di halaman Notifikasi
      HomeInfo.history = historyData.map((item) {
        String timeStr = '-';
        // Cek jika data menggunakan key 'timestamp' (Epoch)
        if (item['timestamp'] != null && item['timestamp'] is int) {
          timeStr = _formatDateTime(DateTime.fromMillisecondsSinceEpoch(item['timestamp'] * 1000));
        } else if (item['timestamp_gmt9'] != null) {
          timeStr = _tryFormatString(item['timestamp_gmt9'].toString());
        } else if (item['time'] != null) {
          timeStr = _tryFormatString(item['time'].toString());
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

  // Helper untuk mencoba parse string tanggal (misal: "2026-01-04 19:27:00")
  String _tryFormatString(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return _formatDateTime(date);
    } catch (_) {
      return dateStr; // Jika gagal parse, kembalikan string aslinya
    }
  }

  // Logika utama formatting: Today, Yesterday, atau Tanggal
  String _formatDateTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    final time = '$hour:$minute';

    if (dateToCheck == today) {
      return 'Today, $time';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday, $time';
    } else {
      // Format: dd MMM, HH:mm (Contoh: 04 Jan, 19:27)
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${date.day} ${months[date.month - 1]}, $time';
    }
  }
}