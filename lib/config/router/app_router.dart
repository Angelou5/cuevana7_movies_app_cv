import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/screens/movies/home_screen.dart';
import 'package:cuevana7_movies_app_cv/presentation/screens/auth/login_screen.dart';
import 'package:cuevana7_movies_app_cv/presentation/screens/auth/register_screen.dart';
import 'package:cuevana7_movies_app_cv/presentation/screens/auth/splash_screen.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/auth_provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/screens/movies/favorite_screen.dart';
import 'package:cuevana7_movies_app_cv/presentation/screens/movies/configuracion_screen.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/movie.dart';
import 'package:cuevana7_movies_app_cv/presentation/screens/movies/movie_detail_screen.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/actor.dart';
import 'package:cuevana7_movies_app_cv/presentation/screens/movies/actor_detail_screen.dart';

// 👇 Helper para que cada ruta transicione con un fade en vez del
// deslizamiento/blanco por defecto de MaterialPage. Así nunca se
// asoma el fondo blanco base entre pantalla y pantalla.
CustomTransitionPage _fadePage(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 220),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: SplashScreen.name,
      pageBuilder: (context, state) => _fadePage(const SplashScreen(), state),
    ),
    GoRoute(
      path: '/movie/:id',
      name: MovieDetailScreen.name,
      pageBuilder: (context, state) {
        final movie = state.extra as Movie;
        return _fadePage(MovieDetailScreen(movie: movie), state);
      },
    ),
    GoRoute(
      path: '/actor/:id',
      name: ActorDetailScreen.name,
      pageBuilder: (context, state) {
        final actor = state.extra as Actor;
        return _fadePage(ActorDetailScreen(actor: actor), state);
      },
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      pageBuilder: (context, state) => _fadePage(const LoginScreen(), state),
    ),
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      pageBuilder: (context, state) => _fadePage(const HomeScreen(), state),
    ),
    GoRoute(
      path: '/register',
      name: RegisterScreen.name,
      pageBuilder: (context, state) => _fadePage(const RegisterScreen(), state),
    ),
    GoRoute(
      path: '/favorites',
      pageBuilder: (context, state) => _fadePage(const FavoriteScreen(), state),
    ),
    GoRoute(
      path: '/configuracion',
      pageBuilder: (context, state) =>
          _fadePage(const ConfiguracionScreen(), state),
    ),
  ],

  // para proteger las rutas
  redirect: (context, state) {
    //
    final auth = context.read<AuthProvider>();
    final location = state.uri.path;

    // por primera vez
    if (auth.isLoading) return '/splash';

    if (location == '/splash') {
      return auth.isAuthenticated ? '/' : '/login';
    }

    // rutas protegidas

    if (!auth.isAuthenticated && location == '/') {
      return '/login';
    }

    // por si quiere regresar a login o register

    if (auth.isAuthenticated &&
        (location == '/login' || location == '/register')) {
      return '/';
    }

    // por si todo chido
    return null;
  },
);
