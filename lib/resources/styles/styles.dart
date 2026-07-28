import 'package:flutter/material.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';

class AppStyles {
  AppStyles._();

  static const TextStyle appName = TextStyle(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    fontFamily: 'Montserrat',
  );

  static const TextStyle title = TextStyle(
    color: AppColors.white,
    fontSize: 32,
    fontWeight: FontWeight.w500,
    fontFamily: 'Montserrat',
  );

  static const TextStyle hintField = TextStyle(
    color: AppColors.white,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
  );

  static const TextStyle fieldText = TextStyle(
    color: AppColors.white,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
  );

  static const TextStyle forgotPassword = TextStyle(
    color: AppColors.white, // antes grey, ahora divider
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
  );

  static const TextStyle buttonLabel = TextStyle(
    color: AppColors.white,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
  );

  static const TextStyle dividerLabel = TextStyle(
    // re-agregado
    color: AppColors.divider,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
  );
}
