import 'package:flutter/material.dart';
import '../../../core/constants/user_info.dart';
import '../../../services/user_service.dart';

class ProfileController extends ChangeNotifier {
  final UserService _service = UserService();
  String username = '';
  String email = '';
  String phoneNumber = '';

  ProfileController() {
    loadData();
    UserInfo.onUpdate.addListener(loadData);
    // Opsional: Panggil fetchUserProfile() di sini jika ingin otomatis ambil data saat controller dibuat
  }

  @override
  void dispose() {
    UserInfo.onUpdate.removeListener(loadData);
    super.dispose();
  }

  // Fungsi untuk mengambil data dari Server/Firebase dan update ke UserInfo
  Future<void> fetchUserProfile() async {
    try {
      final data = await _service.getUserProfile();
      
      // Update Pusat Data (UserInfo)
      UserInfo.username = data['username'];
      UserInfo.email = data['email'];
      UserInfo.phoneNumber = data['phoneNumber'];
      
      final emergency = data['emergencyContact'];
      UserInfo.emergencyName = emergency['name'];
      UserInfo.emergencyRelation = emergency['relation'];
      UserInfo.emergencyPhone = emergency['phone'];
      
      // Memberitahu seluruh aplikasi bahwa data UserInfo berubah
      // Karena controller ini mendengarkan UserInfo.onUpdate, 
      // fungsi loadData() di bawah akan otomatis terpanggil setelah ini.
      UserInfo.update(); 
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
  }

  void loadData() {
    username = UserInfo.username;
    email = UserInfo.email;
    phoneNumber = UserInfo.phoneNumber;
    notifyListeners();
  }
}