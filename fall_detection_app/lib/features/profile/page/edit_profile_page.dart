import 'package:flutter/material.dart';
import 'package:eldercare/core/constants/colors.dart';
import 'package:eldercare/core/constants/user_info.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  
  // Controller untuk Kontak Darurat
  late TextEditingController _emergencyNameController;
  late TextEditingController _emergencyRelationController;
  late TextEditingController _emergencyPhoneController;

  @override
  void initState() {
    super.initState();
    // Isi form dengan data saat ini
    _usernameController = TextEditingController(text: UserInfo.username);
    _emailController = TextEditingController(text: UserInfo.email);
    _phoneController = TextEditingController(text: UserInfo.phoneNumber);
    
    _emergencyNameController = TextEditingController(text: UserInfo.emergencyName);
    _emergencyRelationController = TextEditingController(text: UserInfo.emergencyRelation);
    _emergencyPhoneController = TextEditingController(text: UserInfo.emergencyPhone);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyNameController.dispose();
    _emergencyRelationController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  void _save() {
    // Simpan perubahan ke UserInfo
    UserInfo.username = _usernameController.text;
    UserInfo.email = _emailController.text;
    UserInfo.phoneNumber = _phoneController.text;
    
    UserInfo.emergencyName = _emergencyNameController.text;
    UserInfo.emergencyRelation = _emergencyRelationController.text;
    UserInfo.emergencyPhone = _emergencyPhoneController.text;
    
    // Kembali ke halaman sebelumnya dengan sinyal 'true' (berhasil update)
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: AppColors.primaryBlue,
          ),
        ),
        child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Bagian Edit Profile =====
              const Text(
                'Edit Profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor HP',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),

              const SizedBox(height: 32),
              const Divider(thickness: 1),
              const SizedBox(height: 16),

              // ===== Bagian Kontak Darurat =====
              const Text(
                'Kontak Darurat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emergencyNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kontak',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.contact_emergency),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emergencyRelationController,
                decoration: const InputDecoration(
                  labelText: 'Hubungan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.people),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emergencyPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'No HP Darurat',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone_in_talk),
                ),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}