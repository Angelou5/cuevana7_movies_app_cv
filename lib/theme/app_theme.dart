import 'package:flutter/material.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';

// creamos una clase para agrupar la configuracion de nuestro tema
class AppTheme {
  //ThemData es una clase que representa toda la configuracion visual de nuestra app
  // getTheme() es un metodo que devuelve un objeto llamado ThemeData para estilizar nuestra aoo
  ThemeData getTheme() => ThemeData(
    // usematerial3 es una propieda que activa el material design 3
    useMaterial3: true,
    brightness: Brightness.dark,
    // 👇 ESTO ES LO QUE ARREGLA EL FLASH BLANCO:
    // Flutter usa este color de fondo mientras se construye/anima cada página,
    // antes de que tu Container con gradiente se pinte encima.
    scaffoldBackgroundColor: AppColors.background,
    canvasColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0X00f2002f),
      brightness: Brightness.dark,
      surface: AppColors.background,
    ),
  );
}
