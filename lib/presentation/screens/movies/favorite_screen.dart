import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/auth_provider.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/bottom_nav_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                      // ── Buscador + Logo ──────────────────────────────
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
                            GestureDetector(
                              onTap: () {
                                context.read<AuthProvider>().logout();
                                context.go('/login');
                              },
                              child: Hero(
                                tag: 'app-logo',
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  width: 48,
                                  height: 48,
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
    );
  }
}
