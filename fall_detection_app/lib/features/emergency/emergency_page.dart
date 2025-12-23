import 'package:flutter/material.dart';
import 'package:fall_detection_app/core/constants/user_info.dart';
import 'package:fall_detection_app/core/widgets/app_bar.dart';
import 'package:fall_detection_app/core/widgets/nav_bar.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Emergency'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Informasi Kontak Darurat
              Text(
                'Kontak Darurat',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
              const SizedBox(height: 12),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.family_restroom, color: Colors.red),
                  title: Text(UserInfo.emergencyName.isNotEmpty
                      ? '${UserInfo.emergencyName}${UserInfo.emergencyRelation.isNotEmpty ? ' (${UserInfo.emergencyRelation})' : ''}'
                      : 'Kontak Belum Ditetapkan'),
                  subtitle: Text(UserInfo.emergencyPhone.isNotEmpty
                      ? UserInfo.emergencyPhone
                      : 'Silakan atur di menu Profile'),
                  trailing: IconButton(
                    icon: const Icon(Icons.call, color: Colors.green),
                    onPressed: () {
                      // Tambahkan aksi untuk melakukan panggilan telepon
                    },
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.local_hospital, color: Colors.red),
                  title: const Text('Nomor Darurat'),
                  subtitle: const Text('112 / 119'),
                  trailing: IconButton(
                    icon: const Icon(Icons.call, color: Colors.green),
                    onPressed: () {
                      // Tambahkan aksi untuk melakukan panggilan telepon
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Divider(thickness: 1, height: 32, color: Colors.grey),

              // Panduan Pertolongan Pertama
              Text(
                'Panduan Pertolongan Pertama',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView(
                    children: const [
                      ListTile(
                        leading: Icon(Icons.check, color: Colors.blue),
                        title: Text('Pastikan kondisi sekitar kita dan korban aman'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check, color: Colors.blue),
                        title: Text('Periksa kesadaran korban'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check, color: Colors.blue),
                        title: Text('Hubungi bantuan medis segera'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check, color: Colors.blue),
                        title: Text('Jika korban tidak sadar, periksa pernapasan dan denyut nadi selama 10 detik'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check, color: Colors.blue),
                        title: Text('Jika nadi atau pernapasan tidak ada, segera lakukan CPR'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check, color: Colors.blue),
                        title: Text('Jangan pindahkan korban jika ada cedera serius'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check, color: Colors.blue),
                        title: Text('Jika aman, posisikan korban senyaman mungkin'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check, color: Colors.blue),
                        title: Text('Jika bantuan medis tiba, segera lakukan rujukan ke rumah sakit terdekat'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }
}
