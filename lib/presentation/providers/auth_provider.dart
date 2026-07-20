import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _token;
  bool _isLoading = true;

  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;

  static VoidCallback? _onForceLogout;
  static VoidCallback? get onForceLogout => _onForceLogout;

  AuthProvider() {
    _loadToken();
  }

  static void setOnForceLogout(VoidCallback callback) {
    _onForceLogout = callback;
  }

  Future<void> _loadToken() async {
    try {
      _token = await _storage.read(key: 'jwt_token');
      if (_token != null && _isTokenExpired(_token!)) {
        _token = null;
        await _storage.delete(key: 'jwt_token');
      }
    } catch (e) {
      _token = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setToken(String token) async {
    _token = token;
    await _storage.write(key: 'jwt_token', value: token);
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    await _storage.delete(key: 'jwt_token');
    notifyListeners();
  }

  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      final payload = utf8.decode(base64Url.decode(parts[1]));
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final exp = data['exp'] as int?;
      if (exp == null) return true;
      final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
      return DateTime.now().isAfter(expiry);
    } catch (_) {
      return true;
    }
  }
}