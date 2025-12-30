import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'notification_service.dart';

class FirebaseNotificationListener {
  static final FirebaseNotificationListener _instance = 
      FirebaseNotificationListener._internal();
  
  // Variable to track previous timestamp
  static int _previousTimestamp = 0;
  StreamSubscription<DatabaseEvent>? _dataSubscription;

  factory FirebaseNotificationListener() {
    return _instance;
  }

  FirebaseNotificationListener._internal();

  // Start listening to Firebase changes
  void startListening() {
    debugPrint('FirebaseNotificationListener: Starting to listen for device data changes...');
    
    // Listen to entire device_data
    final ref = FirebaseDatabase.instance.ref('device_data');
    
    _dataSubscription = ref.onValue.listen((event) {
      debugPrint('FirebaseNotificationListener: Device data changed');
      
      if (event.snapshot.exists && event.snapshot.value != null) {
        try {
          final data = event.snapshot.value as Map<dynamic, dynamic>;
          
          final newStatus = data['status']?.toString().trim() ?? '';
          final newTimestampValue = data['lastUpdate'];
          
          // Convert timestamp to int (epoch milliseconds)
          int currentTimestamp = 0;
          if (newTimestampValue is int) {
            currentTimestamp = newTimestampValue;
          } else if (newTimestampValue is String) {
            currentTimestamp = int.tryParse(newTimestampValue) ?? 0;
          } else if (newTimestampValue is double) {
            currentTimestamp = newTimestampValue.toInt();
          }
          
          debugPrint('FirebaseNotificationListener: Status="$newStatus", CurrentTimestamp=$currentTimestamp, PreviousTimestamp=$_previousTimestamp');
          
          // Compare current timestamp with previous timestamp
          if (currentTimestamp > 0 && currentTimestamp != _previousTimestamp) {
            debugPrint('FirebaseNotificationListener: ✅ Timestamp changed ($currentTimestamp != $_previousTimestamp) → Sending notification');
            
            _previousTimestamp = currentTimestamp;
            debugPrint('FirebaseNotificationListener: Updated previous timestamp to $currentTimestamp');
            
            // Send notification with async handling
            _sendNotification(newStatus);
          } else if (currentTimestamp == 0) {
            debugPrint('FirebaseNotificationListener: ⏭️ Invalid timestamp (0)');
          } else {
            debugPrint('FirebaseNotificationListener: ⏭️ Timestamp not changed ($currentTimestamp == $_previousTimestamp)');
          }
        } catch (e) {
          debugPrint('FirebaseNotificationListener: Error - $e');
        }
      }
    }, onError: (error) {
      debugPrint('FirebaseNotificationListener: Error listening - $error');
    });
  }

  // Send notification asynchronously
  void _sendNotification(String status) {
    NotificationService().showNotification(
      title: '🚨 ALERT: Fall Detected!',
      body: 'Terdeteksi Jatuh - Segera cek kondisi pengguna!',
      payload: status,
    ).then((_) {
      debugPrint('FirebaseNotificationListener: Notification sent successfully');
    }).catchError((error) {
      debugPrint('FirebaseNotificationListener: Error sending notification - $error');
    });
  }

  // Stop listening
  void stopListening() {
    _dataSubscription?.cancel();
    debugPrint('FirebaseNotificationListener: Stopped listening');
  }

  // Reset state
  void reset() {
    _previousTimestamp = 0;
    stopListening();
  }
}
