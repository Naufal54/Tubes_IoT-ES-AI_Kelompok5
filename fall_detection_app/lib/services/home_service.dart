import 'package:firebase_database/firebase_database.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class HomeService {
  Stream<Map<String, dynamic>> getDashboardDataStream() {
    final ref = FirebaseDatabase.instance.ref('device_data');
    debugPrint("HomeService: Menghubungkan ke Firebase path '${ref.path}'...");
    
    return ref.onValue.map((event) {
      debugPrint("HomeService: Event diterima dari Firebase! Exists: ${event.snapshot.exists}");
      final snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value != null) {
        try {
          // Gunakan dynamic untuk menangani kemungkinan tipe data List atau Map
          final dynamic value = snapshot.value;
          Map<dynamic, dynamic> dataMap;

          if (value is Map) {
            dataMap = value;
          } else if (value is List) {
            // Jika Firebase mengembalikan List (karena key integer), kita anggap format salah
            throw Exception('Format data salah (List), seharusnya Map JSON Object.');
          } else {
            throw Exception('Format data tidak dikenali.');
          }

          // Parsing Location dengan aman (handle null & tipe data)
          LatLng location = const LatLng(-6.9690, 107.6282);
          if (dataMap['location'] != null && dataMap['location'] is Map) {
            final locMap = dataMap['location'] as Map;
            location = LatLng(
              (locMap['latitude'] as num? ?? -6.9690).toDouble(),
              (locMap['longitude'] as num? ?? 107.6282).toDouble(),
            );
          }

          // Parsing History (Handle Map atau List)
          List<Map<String, dynamic>> historyList = [];
          if (dataMap['history'] != null) {
            final dynamic historyRaw = dataMap['history'];
            
            if (historyRaw is Map) {
              historyRaw.forEach((key, value) {
                if (value is Map) {
                  historyList.add(Map<String, dynamic>.from(value));
                }
              });
            } else if (historyRaw is List) {
              for (var item in historyRaw) {
                if (item is Map) {
                  historyList.add(Map<String, dynamic>.from(item));
                }
              }
            }
            
            // Sort descending
            historyList.sort((a, b) {
              int timeA = (a['timestamp'] is int) ? a['timestamp'] : 0;
              int timeB = (b['timestamp'] is int) ? b['timestamp'] : 0;
              return timeB.compareTo(timeA);
            });
          }

          return {
            'status': dataMap['status']?.toString() ?? 'Unknown',
            'lastUpdate': dataMap['lastUpdate'] ?? 0,
            'history': historyList,
            'location': location,
          };
        } catch (e) {
          debugPrint("HomeService Error Parsing: $e");
          throw Exception('Parsing Error: $e');
        }
      }

      // Jika data tidak ada, stream akan mengirim error
      debugPrint("HomeService: Data kosong atau tidak ditemukan.");
      throw Exception('Data not found in Firebase at path /device_data');
    });
  }
}