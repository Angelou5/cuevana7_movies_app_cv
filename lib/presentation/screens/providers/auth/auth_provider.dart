import 'package:flutter/material.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/user.dart';
import 'package:cuevana7_movies_app_cv/domain/repositories/auth_repository.dart';

enum AuthStatus { checking, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthStatus status = AuthStatus.unauthenticated;
  UserEntity? user;
  String? errorMessage;

  AuthProvider({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<void> login({required String email, required String password}) async {
    try {
      status = AuthStatus.checking;
      errorMessage = null;
      notifyListeners();

      // TODO: descomentar cuando la API esté lista
      // user = await _authRepository.login(email: email, password: password);

      // --- Mock temporal para desarrollo ---
      await Future.delayed(const Duration(seconds: 1));
      user = UserEntity(
        id: '1',
        email: email,
        name: 'Usuario',
        token: 'mock-token',
      );
      // ------------------------------------

      status = AuthStatus.authenticated;
    } catch (e) {
      status = AuthStatus.unauthenticated;
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> logout() async {
    // TODO: llamar a _authRepository.logout() cuando la API esté lista
    user = null;
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
