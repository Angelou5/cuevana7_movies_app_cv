import 'package:flutter/material.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';

class AppLogo extends StatelessWidget {
  final double? logoSize;
  final Color textColor;

  const AppLogo({super.key, this.logoSize, this.textColor = AppColors.dark});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final resolvedSize = logoSize ?? size.width * 0.35;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: resolvedSize,
          height: resolvedSize,
        ),
        SizedBox(height: size.height * 0.02),
        Text(
          'Cuevana 7',
          style: TextStyle(
            fontFamily: 'InclusiveSans',
            fontSize: resolvedSize * 0.4,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
