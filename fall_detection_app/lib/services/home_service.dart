import 'package:latlong2/latlong.dart';

class HomeService {
  // Simulasi fetch data (bisa diganti dengan HTTP request nanti)
  Future<Map<String, dynamic>> getDashboardData() async {
    // Simulasi delay network 1.5 detik
    await Future.delayed(const Duration(milliseconds: 1500));

    return {
      'status': 'Normal',
      'lastUpdate': '10:45 AM',
      'history': [
        {'time': '10:45 AM', 'status': 'Normal'},
        {'time': '10:15 AM', 'status': 'Normal'},
        {'time': '09:50 AM', 'status': 'Jatuh Terdeteksi'},
      ],
      'location': const LatLng(-6.9690, 107.6282), // Contoh lokasi (Telkom Univ)
    };
  }
}