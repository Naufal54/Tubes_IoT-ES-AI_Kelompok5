import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:eldercare/core/constants/user_info.dart';

class EmergencyController extends ChangeNotifier {
  String name = '';
  String phone = '';
  String relation = '';

  EmergencyController() {
    loadData();
    // PENTING: Controller mendengarkan notifikasi global
    // Jadi saat Edit Profile disimpan, controller ini otomatis refresh data
    UserInfo.onUpdate.addListener(loadData);
  }

  @override
  void dispose() {
    UserInfo.onUpdate.removeListener(loadData);
    super.dispose();
  }

  Future<void> loadData() async {
    name = UserInfo.emergencyName;
    phone = UserInfo.emergencyPhone;
    relation = UserInfo.emergencyRelation;
    notifyListeners(); // Beritahu UI (EmergencyPage) untuk rebuild
  }

  // Logika panggilan telepon dipindah ke sini agar UI lebih bersih
  Future<void> callContact(BuildContext context) async {
    if (phone.isNotEmpty) {
      final cleanNumber = phone.replaceAll(RegExp(r'[^0-9+]'), '');
      final Uri launchUri = Uri(scheme: 'tel', path: cleanNumber);
      if (!await launchUrl(launchUri)) {
        debugPrint("Tidak dapat memanggil $cleanNumber");
      }
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nomor kontak darurat belum diatur'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> callAmbulance() async {
    final Uri launchUri = Uri(scheme: 'tel', path: '112');
    if (!await launchUrl(launchUri)) {
       debugPrint("Tidak dapat memanggil 112");
    }
  }
}