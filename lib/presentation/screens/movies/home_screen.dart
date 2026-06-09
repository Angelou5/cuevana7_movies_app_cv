// impm (flutter widgets snippets)
import 'package:flutter/material.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:go_router/go_router.dart';

//stls
class HomeScreen extends StatelessWidget {

  // constante global dentro de la clase para las rutas de navegacion
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  body: Stack(
    children: [
      const Center(child: Placeholder()),
      Positioned(
        top: 60,
        left: 20,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => context.go('/login'),
          ),
        ),
      ),
    ],
  ),
);
  }
}