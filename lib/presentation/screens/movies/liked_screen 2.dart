import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/auth_provider.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/bottom_nav_bar.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/bottom_fade_mask.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/search_header.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/profile_menu_overlay.dart';

class LikedScreen extends StatefulWidget {
  static const String name = 'movies';
  const LikedScreen({super.key});

  @override
  State<LikedScreen> createState() => _LikedScreenState();
}

class _LikedScreenState extends State<LikedScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showProfileMenu = false;

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
                  SearchHeader(
                    controller: _searchController,
                    onChanged: (value) => setState(() {}),
                    onClear: _clearSearch,
                    onAvatarTap: () =>
                        setState(() => _showProfileMenu = !_showProfileMenu),
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Favoritos'),
                  ),
                  Expanded(
                    child: BottomFadeMask(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SizedBox(height: 140),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          ProfileMenuOverlay(
            isVisible: _showProfileMenu,
            onDismiss: () => setState(() => _showProfileMenu = false),
            onLogout: () {
              setState(() => _showProfileMenu = false);
              context.read<AuthProvider>().logout();
              context.go('/login');
            },
          ),

          // ── Navbar flotante sobre el contenido ─────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: BottomNavBar(
                activeTab: NavTab.movies,
                isVisible: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
