import 'package:flutter/material.dart';

class UserInfo {
  static final ValueNotifier<int> onUpdate = ValueNotifier(0);

  static void update() {
    onUpdate.value++;
  }

  static String username = 'User Name';
  static String email = 'user@example.com';
  static String phoneNumber = '';
  static String emergencyName = 'User Emergency';
  static String emergencyRelation = 'Keluarga';
  static String emergencyPhone = '123-456-7890';
  static bool isNotificationOn = true;
}
