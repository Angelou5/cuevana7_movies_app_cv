import 'package:flutter/material.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/profile_menu_item.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/logout_dialog.dart';

/// Overlay del menú de perfil que se superpone al contenido.
/// Compartido entre HomeScreen, FavoriteScreen y LikedScreen.
class ProfileMenuOverlay extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onDismiss;
  final VoidCallback onLogout;

  const ProfileMenuOverlay({
    super.key,
    required this.isVisible,
    required this.onDismiss,
    required this.onLogout,
  });

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (_) => LogoutDialog(onConfirm: onLogout),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Stack(
      children: [
        GestureDetector(
          onTap: onDismiss,
          child: Container(color: Colors.transparent),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 88,
          right: 24,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 290,
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  ProfileMenuItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Mi cuenta',
                    onTap: onDismiss,
                  ),
                  ProfileMenuItem(
                    icon: Icons.tune_rounded,
                    label: 'Configuraciones',
                    onTap: onDismiss,
                  ),
                  ProfileMenuItem(
                    icon: Icons.help_outline_rounded,
                    label: 'Ayuda',
                    onTap: onDismiss,
                  ),
                  ProfileMenuItem(
                    icon: Icons.star_border_rounded,
                    label: 'Mis opiniones',
                    onTap: onDismiss,
                  ),
                  ProfileMenuItem(
                    icon: Icons.history_rounded,
                    label: 'Lista de reproducción',
                    onTap: onDismiss,
                  ),
                  const Divider(
                    color: Color(0xFF3A3A3C),
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  ProfileMenuItem(
                    icon: Icons.logout_rounded,
                    label: 'Cerrar sesión',
                    isDestructive: true,
                    onTap: () {
                      onDismiss();
                      _showLogoutDialog(context);
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
