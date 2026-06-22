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

  List<dynamic> get _filteredMovies {
    final movies = context.read<MovieProvider>().movies;
    if (_searchQuery.isEmpty) return movies;
    return movies
        .where((m) => m.title.toLowerCase().contains(_searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ───────────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 8),
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

                    // ── Logo + Buscador ──────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Hero(
                            tag: 'app-logo',
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 36,
                              height: 36,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.inputFill,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: TextField(
                                controller: _searchController,
                                style: const TextStyle(
                                  color: AppColors.dark,
                                  fontSize: 16,
                                  fontFamily: 'InclusiveSans',
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Buscar',
                                  hintStyle: TextStyle(
                                    color: AppColors.hint,
                                    fontSize: 16,
                                    fontFamily: 'InclusiveSans',
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: AppColors.hint,
                                    size: 20,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value.toLowerCase();
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── CARRUSEL ANCHO (featured) ────────────────────────────
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 220,
                      child:
                          movieProvider.isLoading &&
                              movieProvider.movies.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: _filteredMovies.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) =>
                                  _WideMovieCard(movie: _filteredMovies[index]),
                            ),
                    ),

                    // ── Novedades ────────────────────────────────────────────
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Novedades',
                            style: TextStyle(
                              color: AppColors.dark,
                              fontSize: 18,
                              fontFamily: 'InclusiveSans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                context.read<MovieProvider>().loadNextPage(),
                            child: const Text(
                              'Ver más',
                              style: TextStyle(
                                color: AppColors.hint,
                                fontSize: 13,
                                fontFamily: 'InclusiveSans',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        height: 140,
                        child:
                            movieProvider.isLoading &&
                                movieProvider.movies.isEmpty
                            ? const Center(child: CircularProgressIndicator())
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
                                              child: CircularProgressIndicator(
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
                                  final movie = _filteredMovies[index];
                                  return _MovieCard(movie: movie);
                                },
                              ),
                      ),
                    ),

                    // ── Secciones por género ─────────────────────────────────
                    const SizedBox(height: 24),
                    _GenreSection(
                      title: 'Comedia',
                      movies: movieProvider.moviesComedia,
                    ),
                    const SizedBox(height: 24),
                    _GenreSection(
                      title: 'Terror',
                      movies: movieProvider.moviesTerror,
                    ),
                    const SizedBox(height: 24),
                    _GenreSection(
                      title: 'Acción',
                      movies: movieProvider.moviesAccion,
                    ),
                    const SizedBox(height: 24),
                    _GenreSection(
                      title: 'Suspenso',
                      movies: movieProvider.moviesSuspenso,
                    ),

                    // ── CARRUSEL ANCHO: Para ver en familia ──────────────────
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Para ver en familia',
                        style: TextStyle(
                          color: AppColors.dark,
                          fontSize: 18,
                          fontFamily: 'InclusiveSans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 220,
                      child: movieProvider.moviesFamilia.isEmpty
                          ? const Center(
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: movieProvider.moviesFamilia.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) => _WideMovieCard(
                                movie: movieProvider.moviesFamilia[index],
                              ),
                            ),
                    ),

                    // ── Opiniones ────────────────────────────────────────────
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Opiniones',
                        style: TextStyle(
                          color: AppColors.dark,
                          fontSize: 18,
                          fontFamily: 'InclusiveSans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                              children: movieProvider.movieReviews.take(4).map((
                                mr,
                              ) {
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

            // ── Bottom Nav ────────────────────────────────────────────────
            Container(
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
                  Icon(
                    Icons.bookmark_border,
                    color: AppColors.buttonText,
                    size: 26,
                  ),
                  Icon(
                    Icons.favorite_border,
                    color: AppColors.buttonText,
                    size: 26,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── _WideMovieCard ─────────────────────────────────────────────────────────────
class _WideMovieCard extends StatefulWidget {
  final dynamic movie;
  const _WideMovieCard({this.movie});

  @override
  State<_WideMovieCard> createState() => _WideMovieCardState();
}

class _WideMovieCardState extends State<_WideMovieCard> {
  bool _showDescription = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 48;
    final movie = widget.movie;

    return GestureDetector(
      onTap: () {
        if (_showDescription) {
          setState(() => _showDescription = false);
        }
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.hardEdge,
        child: movie == null
            ? null
            : Stack(
                fit: StackFit.expand,
                children: [
                  // ── Imagen de fondo ──────────────────────────────────────
                  if (movie.backdropPath.isNotEmpty)
                    Image.network(
                      movie.backdropPath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox(),
                    ),

                  // ── Overlay oscuro al expandir ───────────────────────────
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: _showDescription ? 1.0 : 0.0,
                    child: Container(color: Colors.black.withOpacity(0.75)),
                  ),

                  // ── Descripción completa (visible al expandir) ───────────
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: _showDescription ? 1.0 : 0.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            movie.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'InclusiveSans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            movie.overview.isNotEmpty
                                ? movie.overview
                                : 'Sin descripción disponible.',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'InclusiveSans',
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () =>
                                setState(() => _showDescription = false),
                            child: Text(
                              'Cerrar',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.70),
                                fontSize: 12,
                                fontFamily: 'InclusiveSans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Barra inferior con título y botón (estado normal) ────
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: _showDescription ? 0.0 : 1.0,
                    child: Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.88),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      movie.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: 'InclusiveSans',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    if (movie.overview.isNotEmpty)
                                      Text(
                                        movie.overview,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.80),
                                          fontSize: 11,
                                          fontFamily: 'InclusiveSans',
                                          height: 1.4,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _showDescription = true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.55),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Text(
                                    'Ver más',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: 'InclusiveSans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ── _MovieCard ─────────────────────────────────────────────────────────────────
class _MovieCard extends StatelessWidget {
  final dynamic movie;
  const _MovieCard({this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.hardEdge,
      child: movie == null
          ? null
          : Stack(
              fit: StackFit.expand,
              children: [
                if (movie.posterPath.isNotEmpty)
                  Image.network(
                    movie.posterPath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.85),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: 'InclusiveSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

// ── _ReviewCard ────────────────────────────────────────────────────────────────
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
                  overflow: _isExpanded ? null : TextOverflow.ellipsis,
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

// ── _GenreSection ──────────────────────────────────────────────────────────────
class _GenreSection extends StatelessWidget {
  final String title;
  final List<dynamic> movies;
  const _GenreSection({required this.title, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.dark,
              fontSize: 18,
              fontFamily: 'InclusiveSans',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 140,
          child: movies.isEmpty
              ? const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) =>
                      _MovieCard(movie: movies[index]),
                ),
        ),
      ],
    );
  }
}
