import 'package:flutter/material.dart';
import 'package:eldercare/core/constants/home_info.dart';

class NotificationController extends ChangeNotifier {
  List<Map<String, String>> notifications = [];

  NotificationController() {
    loadData();
    HomeInfo.onUpdate.addListener(loadData);
  }

  @override
  void dispose() {
    HomeInfo.onUpdate.removeListener(loadData);
    super.dispose();
  }

  void loadData() {
    notifications = HomeInfo.history;
    notifyListeners();
  }
}