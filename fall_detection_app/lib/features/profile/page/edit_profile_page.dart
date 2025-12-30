import 'package:flutter/material.dart';
import 'package:eldercare/core/constants/colors.dart';
import 'package:eldercare/core/constants/user_info.dart';
import 'package:eldercare/services/user_service.dart';

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

  final UserService _userService = UserService();
  bool _isSaving = false;

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

  Future<void> _save() async {
    if (_isSaving) return; // Hindari multiple taps
    
    setState(() {
      _isSaving = true;
    });

    try {
      // Simpan profile ke Firebase
      await _userService.updateUserProfile(
        _usernameController.text,
        _emailController.text,
        _phoneController.text,
      );

      // Simpan kontak darurat ke Firebase
      await _userService.updateEmergencyContact(
        _emergencyNameController.text,
        _emergencyRelationController.text,
        _emergencyPhoneController.text,
      );

      // Update UserInfo lokal setelah berhasil simpan
      UserInfo.username = _usernameController.text;
      UserInfo.email = _emailController.text;
      UserInfo.phoneNumber = _phoneController.text;
      
      UserInfo.emergencyName = _emergencyNameController.text;
      UserInfo.emergencyRelation = _emergencyRelationController.text;
      UserInfo.emergencyPhone = _emergencyPhoneController.text;
      
      UserInfo.update();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile berhasil diperbarui!'),
            duration: Duration(seconds: 2),
          ),
        );

        // Kembali ke halaman sebelumnya
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('Error saving profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
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
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
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