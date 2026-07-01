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
<<<<<<< HEAD
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // [TAREA: Menú desplegable de perfil] — controla visibilidad del dropdown
  bool _showProfileMenu = false;
=======
  final _movieDbDatasource = MovieDbDatasource();
  List<Movie> _familyMovies = [];
>>>>>>> a0b82e6266a8196b782ef9360c00194ab10409c6

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieProvider>().loadNowPlaying();
    });
  }
  @override
<<<<<<< HEAD
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

  Widget _posterPlaceholder() => Container(
    width: 50,
    height: 70,
    decoration: BoxDecoration(
      color: AppColors.inputFill,
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.movie, color: AppColors.hint),
  );

<<<<<<< HEAD
=======
  // [TAREA: Menú desplegable de perfil] — dialog de confirmación al cerrar sesión
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

>>>>>>> fb411c076ef30900fea8644d52732bcc88449d84
  @override
=======
>>>>>>> a0b82e6266a8196b782ef9360c00194ab10409c6
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();

    return Scaffold(
<<<<<<< HEAD
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
<<<<<<< HEAD
                    // ── Header ─────────────────────────────────────────
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

                    // ── Logo + Buscador ─────────────────────────────────
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
=======
      body: Stack(
        children: [
          // ── Contenido principal (original sin cambios) ─────────────────
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
                  // ── Buscador + Avatar ────────────────────────
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
>>>>>>> fb411c076ef30900fea8644d52732bcc88449d84
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
<<<<<<< HEAD
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value.toLowerCase();
                                  });
                                  context.read<MovieProvider>().onSearchChanged(
                                    value,
                                  );
                                },
                                onTapOutside: (_) {
                                  FocusScope.of(context).unfocus();
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                  context.read<MovieProvider>().clearSearch();
                                },
=======
>>>>>>> fb411c076ef30900fea8644d52732bcc88449d84
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value.toLowerCase();
                                });
                                context
                                    .read<MovieProvider>()
                                    .onSearchChanged(value);
                              },
                              onTapOutside: (_) {
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
<<<<<<< HEAD
                        ],
                      ),
                    ),

                    // ── Resultados de búsqueda ──────────────────────────
                    if (_searchQuery.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Resultados',
                          style: TextStyle(
                            color: AppColors.dark,
                            fontSize: 18,
                            fontFamily: 'InclusiveSans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Consumer<MovieProvider>(
                        builder: (context, mp, _) {
                          if (mp.isSearching) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Center(
                                child: CircularProgressIndicator(
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
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: mp.searchResults.map((movie) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
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
                                                color: AppColors.dark,
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
                                                    fontFamily: 'InclusiveSans',
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

                      // ── Contenido normal ────────────────────────────────
                    ] else ...[
                      // ── CARRUSEL ANCHO (featured) ─────────────────────
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: const Text(
                          'Próximos estrenos',
                          style: TextStyle(
                            color: AppColors.dark,
                            fontSize: 18,
                            fontFamily: 'InclusiveSans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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
                                itemBuilder: (context, index) => _WideMovieCard(
                                  movie: _filteredMovies[index],
                                ),
                              ),
                      ),

                      // ── Novedades ─────────────────────────────────────
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
                                '',
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
                      SizedBox(
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
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
                                  return _MovieCard(
                                    movie: _filteredMovies[index],
                                  );
                                },
                              ),
                      ),

                      // ── Secciones por género ──────────────────────────
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

                      // ── Para ver en familia ───────────────────────────
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

                      // ── Opiniones ─────────────────────────────────────
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
                                children: movieProvider.movieReviews
                                    .take(10)
                                    .map((mr) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: _ReviewCard(movieReview: mr),
                                      );
                                    })
                                    .toList(),
                              ),
                      ),
                      const SizedBox(height: 24),
                    ],
=======
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
>>>>>>> a0b82e6266a8196b782ef9360c00194ab10409c6
                  ],
=======
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
                            // [TAREA: Desvanecido izquierdo carruseles] — carrusel destacado con fade
                            _LeftFadedCarousel(
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

                            // [TAREA: Desvanecido carruseles] — géneros con fade en ambos lados
                            const SizedBox(height: 24),
                            _FadedGenreSection(
                              title: 'Películas familiares',
                              movies: movieProvider.moviesFamilia,
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
                        ],
                      ),
                    ),
                  ),

                  // ── Navbar flotante compartida ───────────────────────
                  BottomNavBar(
                    activeTab: NavTab.home,
                    isVisible: true,
                  ),
                ],
              ),
            ),
          ),

          // [TAREA: Menú desplegable de perfil] — tap fuera cierra el dropdown
          if (_showProfileMenu)
            GestureDetector(
              onTap: () => setState(() => _showProfileMenu = false),
              child: Container(color: Colors.transparent),
            ),

          // [TAREA: Menú desplegable de perfil] — panel del dropdown posicionado bajo el avatar
          if (_showProfileMenu)
            Positioned(
              top: MediaQuery.of(context).padding.top + 88,
              right: 24,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  // [TAREA: Fix overflow] — ancho aumentado de 260 a 290 para que
                  // "Lista de reproducción" no desborde
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
>>>>>>> fb411c076ef30900fea8644d52732bcc88449d84
                ),
              ),
            ),
        ],
      ),
    );
  }
}

<<<<<<< HEAD
<<<<<<< HEAD
            // ── Bottom Nav ────────────────────────────────────────────
            Container(
              decoration: const BoxDecoration(
                color: AppColors.dark,
                border: Border(
                  top: BorderSide(color: AppColors.inputFill, width: 0.5),
=======
// [TAREA: Desvanecido carruseles] — igual que GenreSection pero con fade
// en ambos lados del carrusel. El título queda fuera del ShaderMask.
class _FadedGenreSection extends StatelessWidget {
  final String title;
=======
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
>>>>>>> a0b82e6266a8196b782ef9360c00194ab10409c6
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
                  itemCount: movies.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) =>
                      MovieCard(movie: movies[index]),
>>>>>>> fb411c076ef30900fea8644d52732bcc88449d84
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

// [TAREA: Menú desplegable de perfil] — ítem individual del dropdown
// fontSize reducido a 14 para evitar overflow en textos largos
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
                // [TAREA: Fix overflow] — reducido de 16 a 14 para evitar desborde
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
<<<<<<< HEAD

<<<<<<< HEAD
// ── _WideMovieCard ─────────────────────────────────────────────────────────────
class _WideMovieCard extends StatefulWidget {
  final dynamic movie;
  const _WideMovieCard({this.movie});

  @override
  State<_WideMovieCard> createState() => _WideMovieCardState();
}

class _WideMovieCardState extends State<_WideMovieCard> {
  bool _showDescription = false;
=======
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
>>>>>>> a0b82e6266a8196b782ef9360c00194ab10409c6

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

<<<<<<< HEAD
// ── _MovieCard ─────────────────────────────────────────────────────────────────
=======
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
>>>>>>> a0b82e6266a8196b782ef9360c00194ab10409c6
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
<<<<<<< HEAD
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
=======
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
>>>>>>> a0b82e6266a8196b782ef9360c00194ab10409c6
    );
  }
}

<<<<<<< HEAD
// ── _ReviewCard ────────────────────────────────────────────────────────────────
=======
// ── Card de opinión con datos reales de la API 
>>>>>>> a0b82e6266a8196b782ef9360c00194ab10409c6
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
<<<<<<< HEAD

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
=======
>>>>>>> fb411c076ef30900fea8644d52732bcc88449d84
=======
>>>>>>> a0b82e6266a8196b782ef9360c00194ab10409c6
