import 'package:flutter/material.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/resources/styles/styles.dart';

class AccountDivider extends StatelessWidget {
  const AccountDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 53,
          child: Divider(color: AppColors.divider, thickness: 1),
        ),
        Expanded(
          child: Center(
            child: Text(
              '¿Ya tienes una cuenta?',
              style: AppStyles.dividerLabel,
            ),
          ),
        ),
        const SizedBox(
          width: 53,
          child: Divider(color: AppColors.divider, thickness: 1),
        ),
      ],
    );
  }
}
