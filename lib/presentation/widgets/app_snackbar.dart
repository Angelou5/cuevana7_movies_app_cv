import 'package:flutter/material.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';

/// Muestra un snackbar de éxito con estilo consistente en toda la app.
/// Se usa, por ejemplo, al agregar una película a favoritos.
void showSuccessSnackBar(BuildContext context, String message) {
  // hideCurrentSnackBar evita que se apilen mensajes si el usuario
  // togglea favorito varias veces seguido muy rápido.
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppColors.white,
                  fontFamily: 'InclusiveSans',
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
}
