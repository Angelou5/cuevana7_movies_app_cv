import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/movie.dart';
import 'package:cuevana7_movies_app_cv/implements/datasources/movie_db_datasource.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/auth_provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/movie_provider.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';

class HomeScreen extends StatefulWidget {
  static const String name = 'home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _movieDbDatasource = MovieDbDatasource();
  List<Movie> _familyMovies = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieProvider>().loadNowPlaying();
    });
    _loadFamilyMovies();
  }

  Future<void> _loadFamilyMovies() async {
    try {
      final movies = await _movieDbDatasource.getMoviesByGenre(10751);
      if (!mounted) return;
      setState(() => _familyMovies = movies);
    } catch (e) {
      if (!mounted) return;
      setState(() => _familyMovies = []);
    }
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,

      // Bottom Navigation Bar fijo abajo 
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.dark,
          border: Border(
            top: BorderSide(color: AppColors.inputFill, width: 0.5),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.home, color: AppColors.buttonText, size: 26),
            Icon(Icons.bookmark_border, color: AppColors.buttonText, size: 26),
            Icon(Icons.favorite_border, color: AppColors.buttonText, size: 26),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título "Home" + botón logout 
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 8, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Home',
                      style: TextStyle(
                        color: AppColors.hint,
                        fontSize: 15,
                        fontFamily: 'InclusiveSans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        color: AppColors.hint,
                        size: 20,
                      ),
                      onPressed: () {
                        context.read<AuthProvider>().logout();
                        context.go('/login');
                      },
                    ),
                  ],
                ),
              ),

              // ── Barra de búsqueda + logo 
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.inputFill,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const TextField(
                          style: TextStyle(
                            color: AppColors.dark,
                            fontSize: 16,
                            fontFamily: 'InclusiveSans',
                          ),
                          decoration: InputDecoration(
                            hintText: 'Buscar',
                            hintStyle: TextStyle(
                              color: AppColors.hint,
                              fontFamily: 'InclusiveSans',
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Icon(Icons.search, color: AppColors.hint, size: 20),
                            ),
                            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Hero(
                      tag: 'app-logo',
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 36,
                        height: 36,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ── Banner principal: carrusel AUTOMÁTICO cada 4s 
              // Le pasamos la lista completa de películas; el widget
              // internamente se encarga de rotarlas solo con un Timer.
              _AutoHeroBanner(
                movies: movieProvider.movies,
                // key distinta para que Flutter no confunda este timer
                // con el de "Para ver en familia" de más abajo
                key: const ValueKey('hero-novedades'),
              ),

              const SizedBox(height: 16),

              // ── Sección: Géneros populares 
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Géneros populares',
                  style: TextStyle(
                    color: AppColors.dark,
                    fontSize: 16,
                    fontFamily: 'InclusiveSans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _GenreChipsRow(),

              const SizedBox(height: 20),

              // ── Sección: Novedades (carrusel real desde la API) ─────
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Novedades',
                  style: TextStyle(
                    color: AppColors.dark,
                    fontSize: 16,
                    fontFamily: 'InclusiveSans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _MovieCarousel(movieProvider: movieProvider),

              const SizedBox(height: 20),

              // ── Sección: Para ver en familia (carrusel automático) ──
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Para ver en familia',
                  style: TextStyle(
                    color: AppColors.dark,
                    fontSize: 16,
                    fontFamily: 'InclusiveSans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _AutoHeroBanner(
                movies: _familyMovies,
                key: const ValueKey('hero-familia'),
              ),

              const SizedBox(height: 20),

              // ── Sección: Opiniones (reviews reales desde la API) ────
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Opiniones',
                  style: TextStyle(
                    color: AppColors.dark,
                    fontSize: 16,
                    fontFamily: 'InclusiveSans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: movieProvider.movieReviews.isEmpty
                    ? const Text(
                        'No hay opiniones disponibles',
                        style: TextStyle(
                          color: AppColors.hint,
                          fontFamily: 'InclusiveSans',
                        ),
                      )
                    : Column(
                        children: movieProvider.movieReviews.take(3).map((mr) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _ReviewCard(movieReview: mr),
                          );
                        }).toList(),
                      ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// BANNER HERO AUTOMÁTICO
// Carrusel que cambia de película sola cada 4 segundos usando un
// PageView controlado por un Timer.periodic.
class _AutoHeroBanner extends StatefulWidget {
  final List<dynamic> movies;
  const _AutoHeroBanner({required this.movies, super.key});

  @override
  State<_AutoHeroBanner> createState() => _AutoHeroBannerState();
}

class _AutoHeroBannerState extends State<_AutoHeroBanner> {
  // Controlador del PageView: nos permite "ordenarle" que cambie de
  // página mediante código, sin que el usuario deslice con el dedo.
  late final PageController _pageController;

  // Timer que se repite cada 4 segundos.
  Timer? _timer;

  // Índice de la página/película actual que se está mostrando.
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSlide();
  }

  // Crea (o reinicia) el temporizador de 4 segundos.
  void _startAutoSlide() {
    _timer?.cancel(); // por seguridad, cancelamos cualquier timer previo
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (widget.movies.isEmpty) return; // nada que mostrar todavía

      // Calculamos cuál es la siguiente página. Si llegamos al final
      // de la lista, regresamos a 0 para que el ciclo sea infinito.
      final nextPage = (_currentPage + 1) % widget.movies.length;

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      
      setState(() => _currentPage = nextPage);
    });
  }

  @override
  void dispose() {
    // MUY IMPORTANTE: cancelar el Timer y el PageController al salir
    // de la pantalla, o seguirán corriendo en memoria (memory leak).
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   
    if (widget.movies.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          
         
          height: 180,
          decoration: BoxDecoration(
            color: const Color(0xFFB22222),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 180,
        child: PageView.builder(
          controller: _pageController,
          // El usuario también puede deslizar manualmente si quiere;
          // el Timer seguirá funcionando igual cada 4s desde ahí.
          itemCount: widget.movies.length,
          itemBuilder: (context, index) {
            final movie = widget.movies[index];
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFFB22222),
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.hardEdge,
              // usamos movie.backdropPath en vez de
              // movie.posterPath. El backdrop es la imagen
              // HORIZONTAL que TMDB da para cada película 
              child: movie != null && movie.backdropPath.isNotEmpty
                  ? Image.network(
                      movie.backdropPath,
                      // Con el backdrop horizontal
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (_, __, ___) => const SizedBox(),
                    )
                  : null,
            );
          },
        ),
      ),
    );
  }
}

