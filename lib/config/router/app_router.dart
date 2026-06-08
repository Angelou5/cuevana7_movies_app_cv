import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cuevana7_movies_app_cv/presentation/screens/movies/home_screen.dart';
import 'package:cuevana7_movies_app_cv/presentation/screens/auth/login_screen.dart';
import 'package:cuevana7_movies_app_cv/presentation/screens/auth/register_screen.dart';
import 'package:cuevana7_movies_app_cv/presentation/screens/auth/splash_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: SplashScreen.name,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginScreen(),
        transitionDuration: const Duration(milliseconds: 1200),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic, // misma curva que el splash
            ),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/register',
      name: RegisterScreen.name,
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);
