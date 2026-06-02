import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cuevana7_movies_app_cv/theme/app_theme.dart';
import 'package:cuevana7_movies_app_cv/config/router/app_router.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/auth/auth_provider.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/user.dart';
import 'package:cuevana7_movies_app_cv/domain/repositories/auth_repository.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            // TODO: reemplazar con AuthRepositoryImpl() cuando esté lista la API
            authRepository: _MockAuthRepository(),
          ),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        theme: AppTheme().getTheme(),
      ),
    );
  }
}

// ── Mock temporal ── borrar cuando exista AuthRepositoryImpl ──────────────────
class _MockAuthRepository implements AuthRepository {
  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return UserEntity(
      id: '1',
      email: email,
      name: 'Usuario Mock',
      token: 'mock-token',
    );
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return UserEntity(id: '2', email: email, name: name, token: 'mock-token');
  }

  @override
  Future<void> logout() async {}
}
