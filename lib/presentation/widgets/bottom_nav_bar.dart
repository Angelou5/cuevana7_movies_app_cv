import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';

enum NavTab { home, favorites, movies }

class BottomNavBar extends StatelessWidget {
  final NavTab activeTab;
  final bool isVisible;

  const BottomNavBar({
    super.key,
    required this.activeTab,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        heightFactor: isVisible ? 1.0 : 0.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.83),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  iconPath: 'assets/images/icono_home.svg',
                  label: 'Inicio',
                  isActive: activeTab == NavTab.home,
                  onTap: activeTab == NavTab.home
                      ? null
                      : () => context.go('/'),
                ),
                _NavItem(
                  iconPath: 'assets/images/icono_fav.svg',
                  label: 'Guardados',
                  isActive: activeTab == NavTab.favorites,
                  onTap: activeTab == NavTab.favorites
                      ? null
                      : () => context.go('/favorites'),
                ),
                _NavItem(
                  iconPath: 'assets/images/icono_peli.svg',
                  label: 'Películas',
                  isActive: activeTab == NavTab.movies,
                  onTap: activeTab == NavTab.movies
                      ? null
                      : () => context.go('/movies'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavItem({
    required this.iconPath,
    required this.label,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.white.withValues(alpha: 0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SvgPicture.asset(
            iconPath,
            width: 28,
            height: 28,
            colorFilter: ColorFilter.mode(
              isActive ? AppColors.white : AppColors.hint,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
