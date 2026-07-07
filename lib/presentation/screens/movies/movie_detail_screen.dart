import 'dart:ui'; // para ImageFilter (blur)
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/movie.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/review.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/movie_provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/movie_card.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/review_card.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/bottom_fade_mask.dart';

class MovieDetailScreen extends StatefulWidget {
  static const String name = 'movie-detail';
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<List<Movie>> _similarFuture;
  late Future<List<Review>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    final repo = context.read<MovieProvider>().repository;
    final movie = widget.movie;

    // "Géneros similares" -> pelis del primer género de esta película
    final genreId = movie.genreIds.isNotEmpty
        ? int.tryParse(movie.genreIds.first)
        : null;
    _similarFuture = genreId == null
        ? Future.value(<Movie>[])
        : repo
              .getByGenre(genreId)
              .then((list) => list.where((m) => m.id != movie.id).toList());

    _reviewsFuture = repo.getMovieReviews(movie.id);
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final rating = (movie.voteAverage).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.20, 1.0],
            colors: [AppColors.background, AppColors.dark],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: BottomFadeMask(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(movie: movie, rating: rating),
                  const SizedBox(height: 24),

                  // ── Géneros similares ──────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Géneros similares',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 24,
                            fontFamily: 'InclusiveSans',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // TODO: navegar a listado completo del género
                          },
                          child: const Row(
                            children: [
                              Text(
                                'Ver más',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              Icon(Icons.chevron_right, color: AppColors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 190,
                    child: FutureBuilder<List<Movie>>(
                      future: _similarFuture,
                      builder: (context, snapshot) {
                        final similar = snapshot.data ?? [];
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                              strokeWidth: 2,
                            ),
                          );
                        }
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          scrollDirection: Axis.horizontal,
                          itemCount: similar.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (_, i) => MovieCard(movie: similar[i]),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Reseñas de esta película ────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: FutureBuilder<List<Review>>(
                      future: _reviewsFuture,
                      builder: (context, snapshot) {
                        final reviews = snapshot.data ?? [];
                        if (!snapshot.hasData) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        }
                        if (reviews.isEmpty) {
                          return const SizedBox();
                        }
                        return Column(
                          children: reviews
                              .map(
                                (r) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: ReviewCard(
                                    movieReview: MovieReview(r, movie.title),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatefulWidget {
  final Movie movie;
  final String rating;
  const _Header({required this.movie, required this.rating});

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  bool _isExpanded = false;

  // Alto inicial estimado, mientras se mide el real tras el primer frame.
  double _panelHeight = 230;

  static const int _overviewCollapsedThreshold = 140;
  static const double _backdropHeight = 460;
  static const double _panelOverlap = 80;
  static const double _actionIconSize = 38;

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final year = movie.releaseDate.year;
    final certification = movie.adult ? 'R' : 'PG';
    final meta = '$year · $certification';
    final overviewIsLong = movie.overview.length > _overviewCollapsedThreshold;

    final totalHeight = _backdropHeight - _panelOverlap + _panelHeight;

    return AnimatedContainer(
      // Anima suavemente el alto total cuando el panel cambia de tamaño
      // (ej. al expandir "Ver más").
      duration: const Duration(milliseconds: 200),
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Backdrop ────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: _backdropHeight,
            child: movie.backdropPath.isNotEmpty
                ? Image.network(
                    movie.backdropPath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: const Color(0xFF262524)),
                  )
                : Container(color: const Color(0xFF262524)),
          ),

          // ── Botón de regreso ─────────────────────────────────
          Positioned(
            top: 12,
            left: 16,
            child: SafeArea(
              bottom: false,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.pop(),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),

          // ── Panel flotante con blur, medido dinámicamente ────
          Positioned(
            top: _backdropHeight - _panelOverlap,
            left: 16,
            right: 16,
            child: _MeasureSize(
              onChange: (size) {
                if ((size.height - _panelHeight).abs() > 0.5) {
                  setState(() => _panelHeight = size.height);
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 24,
                            fontFamily: 'InclusiveSans',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xFFF0BB58),
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.rating,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 18,
                                fontFamily: 'InclusiveSans',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          meta,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                            fontFamily: 'InclusiveSans',
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ── Overview expandible ─────────────────
                        Text(
                          movie.overview,
                          maxLines: _isExpanded ? null : 4,
                          overflow: _isExpanded ? null : TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontFamily: 'InclusiveSans',
                            height: 1.4,
                          ),
                        ),
                        if (overviewIsLong)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () =>
                                  setState(() => _isExpanded = !_isExpanded),
                              child: Text(
                                _isExpanded ? 'Ver menos' : 'Ver más',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.75),
                                  fontSize: 13,
                                  fontFamily: 'InclusiveSans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(height: 16),

                        // ── Acciones: trailer + favorito + comentarios ──
                        // IntrinsicHeight + stretch mide el alto real del
                        // botón "Reproducir trailer" y lo propaga a los
                        // íconos, sin tocar el diseño original del botón.
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Reproducir trailer',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'InclusiveSans',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // TODO: conectar con lógica real de favoritos
                              _ActionIcon(
                                asset: 'assets/images/favorite.svg',
                                semanticLabel: 'Agregar a favoritos',
                              ),
                              const SizedBox(width: 8),
                              // TODO: conectar con pantalla/sección de comentarios
                              _ActionIcon(
                                asset: 'assets/images/comment.svg',
                                semanticLabel: 'Ver comentarios',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Ícono de acción del header (favorito, comentarios, etc).
///
/// Se envuelve en [AspectRatio] cuadrado para que su bounding box mida
/// exactamente el alto real del botón "Reproducir trailer" cuando ambos
/// están dentro de un [Row] con [CrossAxisAlignment.stretch] envuelto en
/// [IntrinsicHeight]. Esto hace que los íconos "sigan" al botón en tamaño
/// sin necesidad de fijar un alto a mano, y sin cambiar el estilo visual
/// original (el SVG se sigue dibujando a [iconSize], solo centrado dentro
/// de esa caja).
/// También agrega [Semantics] para accesibilidad y una zona táctil real
/// vía [GestureDetector], ya que un ícono suelto no era tappeable de forma
/// consistente.
class _ActionIcon extends StatelessWidget {
  final String asset;
  final String semanticLabel;
  final VoidCallback? onTap;

  const _ActionIcon({
    super.key,
    required this.asset,
    required this.semanticLabel,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Semantics(
        button: true,
        label: semanticLabel,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: SvgPicture.asset(
              asset,
              fit: BoxFit.contain,
              colorFilter: const ColorFilter.mode(
                AppColors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget utilitario: mide el tamaño real de su hijo después de pintarlo
/// y notifica el cambio. Útil para layouts donde un elemento debe
/// superponerse a otro sin saber de antemano su alto exacto.
class _MeasureSize extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onChange;
  const _MeasureSize({required this.onChange, required this.child});

  @override
  State<_MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<_MeasureSize> {
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final size = (context.findRenderObject() as RenderBox?)?.size;
      if (size != null && size != _oldSize) {
        _oldSize = size;
        widget.onChange(size);
      }
    });
    return widget.child;
  }
}
