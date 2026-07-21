import 'package:flutter/material.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/search_bar_widget.dart';

/// Fila con barra de búsqueda y avatar de perfil. Compartida entre
/// HomeScreen, FavoriteScreen y LikedScreen.
class SearchHeader extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback onAvatarTap;

  const SearchHeader({
    super.key,
    required this.controller,
    this.onChanged,
    this.onClear,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        children: [
          Expanded(
            child: SearchBarWidget(
              controller: controller,
              onChanged: onChanged,
              onClear: onClear,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onAvatarTap,
            child: Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFF8E8E93),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
