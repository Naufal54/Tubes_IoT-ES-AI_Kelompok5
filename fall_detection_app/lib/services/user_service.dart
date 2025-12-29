class UserService {
  Future<Map<String, dynamic>> getUserProfile() async {
    return {
      'username': 'User Name',
      'email': 'User@example.com',
      'phoneNumber': '08123456789',
      'emergencyContact': {
        'name': 'User Emergency',
        'relation': 'Keluarga',
        'phone': '08111222333',
      }
    };
  }
}