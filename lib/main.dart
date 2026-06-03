import 'package:flutter/material.dart';
import 'package:cuevana7_movies_app_cv/theme/app_theme.dart';
import 'package:cuevana7_movies_app_cv/config/router/app_router.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
    );
  }
}
