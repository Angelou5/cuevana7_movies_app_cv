import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieProvider>().loadNowPlaying();
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,

      // ── Bottom Navigation Bar fijo abajo ─────────────────────────
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
              // ── Título "Home" + botón logout ───────────────────────
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

              // ── Barra de búsqueda + logo ────────────────────────────
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
                        child: const Row(
                          children: [
                            SizedBox(width: 14),
                            Icon(Icons.search, color: AppColors.hint, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Buscar',
                              style: TextStyle(
                                color: AppColors.hint,
                                fontSize: 16,
                                fontFamily: 'InclusiveSans',
                              ),
                            ),
                          ],
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

              // ── Banner hero principal ───────────────────────────────
              _HeroBanner(
                movie: movieProvider.movies.isNotEmpty
                    ? movieProvider.movies.first
                    : null,
              ),

              const SizedBox(height: 16),

              // ── Sección: Géneros populares ──────────────────────────
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

              // ── Sección: Para ver en familia (banner) ───────────────
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
              _HeroBanner(
                movie: movieProvider.movies.length > 1
                    ? movieProvider.movies[1]
                    : null,
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

// ── Banner hero con película real o placeholder rojo ──────────────
class _HeroBanner extends StatelessWidget {
  final dynamic movie;
  const _HeroBanner({this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: const Color(0xFFB22222),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.hardEdge,
        child: movie != null && movie.posterPath.isNotEmpty
            ? Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, __, ___) => const SizedBox(),
              )
            : null,
      ),
    );
  }
}

// ── Chips de géneros con scroll horizontal ──────────────────────────
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

// ── Carrusel horizontal con datos reales + difuminado en bordes ────
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
    // difuminado
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

// ── Card individual de película (poster real) ──────────────────────
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
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(),
            )
          : null,
    );
  }
}

// ── Card de opinión con datos reales de la API ──────────────────────
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
