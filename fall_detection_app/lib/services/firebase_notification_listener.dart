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
  Timer? _periodicCheckTimer;

  factory FirebaseNotificationListener() {
    return _instance;
  }

  FirebaseNotificationListener._internal();

  // Start listening to Firebase changes
  Future<void> startListening() async {
    stopListening();

    debugPrint('FirebaseNotificationListener: Starting to listen for device data changes...');
    
    // Listen to entire device_data
    final ref = FirebaseDatabase.instance.ref('device_data');

    // Initialize previousTimestamp with current server data to avoid false alarm on app startup
    try {
      final snapshot = await ref.get();
      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        
        // Handle new structure: find latest timestamp in history
        if (data['history'] != null && data['history'] is Map) {
          final historyMap = data['history'] as Map<dynamic, dynamic>;
          String latestTimeStr = '';
          
          historyMap.forEach((key, value) {
            if (value is Map) {
              String timeStr = value['timestamp_gmt9']?.toString() ?? '';
              if (timeStr.compareTo(latestTimeStr) > 0) {
                latestTimeStr = timeStr;
              }
            }
          });
          
          if (latestTimeStr.isNotEmpty) {
            _previousTimestamp = DateTime.tryParse(latestTimeStr)?.millisecondsSinceEpoch ?? 0;
            debugPrint('FirebaseNotificationListener: Initialized baseline timestamp to $_previousTimestamp ($latestTimeStr)');
          }
        }
      }
    } catch (e) {
      debugPrint('FirebaseNotificationListener: Error initializing timestamp - $e');
    }
    
    _dataSubscription = ref.onValue.listen((event) {
      debugPrint('FirebaseNotificationListener: Device data changed');
      _processFirebaseSnapshot(event.snapshot);
    }, onError: (error) {
      debugPrint('FirebaseNotificationListener: Error listening - $error');
    });

    // Start periodic check every 10 seconds (for when app might be in background)
    _startPeriodicCheck();
  }

  // Periodic check to ensure notifications work even in background
  void _startPeriodicCheck() {
    _periodicCheckTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      try {
        final ref = FirebaseDatabase.instance.ref('device_data');
        final snapshot = await ref.get();
        
        if (snapshot.exists) {
          debugPrint('FirebaseNotificationListener: Periodic check - data exists');
          _processFirebaseSnapshot(snapshot);
        }
      } catch (e) {
        debugPrint('FirebaseNotificationListener: Periodic check error - $e');
      }
    });
  }

  // Process Firebase data (called from both listener and periodic check)
  void _processFirebaseSnapshot(DataSnapshot snapshot) {
    if (snapshot.exists && snapshot.value != null) {
      try {
        final data = snapshot.value as Map<dynamic, dynamic>;
        
        String newStatus = '';
        int currentTimestamp = 0;
        
        // Handle new structure: iterate history to find latest
        if (data['history'] != null && data['history'] is Map) {
          final historyMap = data['history'] as Map<dynamic, dynamic>;
          String latestTimeStr = '';
          
          historyMap.forEach((key, value) {
            if (value is Map) {
              String timeStr = value['timestamp_gmt9']?.toString() ?? '';
              if (timeStr.compareTo(latestTimeStr) > 0) {
                latestTimeStr = timeStr;
                newStatus = value['status']?.toString().trim() ?? '';
              }
            }
          });
          
          if (latestTimeStr.isNotEmpty) {
            currentTimestamp = DateTime.tryParse(latestTimeStr)?.millisecondsSinceEpoch ?? 0;
          }
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
    _periodicCheckTimer?.cancel();
    debugPrint('FirebaseNotificationListener: Stopped listening and periodic check');
  }

  // Reset state
  void reset() {
    _previousTimestamp = 0;
    stopListening();
  }
}
