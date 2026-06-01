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

      //descomentar cuando la API esté lista

      // temporal
      await Future.delayed(const Duration(seconds: 1));
      user = UserEntity(
        id: '1',
        email: email,
        name: 'Usuario',
        token: 'mock-token',
      );

      status = AuthStatus.authenticated;
    } catch (e) {
      status = AuthStatus.unauthenticated;
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> logout() async {
    // llamar a _authRepository.logout() cuando la API esté lista
    user = null;
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      status = AuthStatus.checking;
      errorMessage = null;
      notifyListeners();

      // descomentar cuando la API esté lista

      await Future.delayed(const Duration(seconds: 1));
      user = UserEntity(id: '2', email: email, name: name, token: 'mock-token');

      status = AuthStatus.authenticated;
    } catch (e) {
      status = AuthStatus.unauthenticated;
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
