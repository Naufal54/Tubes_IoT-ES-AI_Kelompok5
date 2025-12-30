import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class UserService {
  Future<Map<String, dynamic>> getUserProfile() async {
    final ref = FirebaseDatabase.instance.ref('user_profile');
    debugPrint("UserService: Mengambil profil dari '${ref.path}'...");
    
    try {
      final snapshot = await ref.get();
      debugPrint("UserService: Snapshot diterima. Exists: ${snapshot.exists}");

      if (snapshot.exists && snapshot.value != null) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
    } catch (e) {
      debugPrint("UserService Error: $e");
      // Lanjut ke return default di bawah jika error
    }

    return {
      'username': 'User Name',
      'email': 'User@example.com',
      'phoneNumber': '08123456789',
      'emergencyContact': {
        'name': 'User Emergency',
        'relation': 'Keluarga',
        'phone': '08111222333',
      }
    };
  }

  Future<void> updateUserProfile(String username, String email, String phoneNumber) async {
    final ref = FirebaseDatabase.instance.ref('user_profile');
    await ref.update({
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
    });
  }

  Future<void> updateEmergencyContact(String name, String relation, String phone) async {
    final ref = FirebaseDatabase.instance.ref('user_profile/emergencyContact');
    await ref.update({
      'nama': name,
      'hubungan': relation,
      'telepon': phone,
    });
  }
}