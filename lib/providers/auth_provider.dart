import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studio_management/models/user.dart';
import 'package:studio_management/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _token != null;

  Future<void> login(String email, String password) async {
    try {
      final response = await ApiService.post('/login',
          {'email': email, 'password': password, 'device_name': 'android'},
          useApi: false);

      _token = response['token'];
      _user = User.fromJson(response['user']);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await ApiService.post('/logout', {}, useApi: false);
      _user = null;
      _token = null;

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');

    if (_token != null) {
      try {
        final response = await ApiService.get('/user');
        _user = User.fromJson(response);
        notifyListeners();
      } catch (e) {
        _token = null;
        await prefs.remove('auth_token');
        notifyListeners();
      }
    }
  }
}
