import 'package:flutter/material.dart';
import '../../../core/constants/user_info.dart';
import '../../../services/user_service.dart';

class ProfileController extends ChangeNotifier {
  final UserService _service = UserService();
  String username = '';
  String email = '';
  String phoneNumber = '';

  ProfileController() {
    fetchUserProfile();
    loadData();
    UserInfo.onUpdate.addListener(loadData);
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
      UserInfo.phoneNumber = data['phoneNumber'] ?? '';
      
      if (data['emergencyContact'] != null) {
        final emergency = data['emergencyContact'] as Map;
        UserInfo.emergencyName = emergency['name'] ?? emergency['nama'] ?? '';
        UserInfo.emergencyRelation = emergency['relation'] ?? emergency['hubungan'] ?? '';
        UserInfo.emergencyPhone = emergency['phone'] ?? emergency['telepon'] ?? '';
      }
      
      // Memberitahu seluruh aplikasi bahwa data UserInfo berubah
      // Karena controller ini mendengarkan UserInfo.onUpdate, 
      // fungsi loadData() di bawah akan otomatis terpanggil setelah ini.
      UserInfo.update(); 
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
  }

  Future<void> updateProfile(String username, String email, String phoneNumber) async {
    await _service.updateUserProfile(username, email, phoneNumber);
    await fetchUserProfile(); // Refresh data lokal setelah update
  }

  Future<void> updateEmergency(String name, String relation, String phone) async {
    await _service.updateEmergencyContact(name, relation, phone);
    await fetchUserProfile(); // Refresh data lokal setelah update
  }

  void loadData() {
    username = UserInfo.username;
    email = UserInfo.email;
    phoneNumber = UserInfo.phoneNumber;
    notifyListeners();
  }
}