import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/auth_provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/movie_provider.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/wide_movie_card.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/movie_card.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/genre_section.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/review_card.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  static const String name = 'home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isNavBarVisible = true;
  double _lastScrollOffset = 0;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.microtask(() {
      context.read<MovieProvider>().loadNowPlaying();
    });
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

  List<dynamic> get _filteredMovies {
    final movies = context.read<MovieProvider>().movies;
    if (_searchQuery.isEmpty) return movies;
    return movies
        .where((m) => m.title.toLowerCase().contains(_searchQuery))
        .toList();
  }

  Widget _posterPlaceholder() => Container(
    width: 50,
    height: 70,
    decoration: BoxDecoration(
      color: AppColors.inputFill,
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.movie, color: AppColors.hint),
  );

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
                                    setState(() {
                                      _searchQuery = value.toLowerCase();
                                      if (value.isNotEmpty) {
                                        _isNavBarVisible = true;
                                      }
                                    });
                                    context
                                        .read<MovieProvider>()
                                        .onSearchChanged(value);
                                  },
                                  onTapOutside: (_) {
                                    FocusScope.of(context).unfocus();
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                    context.read<MovieProvider>().clearSearch();
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

                      // ── Resultados de búsqueda ──────────────────────
                      if (_searchQuery.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text('Resultados', style: _sectionTitle),
                        ),
                        const SizedBox(height: 10),
                        Consumer<MovieProvider>(
                          builder: (context, mp, _) {
                            if (mp.isSearching) {
                              return const Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            }
                            if (mp.searchResults.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: Center(
                                  child: Text(
                                    'Sin resultados',
                                    style: TextStyle(
                                      color: AppColors.hint,
                                      fontFamily: 'InclusiveSans',
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Column(
                                children: mp.searchResults.map((movie) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: movie.posterPath.isNotEmpty
                                              ? Image.network(
                                                  movie.posterPath,
                                                  width: 50,
                                                  height: 70,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      _posterPlaceholder(),
                                                )
                                              : _posterPlaceholder(),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                movie.title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 14,
                                                  fontFamily: 'InclusiveSans',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${movie.releaseDate.year}',
                                                style: const TextStyle(
                                                  color: AppColors.hint,
                                                  fontSize: 12,
                                                  fontFamily: 'InclusiveSans',
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                    size: 13,
                                                  ),
                                                  const SizedBox(width: 3),
                                                  Text(
                                                    movie.voteAverage
                                                        .toStringAsFixed(1),
                                                    style: const TextStyle(
                                                      color: AppColors.hint,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          'InclusiveSans',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                      ] else ...[
                        // ── Carrusel destacado ──────────────────────────
                        SizedBox(
                          height: 169,
                          child:
                              movieProvider.isLoading &&
                                  movieProvider.movies.isEmpty
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.white,
                                  ),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _filteredMovies.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 12),
                                  itemBuilder: (context, index) =>
                                      WideMovieCard(
                                        movie: _filteredMovies[index],
                                      ),
                                ),
                        ),

                        // ── Novedades ───────────────────────────────────
                        const SizedBox(height: 24),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text('Novedades', style: _sectionTitle),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 190,
                          child:
                              movieProvider.isLoading &&
                                  movieProvider.movies.isEmpty
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.white,
                                  ),
                                )
                              : movieProvider.error != null &&
                                    movieProvider.movies.isEmpty
                              ? Center(
                                  child: Text(
                                    '${movieProvider.error}',
                                    style: const TextStyle(
                                      color: AppColors.hint,
                                      fontFamily: 'InclusiveSans',
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _filteredMovies.length + 1,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 10),
                                  itemBuilder: (context, index) {
                                    if (index == _filteredMovies.length) {
                                      return Center(
                                        child: movieProvider.isLoading
                                            ? const SizedBox(
                                                width: 22,
                                                height: 22,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: AppColors.white,
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                            : GestureDetector(
                                                onTap: () => context
                                                    .read<MovieProvider>()
                                                    .loadNextPage(),
                                                child: const Icon(
                                                  Icons.chevron_right,
                                                  color: AppColors.hint,
                                                  size: 22,
                                                ),
                                              ),
                                      );
                                    }
                                    return MovieCard(
                                      movie: _filteredMovies[index],
                                    );
                                  },
                                ),
                        ),

                        // ── Secciones por género ────────────────────────
                        const SizedBox(height: 24),
                        GenreSection(
                          title: 'Películas familiares',
                          movies: movieProvider.moviesFamilia,
                        ),
                        const SizedBox(height: 24),
                        GenreSection(
                          title: 'Comedias',
                          movies: movieProvider.moviesComedia,
                        ),
                        const SizedBox(height: 24),
                        GenreSection(
                          title: 'Terror',
                          movies: movieProvider.moviesTerror,
                        ),
                        const SizedBox(height: 24),
                        GenreSection(
                          title: 'Suspenso',
                          movies: movieProvider.moviesSuspenso,
                        ),
                        const SizedBox(height: 24),
                        GenreSection(
                          title: 'Acción',
                          movies: movieProvider.moviesAccion,
                        ),

                        // ── Opiniones ───────────────────────────────────
                        const SizedBox(height: 24),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text('Opiniones', style: _sectionTitle),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
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
                                          padding: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                          child: ReviewCard(movieReview: mr),
                                        ),
                                      )
                                      .toList(),
                                ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // ── Navbar flotante compartida ───────────────────────────────
              BottomNavBar(activeTab: NavTab.home, isVisible: _isNavBarVisible),
            ],
          ),
        ),
      ),
    );
  }
}
