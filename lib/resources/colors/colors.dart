import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Fondos
  static const Color background = Color(
    0xFF091A28,
  ); // antes blanco, ahora fondo superior
  static const Color dark = Color(
    0xFF07163B,
  ); // antes negro, ahora fondo inferior
  static const Color inputFill = Color(0xFF164364); // fondo de los campos
  static const Color primary = Color(0xFF7DC4DC); // botón degradado abajo
  static const Color buttonText = Color(
    0xFF7DC4DC,
  ); // botón degradado arriba (39% opacidad)
  static const Color profileCircle = Color(0xFF0B1735); // fondo círculo perfil

  // Textos
  static const Color white = Color(0xFFFFFFFF);
  static const Color hint = Color(0x73FFFFFF); // blanco 45% opacidad
  static const Color divider = Color(
    0xFF6B6B6B,
  ); // gris para textos secundarios y bordes

  // Conservados
  static const Color error = Color(0xFFFF0000);
}
