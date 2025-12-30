import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:eldercare/app/app.dart';
import 'package:eldercare/features/profile/controller/profile_controller.dart';
import 'firebase_options.dart';

// ignore: unused_element
late ProfileController _profileController;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  _profileController = ProfileController();
  debugPrint("Main: ProfileController initialized");
  runApp(const MyApp());
}
  