import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';

enum NavTab { home, favorites, profile }

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
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 6),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFA1B1B1B), // rgba(27, 27, 27, 0.98)
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  iconPath: 'assets/images/icono_home.svg',
                  // [TAREA: Ícono blanco al estar activo]
                  activeIconPath: 'assets/images/homewhite.svg',
                  label: 'Inicio',
                  isActive: activeTab == NavTab.home,
                  onTap: activeTab == NavTab.home
                      ? null
                      : () => context.go('/'),
                ),
                _NavItem(
                  iconPath: 'assets/images/favorite.svg',
                  // [TAREA: Ícono blanco al estar activo]
                  activeIconPath: 'assets/images/favoritewhite.svg',
                  label: 'Guardados',
                  isActive: activeTab == NavTab.favorites,
                  onTap: activeTab == NavTab.favorites
                      ? null
                      : () => context.go('/favorites'),
                ),
                _NavItem(
                  iconData: Icons.person_outline,
                  activeIconData: Icons.person,
                  label: 'Perfil',
                  isActive: activeTab == NavTab.profile,
                  onTap: activeTab == NavTab.profile
                      ? null
                      : () => context.go('/configuracion'),
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
  final String? iconPath;
  final String? activeIconPath;
  final IconData? iconData;
  final IconData? activeIconData;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavItem({
    this.iconPath,
    this.activeIconPath,
    this.iconData,
    this.activeIconData,
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: _buildIcon(),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (iconData != null && activeIconData != null) {
      return Icon(
        isActive ? activeIconData! : iconData!,
        size: 30,
        color: isActive ? Colors.white : AppColors.divider,
      );
    }
    return isActive
        ? SvgPicture.asset(activeIconPath!, width: 30, height: 30)
        : SvgPicture.asset(
            iconPath!,
            width: 30,
            height: 30,
            colorFilter: const ColorFilter.mode(
              AppColors.divider,
              BlendMode.srcIn,
            ),
          );
  }
}
