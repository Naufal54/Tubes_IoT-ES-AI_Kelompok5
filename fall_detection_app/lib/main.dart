import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:eldercare/app/app.dart';
import 'package:eldercare/features/profile/controller/profile_controller.dart';
import 'package:eldercare/services/notification_service.dart';
import 'package:eldercare/services/firebase_notification_listener.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();
  debugPrint("Main: NotificationService initialized");
  
  // Initialize Firebase notification listener
  final firebaseNotificationListener = FirebaseNotificationListener();
  firebaseNotificationListener.startListening();
  debugPrint("Main: FirebaseNotificationListener started");
  
  // Initialize ProfileController saat startup untuk load user data dari Firebase
  ProfileController(); // Fire and forget (akan tetap hidup karena listener di UserInfo)
  debugPrint("Main: ProfileController initialized");
  
  runApp(const MyApp());
}
  