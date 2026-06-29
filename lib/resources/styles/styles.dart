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
    color: AppColors.hint,
    fontSize: 24,
    fontFamily: 'InclusiveSans',
  );

  static const TextStyle fieldText = TextStyle(
    color: AppColors.white,
    fontSize: 24,
    fontFamily: 'InclusiveSans',
  );

  static const TextStyle forgotPassword = TextStyle(
    color: AppColors.divider, // antes grey, ahora divider
    fontSize: 16,
    fontFamily: 'InclusiveSans',
  );

  static const TextStyle buttonLabel = TextStyle(
    color: AppColors.white,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    fontFamily: 'InclusiveSans',
  );

  static const TextStyle dividerLabel = TextStyle(
    // re-agregado
    color: AppColors.divider,
    fontSize: 18,
    fontFamily: 'InclusiveSans',
  );
}
