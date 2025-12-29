import 'package:latlong2/latlong.dart';

class HomeService {
  Future<Map<String, dynamic>> getDashboardData() async {

    return {
      'status': 'Normal',
      'lastUpdate': '10:45 AM',
      'history': [
        {'time': '11:00 AM', 'status': 'Normal'},
        {'time': '10:45 AM', 'status': 'Jatuh Terdeteksi'},
        {'time': '10:15 AM', 'status': 'Normal'},
        {'time': '09:50 AM', 'status': 'Jatuh Terdeteksi'},
        {'time': '09:30 AM', 'status': 'Normal'},
      ],
      'location': const LatLng(-6.9690, 107.6282), 
    };
  }
}