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
  ],
);
