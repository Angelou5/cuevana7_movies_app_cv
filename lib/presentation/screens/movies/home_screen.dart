import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/movie_provider.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/wide_movie_card.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/movie_card.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/review_card.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/bottom_nav_bar.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/search_bar_widget.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/bottom_fade_mask.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/error_view.dart';
import 'package:cuevana7_movies_app_cv/presentation/screens/movies/configuracion_screen.dart';

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
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Contenido principal ─────────────────
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
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ConfiguracionScreen(),
                              ),
                            );
                          },
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
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Text('Resultados', style: _sectionTitle),
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
                                  : _AutoWideCarousel(
                                      movies: _filteredMovies,
                                      height: 169,
                                    ),

                              // ── Novedades ────────────────────────────
                              const SizedBox(height: 24),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Text('Novedades', style: _sectionTitle),
                              ),
                              const SizedBox(height: 10),
                              // [TAREA: Desvanecido izquierdo carruseles] — carrusel novedades con fade
                              _LeftFadedCarousel(
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
                                    ? ErrorView(
                                        error: movieProvider.error!,
                                        onRetry: () => context
                                            .read<MovieProvider>()
                                            .loadNowPlaying(),
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
                                                            color:
                                                                AppColors.white,
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

                              const SizedBox(height: 24),
                              _FadedGenreSection(
                                title: 'Comedias',
                                movies: movieProvider.moviesComedia,
                                onLoadMore: () =>
                                    context.read<MovieProvider>().loadNextGenrePage(35),
                                isLoading: movieProvider.isLoadingGenre,
                                error: movieProvider.error,
                                onRetry: () => context.read<MovieProvider>().loadNowPlaying(),
                              ),
                              const SizedBox(height: 24),
                              _FadedGenreSection(
                                title: 'Terror',
                                movies: movieProvider.moviesTerror,
                                onLoadMore: () =>
                                    context.read<MovieProvider>().loadNextGenrePage(27),
                                isLoading: movieProvider.isLoadingGenre,
                                error: movieProvider.error,
                                onRetry: () => context.read<MovieProvider>().loadNowPlaying(),
                              ),
                              const SizedBox(height: 24),
                              _FadedGenreSection(
                                title: 'Suspenso',
                                movies: movieProvider.moviesSuspenso,
                                onLoadMore: () =>
                                    context.read<MovieProvider>().loadNextGenrePage(53),
                                isLoading: movieProvider.isLoadingGenre,
                                error: movieProvider.error,
                                onRetry: () => context.read<MovieProvider>().loadNowPlaying(),
                              ),
                              const SizedBox(height: 24),
                              _FadedGenreSection(
                                title: 'Acción',
                                movies: movieProvider.moviesAccion,
                                onLoadMore: () =>
                                    context.read<MovieProvider>().loadNextGenrePage(28),
                                isLoading: movieProvider.isLoadingGenre,
                                error: movieProvider.error,
                                onRetry: () => context.read<MovieProvider>().loadNowPlaying(),
                              ),

                              // ── Opiniones ────────────────────────────
                              const SizedBox(height: 24),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Text('Opiniones', style: _sectionTitle),
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
                                                padding: const EdgeInsets.only(
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
                            // ── Espacio final para que el contenido no
                            // quede tapado detrás de la navbar flotante ──
                            const SizedBox(height: 110),
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

class _AutoWideCarousel extends StatefulWidget {
  final List<dynamic> movies;
  final double height;
  const _AutoWideCarousel({required this.movies, required this.height});

  @override
  State<_AutoWideCarousel> createState() => _AutoWideCarouselState();
}

class _AutoWideCarouselState extends State<_AutoWideCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  static const double _horizontalPadding = 24;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    if (widget.movies.length <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final next = (_currentPage + 1) % widget.movies.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  // Pausa el timer sin cancelarlo definitivamente
  void _pauseAutoPlay() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void didUpdateWidget(covariant _AutoWideCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.movies.length != widget.movies.length) {
      _currentPage = 0;
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) return SizedBox(height: widget.height);

    return Column(
      children: [
        // ── Carrusel principal ──────────────────────────────────
        SizedBox(
          height: widget.height,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is UserScrollNotification) _startAutoPlay();
              return false;
            },
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.movies.length,
              onPageChanged: (index) {
                // setState aquí para que los dots se actualicen
                // cada vez que cambia la página (manual o automático)
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _horizontalPadding,
                  ),
                  child: Center(
                    child: WideMovieCard(
                      movie: widget.movies[index],
                      // Al abrir "Ver más" pausa el carrusel
                      onShowDescription: _pauseAutoPlay,
                      // Al cerrar lo reanuda desde donde iba
                      onHideDescription: _startAutoPlay,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // ── Dots indicadores ────────────────────────────────────
        // Mostramos máximo 5 dots aunque haya más películas,
        // para que no se vean demasiados y luzca limpio.
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.movies.length.clamp(0, 5), (index) {
            final isActive = index == (_currentPage % 5);
            return AnimatedContainer(
              // AnimatedContainer hace la transición suave de
              // tamaño y color al cambiar de página, sin necesitar
              // ninguna animación manual extra.
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 24 : 8, // el activo es más ancho
              height: 8,
              decoration: BoxDecoration(
                // el activo es blanco brillante, los demás grises
                color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _FadedGenreSection extends StatelessWidget {
  final String title;
  final List<dynamic> movies;
  final VoidCallback? onLoadMore;
  final bool isLoading;
  final dynamic error;
  final VoidCallback? onRetry;
  const _FadedGenreSection({required this.title, required this.movies, this.onLoadMore, this.isLoading = false, this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 24,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 10),
        _LeftFadedCarousel(
          height: 190,
          child: movies.isEmpty && error != null
              ? ErrorView(
                  error: error,
                  onRetry: onRetry,
                )
              : movies.isEmpty
              ? const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,

                  // 1. Agregamos el +1 para hacerle espacio a la flecha
                  itemCount: movies.length + 1,

                  separatorBuilder: (_, __) => const SizedBox(width: 10),

                  // 2. Expandimos el itemBuilder con la condición
                  itemBuilder: (context, index) {
                    if (index == movies.length) {
                      return Center(
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : GestureDetector(
                                onTap: onLoadMore,
                                child: const Icon(
                                  Icons.chevron_right,
                                  color: AppColors.hint,
                                  size: 22,
                                ),
                              ),
                      );
                    }

                    // Si no es el último índice, dibuja la película normal
                    return MovieCard(movie: movies[index]);
                  },
                ),
        ),
      ],
    );
  }
}

// un ShaderMask con degradado solo del lado izquierdo (transparente → opaco)
class _LeftFadedCarousel extends StatelessWidget {
  final Widget child;
  final double height;

  const _LeftFadedCarousel({required this.child, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
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
        child: child,
      ),
    );
  }
}
