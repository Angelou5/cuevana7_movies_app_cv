import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/auth_provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/movie_provider.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/bottom_nav_bar.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/profile_menu_item.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/logout_dialog.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/search_bar_widget.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/bottom_fade_mask.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/movie_card.dart';

class FavoriteScreen extends StatefulWidget {
  static const String name = 'favorites';
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showProfileMenu = false;

  // Mismo estilo que usa HomeScreen para "Novedades", "Comedias", etc.
  static const _sectionTitle = TextStyle(
    color: AppColors.white,
    fontSize: 24,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {});
    FocusScope.of(context).unfocus();
  }

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
      backgroundColor: AppColors.background,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SearchBarWidget(
                            controller: _searchController,
                            onChanged: (value) => setState(() {}),
                            onClear: _clearSearch,
                          ),
                        ),
                        const SizedBox(width: 12),
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
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Guardados', style: _sectionTitle),
                  ),
                  Expanded(
                    child: BottomFadeMask(
                      child: Consumer<MovieProvider>(
                        builder: (context, movieProvider, _) {
                          final favorites = movieProvider.favoriteMovies;
                          if (favorites.isEmpty) {
                            return RefreshIndicator(
                              color: AppColors.white,
                              backgroundColor: Colors.transparent,
                              onRefresh: () =>
                                  context.read<MovieProvider>().loadFavorites(),
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    SizedBox(height: 80),
                                    Center(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.bookmark_border_rounded,
                                            color: AppColors.hint,
                                            size: 48,
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            'Aún no tienes películas guardadas',
                                            style: TextStyle(
                                              color: AppColors.hint,
                                              fontSize: 14,
                                              fontFamily: 'InclusiveSans',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 140),
                                  ],
                                ),
                              ),
                            );
                          }
                          return RefreshIndicator(
                            color: AppColors.white,
                            backgroundColor: Colors.transparent,
                            onRefresh: () =>
                                context.read<MovieProvider>().loadFavorites(),
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                16,
                                24,
                                140,
                              ),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 0.62,
                                    ),
                                itemCount: favorites.length,
                                itemBuilder: (context, index) {
                                  return MovieCard(movie: favorites[index]);
                                },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_showProfileMenu)
            GestureDetector(
              onTap: () => setState(() => _showProfileMenu = false),
              child: Container(color: Colors.transparent),
            ),

          if (_showProfileMenu)
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

          // ── Navbar flotante sobre el contenido ─────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: BottomNavBar(activeTab: NavTab.favorites, isVisible: true),
            ),
          ),
        ],
      ),
    );
  }
}
