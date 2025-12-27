import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/app_bar.dart';
import '../controller/emergency_controller.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  final EmergencyController _controller = EmergencyController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
      appBar: const AppBarWidget(title: 'Emergency'),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryBlue,
          onRefresh: () async {
            await _controller.loadData();
          },
          child: ListView(
            padding: const EdgeInsets.all(16.0),
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
                  title: Text(_controller.name.isNotEmpty
                      ? '${_controller.name}${_controller.relation.isNotEmpty ? ' (${_controller.relation})' : ''}'
                      : 'Kontak Belum Ditetapkan'),
                  subtitle: Text(_controller.phone.isNotEmpty
                      ? _controller.phone
                      : 'Nomor belum ditetapkan'),
                  trailing: IconButton(
                    icon: const Icon(Icons.call, color: Colors.green),
                    onPressed: () => _controller.callContact(context),
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
                    onPressed: () => _controller.callAmbulance(),
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
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 8),
              // List panduan langsung dimasukkan ke ListView utama
              // agar halaman menjadi satu kesatuan scroll
              const Column(
                children: [
                      ListTile(
                        leading: Icon(Icons.check, color: AppColors.primaryBlue),
                        title: Text('Pastikan kondisi sekitar kita dan korban aman'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check, color: AppColors.primaryBlue),
                        title: Text('Periksa kesadaran korban'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check, color: AppColors.primaryBlue),
                        title: Text('Hubungi bantuan medis segera'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check, color: AppColors.primaryBlue),
                        title: Text('Jika korban tidak sadar, periksa pernapasan dan denyut nadi selama 10 detik'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check, color: AppColors.primaryBlue),
                        title: Text('Jika nadi atau pernapasan tidak ada, segera lakukan CPR'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check, color: AppColors.primaryBlue),
                        title: Text('Jangan pindahkan korban jika ada cedera serius'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check, color: AppColors.primaryBlue),
                        title: Text('Jika aman, posisikan korban senyaman mungkin'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check, color: AppColors.primaryBlue),
                        title: Text('Jika bantuan medis tiba, segera lakukan rujukan ke rumah sakit terdekat'),
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
      },
    );
  }
}
