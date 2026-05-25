import 'package:flutter/material.dart';

// creamos una clase para agrupar la configuracion de nuestro tema
class AppTheme 
{
  //ThemData es una clase que representa toda la configuracion visual de nuestra app
  // getTheme() es un metodo que devuelve un objeto llamado ThemeData para estilizar nuestra aoo
  ThemeData getTheme()=> ThemeData(
    // usematerial3 es una propieda que activa el material design 3
    useMaterial3: true,
    // Colorschemeseed es una propiedad que ayuda a definir una paleta de colores 
    colorSchemeSeed:const Color(0X00f2002f)
  );
}