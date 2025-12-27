import 'package:flutter/material.dart';
import '../../../core/constants/user_info.dart';
import 'package:eldercare/features/emergency/controller/user_notifier.dart';

class ProfileController extends ChangeNotifier {
  String username = '';
  String email = '';
  String phoneNumber = '';

  ProfileController() {
    loadData();
    userUpdateNotifier.addListener(loadData);
  }

  @override
  void dispose() {
    userUpdateNotifier.removeListener(loadData);
    super.dispose();
  }

  void loadData() {
    username = UserInfo.username;
    email = UserInfo.email;
    phoneNumber = UserInfo.phoneNumber;
    notifyListeners();
  }
}