// ── Chips de géneros con scroll horizontal 
class _GenreChipsRow extends StatelessWidget {
  final List<String> genres = const [
    'Terror',
    'Comedia',
    'Suspenso',
    'Romance',
    'Acción',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: genres.map((g) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _GenreChip(label: g),
          );
        }).toList(),
      ),
    );
  }
}

class _GenreChip extends StatelessWidget {
  final String label;
  const _GenreChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.buttonText,
          fontSize: 12,
          fontFamily: 'InclusiveSans',
        ),
      ),
    );
  }
}

//  Carrusel horizontal con datos reales + difuminado en bordes 
class _MovieCarousel extends StatelessWidget {
  final MovieProvider movieProvider;
  const _MovieCarousel({required this.movieProvider});

  @override
  Widget build(BuildContext context) {
    if (movieProvider.isLoading && movieProvider.movies.isEmpty) {
      return const SizedBox(
        height: 130,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (movieProvider.error != null && movieProvider.movies.isEmpty) {
      return SizedBox(
        height: 130,
        child: Center(
          child: Text(
            '${movieProvider.error}',
            style: const TextStyle(
              color: AppColors.hint,
              fontFamily: 'InclusiveSans',
            ),
          ),
        ),
      );
    }
    // difuminado en los bordes laterales del carrusel
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          Colors.white,
          Colors.white,
          Colors.transparent,
        ],
        stops: [0.0, 0.08, 0.92, 1.0],
      ).createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: SizedBox(
        height: 130,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: movieProvider.movies.length + 1,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            if (index == movieProvider.movies.length) {
              return Center(
                child: movieProvider.isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : GestureDetector(
                        onTap: () => movieProvider.loadNextPage(),
                        child: const Icon(
                          Icons.chevron_right,
                          color: AppColors.hint,
                          size: 22,
                        ),
                      ),
              );
            }
            final movie = movieProvider.movies[index];
            return _MovieCard(movie: movie);
          },
        ),
      ),
    );
  }
}

// ── Card individual de película (poster real) 
class _MovieCard extends StatelessWidget {
  final dynamic movie;
  const _MovieCard({this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.hardEdge,
      child: movie != null && movie.posterPath.isNotEmpty
          ? Image.network(
              movie.posterPath,
              // Mismo ajuste aquí
              fit: BoxFit.cover,
              alignment: Alignment
                  .topCenter, // prioriza mostrar la cara/título arriba del póster, en vez de recortar por el centro
              errorBuilder: (_, __, ___) => const SizedBox(),
            )
          : null,
    );
  }
}

// ── Card de opinión con datos reales de la API 
class _ReviewCard extends StatefulWidget {
  final MovieReview movieReview;
  const _ReviewCard({required this.movieReview});

  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final review = widget.movieReview.review;
    final starRating = review.rating != null ? (review.rating! / 2).round() : 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.hint, width: 1.5),
            ),
            child: const Icon(
              Icons.person_outline,
              color: AppColors.hint,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.movieReview.movieTitle,
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontSize: 13,
                    fontFamily: 'InclusiveSans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  review.author,
                  style: const TextStyle(
                    color: AppColors.hint,
                    fontSize: 11,
                    fontFamily: 'InclusiveSans',
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      i < starRating ? Icons.star : Icons.star_border,
                      color: AppColors.dark,
                      size: 14,
                    );
                  }),
                ),
                const SizedBox(height: 4),
                Text(
                  review.content,
                  maxLines: _isExpanded ? null : 2,
                  overflow: _isExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontSize: 12,
                    fontFamily: 'InclusiveSans',
                    height: 1.5,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Text(
                    _isExpanded ? 'Leer menos' : 'Leer más',
                    style: const TextStyle(
                      color: AppColors.dark,
                      fontSize: 12,
                      fontFamily: 'InclusiveSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
