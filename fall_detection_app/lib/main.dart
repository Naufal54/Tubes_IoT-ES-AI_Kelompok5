import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:eldercare/app/app.dart';
import 'package:eldercare/features/profile/controller/profile_controller.dart';
import 'package:eldercare/services/notification_service.dart';
import 'package:eldercare/services/firebase_notification_listener.dart';
import 'firebase_options.dart';

// ignore: unused_element
late ProfileController _profileController;
late NotificationService _notificationService;
late FirebaseNotificationListener _firebaseNotificationListener;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize notification service
  _notificationService = NotificationService();
  await _notificationService.initialize();
  debugPrint("Main: NotificationService initialized");
  
  // Initialize Firebase notification listener
  _firebaseNotificationListener = FirebaseNotificationListener();
  _firebaseNotificationListener.startListening();
  debugPrint("Main: FirebaseNotificationListener started");
  _profileController = ProfileController();
  debugPrint("Main: ProfileController initialized");
  
  runApp(const MyApp());
}
  