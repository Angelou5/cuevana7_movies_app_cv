import 'package:flutter/material.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';

class AppStyles {
  AppStyles._();

  static const TextStyle title = TextStyle(
    color: AppColors.dark,
    fontSize: 32,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle hintField = TextStyle(
    color: AppColors.hint,
    fontSize: 18,
  );

  static const TextStyle fieldText = TextStyle(
    color: AppColors.dark,
    fontSize: 18,
  );

  static const TextStyle forgotPassword = TextStyle(
    color: AppColors.hint,
    fontSize: 16,
  );

  static const TextStyle buttonLabel = TextStyle(
    color: AppColors.buttonText,
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle dividerLabel = TextStyle(
    color: AppColors.dark,
    fontSize: 18,
  );
}
