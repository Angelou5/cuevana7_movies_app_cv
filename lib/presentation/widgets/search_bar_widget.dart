import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final String hintText;
  final double height;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.onClear,
    this.hintText = 'Buscar',
    this.height = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(45),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          SvgPicture.asset(
            'assets/images/buscar.svg',
            width: 34,
            height: 34,
            colorFilter: const ColorFilter.mode(
              AppColors.white,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 23,
                fontFamily: 'InclusiveSans',
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: AppColors.white,
                  fontSize: 23,
                  fontFamily: 'InclusiveSans',
                ),
              ),
              onChanged: onChanged,
              onTapOutside: (_) {
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          // ── X para borrar todo ──
          // solo aparece cuando hay texto escrito
          if (controller.text.isNotEmpty && onClear != null)
            GestureDetector(
              onTap: onClear,
              child: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.close, color: AppColors.white, size: 24),
              ),
            ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
