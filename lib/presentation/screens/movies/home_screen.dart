import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/movie_provider.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/movie_card.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/review_card.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/bottom_nav_bar.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/bottom_fade_mask.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/error_view.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/auto_wide_carousel.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/faded_genre_section.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  static const String name = 'home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieProvider>().loadNowPlaying();
    });
  }

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

  List<dynamic> get _filteredMovies {
    final movies = context.read<MovieProvider>().movies;
    if (_searchQuery.isEmpty) return movies;
    return movies
        .where((m) => m.title.toLowerCase().contains(_searchQuery))
        .toList();
  }

  static const _sectionTitle = TextStyle(
    color: AppColors.white,
    fontSize: 24,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Contenido principal ─────────────────
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.background
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
                  Expanded(
                    child: BottomFadeMask(
                      child: RefreshIndicator(
                        color: AppColors.white,
                        backgroundColor: Colors.transparent,
                        onRefresh: () =>
                            context.read<MovieProvider>().loadNowPlaying(),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Resultados de búsqueda ───────────────────
                              if (_searchQuery.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 24),
                                  child:
                                      Text('Resultados', style: _sectionTitle),
                                ),
                                const SizedBox(height: 16),
                                Consumer<MovieProvider>(
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
                                ),
                                const SizedBox(height: 24),
                              ] else ...[
                                movieProvider.isLoading &&
                                        movieProvider.movies.isEmpty
                                    ? const SizedBox(
                                        height: 169,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.white,
                                          ),
                                        ),
                                      )
                                    : AutoWideCarousel(
                                        movies: _filteredMovies,
                                        height: 169,
                                      ),

                                // ── Novedades ────────────────────────────
                                const SizedBox(height: 24),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 24),
                                  child:
                                      Text('Novedades', style: _sectionTitle),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 190,
                                  child: movieProvider.isLoading &&
                                          movieProvider.movies.isEmpty
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.white,
                                          ),
                                        )
                                      : movieProvider.error != null &&
                                            movieProvider.movies.isEmpty
                                      ? ErrorView(
                                          error: movieProvider.error!,
                                          onRetry: () => context
                                              .read<MovieProvider>()
                                              .loadNowPlaying(),
                                        )
                                      : ShaderMask(
                                          shaderCallback: (bounds) =>
                                              const LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Colors.transparent,
                                              Colors.white,
                                              Colors.white,
                                              Colors.transparent,
                                            ],
                                            stops: [0.0, 0.08, 0.88, 1.0],
                                          ).createShader(bounds),
                                          blendMode: BlendMode.dstIn,
                                          child: ListView.separated(
                                            padding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 24,
                                            ),
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                _filteredMovies.length + 1,
                                            separatorBuilder: (_, _) =>
                                                const SizedBox(width: 10),
                                            itemBuilder: (context, index) {
                                              if (index ==
                                                  _filteredMovies.length) {
                                                return Center(
                                                  child: movieProvider.isLoading
                                                      ? const SizedBox(
                                                          width: 22,
                                                          height: 22,
                                                          child:
                                                              CircularProgressIndicator(
                                                                color: AppColors
                                                                    .white,
                                                                strokeWidth:
                                                                    2,
                                                              ),
                                                        )
                                                      : GestureDetector(
                                                          onTap: () => context
                                                              .read<
                                                                  MovieProvider>()
                                                              .loadNextPage(),
                                                          child: const Icon(
                                                            Icons
                                                                .chevron_right,
                                                            color: AppColors
                                                                .hint,
                                                            size: 22,
                                                          ),
                                                        ),
                                                );
                                              }
                                              return MovieCard(
                                                movie:
                                                    _filteredMovies[index],
                                              );
                                            },
                                          ),
                                        ),
                                ),

                                const SizedBox(height: 24),
                                FadedGenreSection(
                                  title: 'Comedias',
                                  movies: movieProvider.moviesComedia,
                                  onLoadMore: () => context
                                      .read<MovieProvider>()
                                      .loadNextGenrePage(35),
                                  isLoading: movieProvider.isLoadingGenre,
                                  error: movieProvider.error,
                                  onRetry: () => context
                                      .read<MovieProvider>()
                                      .loadNowPlaying(),
                                ),
                                const SizedBox(height: 24),
                                FadedGenreSection(
                                  title: 'Terror',
                                  movies: movieProvider.moviesTerror,
                                  onLoadMore: () => context
                                      .read<MovieProvider>()
                                      .loadNextGenrePage(27),
                                  isLoading: movieProvider.isLoadingGenre,
                                  error: movieProvider.error,
                                  onRetry: () => context
                                      .read<MovieProvider>()
                                      .loadNowPlaying(),
                                ),
                                const SizedBox(height: 24),
                                FadedGenreSection(
                                  title: 'Suspenso',
                                  movies: movieProvider.moviesSuspenso,
                                  onLoadMore: () => context
                                      .read<MovieProvider>()
                                      .loadNextGenrePage(53),
                                  isLoading: movieProvider.isLoadingGenre,
                                  error: movieProvider.error,
                                  onRetry: () => context
                                      .read<MovieProvider>()
                                      .loadNowPlaying(),
                                ),
                                const SizedBox(height: 24),
                                FadedGenreSection(
                                  title: 'Acción',
                                  movies: movieProvider.moviesAccion,
                                  onLoadMore: () => context
                                      .read<MovieProvider>()
                                      .loadNextGenrePage(28),
                                  isLoading: movieProvider.isLoadingGenre,
                                  error: movieProvider.error,
                                  onRetry: () => context
                                      .read<MovieProvider>()
                                      .loadNowPlaying(),
                                ),

                                // ── Opiniones ────────────────────────────
                                const SizedBox(height: 24),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 24),
                                  child:
                                      Text('Opiniones', style: _sectionTitle),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: movieProvider.movieReviews.isEmpty
                                      ? const Text(
                                          'No hay opiniones disponibles',
                                          style: TextStyle(
                                            color: AppColors.hint,
                                            fontFamily: 'InclusiveSans',
                                          ),
                                        )
                                      : Column(
                                          children: movieProvider.movieReviews
                                              .take(10)
                                              .map(
                                                (mr) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    bottom: 10,
                                                  ),
                                                  child: ReviewCard(
                                                    movieReview: mr,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                ),
                              ],
                              const SizedBox(height: 80),
                            ],
                          ),
                        ),
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
              child: BottomNavBar(activeTab: NavTab.home, isVisible: true),
            ),
          ),
        ],
      ),
    );
  }
}
