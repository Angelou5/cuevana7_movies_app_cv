import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/auth_provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/movie_provider.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/wide_movie_card.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/movie_card.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/review_card.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/bottom_nav_bar.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/search_bar_widget.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/bottom_fade_mask.dart';

class HomeScreen extends StatefulWidget {
  static const String name = 'home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  bool _showProfileMenu = false;

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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF2C2C2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '¿Estás seguro?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'InclusiveSans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() => _showProfileMenu = false);
                      context.read<AuthProvider>().logout();
                      context.go('/login');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB94040),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        'Cerrar sesión',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'InclusiveSans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A3A3C),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'InclusiveSans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
                  Expanded(
                    child: BottomFadeMask(
                      child: SingleChildScrollView(
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
                                          padding: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child:
                                                    movie.posterPath.isNotEmpty
                                                    ? Image.network(
                                                        movie.posterPath,
                                                        width: 50,
                                                        height: 70,
                                                        fit: BoxFit.cover,
                                                        errorBuilder:
                                                            (_, __, ___) =>
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color: AppColors.white,
                                                        fontSize: 14,
                                                        fontFamily:
                                                            'InclusiveSans',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      '${movie.releaseDate.year}',
                                                      style: const TextStyle(
                                                        color: AppColors.hint,
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'InclusiveSans',
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
                                                        const SizedBox(
                                                          width: 3,
                                                        ),
                                                        Text(
                                                          movie.voteAverage
                                                              .toStringAsFixed(
                                                                1,
                                                              ),
                                                          style: const TextStyle(
                                                            color:
                                                                AppColors.hint,
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
                              ),
                              const SizedBox(height: 24),
                              _FadedGenreSection(
                                title: 'Terror',
                                movies: movieProvider.moviesTerror,
                              ),
                              const SizedBox(height: 24),
                              _FadedGenreSection(
                                title: 'Suspenso',
                                movies: movieProvider.moviesSuspenso,
                              ),
                              const SizedBox(height: 24),
                              _FadedGenreSection(
                                title: 'Acción',
                                movies: movieProvider.moviesAccion,
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
                            // quede tapado detrás de la navbar flotante,
                            // usando el mismo espaciado que entre reviews ──
                            const SizedBox(height: 10),
                          ],
                        ),
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
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _ProfileMenuItem(
                        icon: Icons.person_outline_rounded,
                        label: 'Mi cuenta',
                        onTap: () => setState(() => _showProfileMenu = false),
                      ),
                      _ProfileMenuItem(
                        icon: Icons.tune_rounded,
                        label: 'Configuraciones',
                        onTap: () => setState(() => _showProfileMenu = false),
                      ),
                      _ProfileMenuItem(
                        icon: Icons.help_outline_rounded,
                        label: 'Ayuda',
                        onTap: () => setState(() => _showProfileMenu = false),
                      ),
                      _ProfileMenuItem(
                        icon: Icons.star_border_rounded,
                        label: 'Mis opiniones',
                        onTap: () => setState(() => _showProfileMenu = false),
                      ),
                      _ProfileMenuItem(
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
                      _ProfileMenuItem(
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

  @override
  void didUpdateWidget(covariant _AutoWideCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // si cambia la lista (ej. filtro de búsqueda), reinicia el autoplay
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
    if (widget.movies.isEmpty) {
      return SizedBox(height: widget.height);
    }

    return SizedBox(
      height: widget.height,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is UserScrollNotification) {
            _startAutoPlay();
          }
          return false;
        },
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.movies.length,
          onPageChanged: (index) => _currentPage = index,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _horizontalPadding,
              ),
              child: Center(child: WideMovieCard(movie: widget.movies[index])),
            );
          },
        ),
      ),
    );
  }
}

class _FadedGenreSection extends StatelessWidget {
  final String title;
  final List<dynamic> movies;
  const _FadedGenreSection({required this.title, required this.movies});

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
          child: movies.isEmpty
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
                        child: GestureDetector(
                          onTap: () {
                            // Aquí puedes manejar la lógica en el futuro para cargar más películas de este género
                            debugPrint('Cargar más películas de $title'); 
                          },
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

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? const Color(0xFFE05C5C) : Colors.white;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontFamily: 'InclusiveSans',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
