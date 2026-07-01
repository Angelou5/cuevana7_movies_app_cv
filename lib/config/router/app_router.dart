import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/screens/movies/home_screen.dart';
import 'package:cuevana7_movies_app_cv/presentation/screens/auth/login_screen.dart';
import 'package:cuevana7_movies_app_cv/presentation/screens/auth/register_screen.dart';
import 'package:cuevana7_movies_app_cv/presentation/screens/auth/splash_screen.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/auth_provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/screens/movies/favorite_screen.dart';
import 'package:cuevana7_movies_app_cv/presentation/screens/movies/liked_screen.dart';

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
      builder: (context, state) => const LoginScreen(),
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
    GoRoute(path: '/favorites', builder: (_, __) => const FavoriteScreen()),
    GoRoute(path: '/movies', builder: (_, __) => const LikedScreen()),
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
