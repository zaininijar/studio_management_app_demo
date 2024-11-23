import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studio_management/models/user.dart';
import 'package:studio_management/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _token != null && _user != null;

  /// Fungsi login
  Future<void> login(String email, String password) async {
    try {
      final response = await ApiService.post(
        '/login',
        {
          'email': email,
          'password': password,
          'device_name': 'android',
        },
        useApi: false,
      );

      // Simpan token dan data pengguna
      _token = response['token'];
      _user = User.fromJson(response['user']);

      // Simpan token ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);

      // Notify listeners untuk update state
      notifyListeners();
    } catch (e) {
      throw Exception("Login failed: ${e.toString()}");
    }
  }

  /// Fungsi logout
  Future<void> logout() async {
    try {
      // Ambil token dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception("Token is missing or invalid");
      }

      // Kirim request logout dengan token di header
      final response = await ApiService.post(
        '/logout',
        {}, // Bisa sesuaikan jika ada data lain yang dibutuhkan
        useApi: false,
      );

      // Reset user dan token setelah berhasil logout
      _user = null;
      _token = null;
      await prefs.remove('auth_token');

      // Notifikasi listener agar UI dapat diperbarui
      notifyListeners();
    } catch (e) {
      throw Exception("Logout failed: ${e.toString()}");
    }
  }

  /// Cek status autentikasi saat aplikasi dibuka
  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');

    if (_token != null) {
      try {
        // Dapatkan data pengguna dari API
        final response = await ApiService.get('/user');
        _user = User.fromJson(response);

        notifyListeners();
      } catch (e) {
        // Jika token invalid, hapus token dari local storage
        _token = null;
        await prefs.remove('auth_token');

        notifyListeners();
      }
    }
  }

  /// Fungsi untuk refresh token (opsional)
  Future<void> refreshToken() async {
    try {
      final response =
          await ApiService.post('/refresh-token', {}, useApi: false);

      _token = response['token'];

      // Simpan token baru di SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);

      notifyListeners();
    } catch (e) {
      throw Exception("Token refresh failed: ${e.toString()}");
    }
  }
}
