import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/auth_provider.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/bottom_nav_bar.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/profile_menu_item.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/logout_dialog.dart';

class FavoriteScreen extends StatefulWidget {
  static const String name = 'favorites';
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isNavBarVisible = true;
  double _lastScrollOffset = 0;
  // [TAREA: Menú desplegable de perfil] — controla visibilidad del dropdown
  bool _showProfileMenu = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final current = _scrollController.offset;
    const threshold = 10.0;
    if (current > _lastScrollOffset + threshold && _isNavBarVisible) {
      setState(() => _isNavBarVisible = false);
    } else if (current < _lastScrollOffset - threshold && !_isNavBarVisible) {
      setState(() => _isNavBarVisible = true);
    }
    _lastScrollOffset = current;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // [TAREA: Menú desplegable de perfil] — dialog de confirmación al cerrar sesión
  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (_) => LogoutDialog(
        onConfirm: () {
          setState(() => _showProfileMenu = false);
          context.read<AuthProvider>().logout();
          context.go('/login');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.20, 1.0],
                colors: [AppColors.background, AppColors.dark],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Buscador + Avatar ─────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 24,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 64,
                                decoration: BoxDecoration(
                                  color: AppColors.inputFill,
                                  borderRadius: BorderRadius.circular(45),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 16,
                                    fontFamily: 'InclusiveSans',
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Buscar',
                                    hintStyle: TextStyle(
                                      color: AppColors.hint,
                                      fontSize: 24,
                                      fontFamily: 'InclusiveSans',
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: AppColors.hint,
                                      size: 22,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 20,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      setState(() => _isNavBarVisible = true);
                                    }
                                  },
                                  onTapOutside: (_) {
                                    FocusScope.of(context).unfocus();
                                    _searchController.clear();
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // [TAREA: Menú desplegable de perfil] — avatar que abre el dropdown
                            GestureDetector(
                              onTap: () => setState(
                                () => _showProfileMenu = !_showProfileMenu,
                              ),
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
                      ),

                      // ── Contenido futuro aquí ──────────────────────────
                    ],
                  ),
                ),
              ),

              // ── Navbar flotante ──────────────────────────────────────────
              BottomNavBar(
                activeTab: NavTab.favorites,
                isVisible: _isNavBarVisible,
              ),
            ],
          ),
        ),
      ),

          // [TAREA: Menú desplegable de perfil] — tap fuera cierra el dropdown
          if (_showProfileMenu)
            GestureDetector(
              onTap: () => setState(() => _showProfileMenu = false),
              child: Container(color: Colors.transparent),
            ),

          // [TAREA: Menú desplegable de perfil] — panel del dropdown posicionado bajo el avatar
          if (_showProfileMenu)
            Positioned(
              top: MediaQuery.of(context).padding.top + 88,
              right: 24,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  // [TAREA: Fix overflow] — ancho aumentado de 260 a 290 para que
                  // "Lista de reproducción" no desborde
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
                        onTap: () => setState(() => _showProfileMenu = false),
                      ),
                      ProfileMenuItem(
                        icon: Icons.tune_rounded,
                        label: 'Configuraciones',
                        onTap: () => setState(() => _showProfileMenu = false),
                      ),
                      ProfileMenuItem(
                        icon: Icons.help_outline_rounded,
                        label: 'Ayuda',
                        onTap: () => setState(() => _showProfileMenu = false),
                      ),
                      ProfileMenuItem(
                        icon: Icons.star_border_rounded,
                        label: 'Mis opiniones',
                        onTap: () => setState(() => _showProfileMenu = false),
                      ),
                      ProfileMenuItem(
                        icon: Icons.history_rounded,
                        label: 'Lista de reproducción',
                        onTap: () => setState(() => _showProfileMenu = false),
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
                          setState(() => _showProfileMenu = false);
                          _showLogoutDialog();
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
