import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/movie_provider.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/bottom_nav_bar.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/bottom_fade_mask.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/movie_card.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/search_bar_widget.dart';
import 'package:cuevana7_movies_app_cv/services/favorites_pdf_service.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/app_snackbar.dart';

class FavoriteScreen extends StatefulWidget {
  static const String name = 'favorites';
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isGeneratingPdf = false;

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
    setState(() => _searchQuery = '');
    context.read<MovieProvider>().clearSearch();
    FocusScope.of(context).unfocus();
  }

  Future<void> _downloadFavoritesPdf() async {
    final favorites = context.read<MovieProvider>().favoriteMovies;

    if (favorites.isEmpty) {
      showErrorSnackBar(context, 'No tienes películas guardadas para exportar');
      return;
    }

    setState(() => _isGeneratingPdf = true);
    try {
      await FavoritesPdfService.generateAndShare(favorites);
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, 'No se pudo generar el PDF: $e');
      }
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
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
            decoration: const BoxDecoration(color: AppColors.background),
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
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value.toLowerCase();
                              });
                              context.read<MovieProvider>().onSearchChanged(
                                value,
                              );
                            },
                            onClear: _clearSearch,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text('Guardados', style: _sectionTitle),
                        ),
                        Consumer<MovieProvider>(
                          builder: (context, movieProvider, _) {
                            final hasFavorites =
                                movieProvider.favoriteMovies.isNotEmpty;
                            return IconButton(
                              onPressed: (!hasFavorites || _isGeneratingPdf)
                                  ? null
                                  : _downloadFavoritesPdf,
                              tooltip: 'Descargar en PDF',
                              icon: _isGeneratingPdf
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: AppColors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(
                                      Icons.picture_as_pdf_outlined,
                                      color: hasFavorites
                                          ? AppColors.white
                                          : AppColors.hint,
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: BottomFadeMask(
                      child: _searchQuery.isNotEmpty
                          ? Consumer<MovieProvider>(
                              builder: (context, mp, _) {
                                if (mp.isSearching) {
                                  return const SizedBox(
                                    height: 300,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                }
                                if (mp.searchResults.isEmpty) {
                                  return const SizedBox(
                                    height: 300,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.search_off_rounded,
                                            color: AppColors.hint,
                                            size: 48,
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            'Sin resultados',
                                            style: TextStyle(
                                              color: AppColors.hint,
                                              fontSize: 16,
                                              fontFamily: 'InclusiveSans',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 12,
                                          childAspectRatio: 0.62,
                                        ),
                                    itemCount: mp.searchResults.length,
                                    itemBuilder: (context, index) {
                                      return MovieCard(
                                        movie: mp.searchResults[index],
                                      );
                                    },
                                  ),
                                );
                              },
                            )
                          : Consumer<MovieProvider>(
                              builder: (context, movieProvider, _) {
                                final favorites = movieProvider.favoriteMovies;
                                if (favorites.isEmpty) {
                                  return RefreshIndicator(
                                    color: AppColors.white,
                                    backgroundColor: Colors.transparent,
                                    onRefresh: () => context
                                        .read<MovieProvider>()
                                        .loadFavorites(),
                                    child: SingleChildScrollView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                  onRefresh: () => context
                                      .read<MovieProvider>()
                                      .loadFavorites(),
                                  child: SingleChildScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        24,
                                        16,
                                        24,
                                        140,
                                      ),
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 12,
                                              mainAxisSpacing: 12,
                                              childAspectRatio: 0.62,
                                            ),
                                        itemCount: favorites.length,
                                        itemBuilder: (context, index) {
                                          return MovieCard(
                                            movie: favorites[index],
                                          );
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
