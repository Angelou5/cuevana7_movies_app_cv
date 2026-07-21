import 'package:flutter/material.dart';
import 'package:cuevana7_movies_app_cv/theme/app_theme.dart';
import 'package:cuevana7_movies_app_cv/config/router/app_router.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/auth_provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/movie_provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/user_reviews_provider.dart';
import 'package:cuevana7_movies_app_cv/implements/datasources/movie_db_datasource.dart';
import 'package:cuevana7_movies_app_cv/implements/repository/movies_repository_impl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final authProvider = AuthProvider();
  authProvider.addListener(() {
    if (!authProvider.isAuthenticated) {
      appRouter.go('/login');
    }
  });
  AuthProvider.setOnForceLogout(() => authProvider.logout());

  final datasource = MovieDbDatasource();
  final repository = MovieRepositoryImpl(datasource);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => UserReviewsProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final provider = MovieProvider(repository);
            provider.loadFavorites();
            return provider;
          },
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
      title: "Cuevanita",
    );
  }
}
