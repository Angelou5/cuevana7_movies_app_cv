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
import 'package:cuevana7_movies_app_cv/presentation/widgets/app_snackbar.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/bottom_fade_mask.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/actor.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/cast_carousel.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/error_view.dart';
import 'package:cuevana7_movies_app_cv/shared/http_utils.dart';

class MovieDetailScreen extends StatefulWidget {
  static const String name = 'movie-detail';
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  static const double sectionSpacing = 28;

  late Future<List<Movie>> _similarFuture;
  late Future<List<Review>> _reviewsFuture;
  late Future<List<Actor>> _castFuture;

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
    _castFuture = repo.getMovieCast(movie.id);
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

                  const SizedBox(height: sectionSpacing),

                  // ── Reparto ──────────────────────────────────
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Reparto',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 24,
                        fontFamily: 'InclusiveSans',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Espacio entre título y carrusel
                  FutureBuilder<List<Actor>>(
                    future: _castFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return SizedBox(
                          height: 170,
                          child: ErrorView(
                            error: classifyError(snapshot.error!),
                          ),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const SizedBox(
                          height: 170,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                            ),
                          ),
                        );
                      }

                      return CastCarousel(cast: snapshot.data!);
                    },
                  ),
                  const SizedBox(height: sectionSpacing),

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
                  const SizedBox(height: 10), // Espacio entre título y carrusel
                  SizedBox(
                    height: 190,
                    child: FutureBuilder<List<Movie>>(
                      future: _similarFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return ErrorView(
                            error: classifyError(snapshot.error!),
                          );
                        }
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
                  const SizedBox(height: sectionSpacing),

                  // ── Reseñas de esta película ────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: FutureBuilder<List<Review>>(
                      future: _reviewsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: ErrorView(
                              error: RequestError(
                                type: ErrorType.unknown,
                                message: 'No se pudieron cargar las reseñas',
                              ),
                            ),
                          );
                        }
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
  static const double _actionIconSize = 44;
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
                              // Ícono de favorito conectado al MovieProvider:
                              // cambia de asset (outline/relleno) según el
                              // estado real guardado en el provider.
                              Consumer<MovieProvider>(
                                builder: (context, provider, _) {
                                  final isFav = provider.isFavorite(movie.id);
                                  return _ActionIcon(
                                    asset: isFav
                                        ? 'assets/images/favoritewhite.svg'
                                        : 'assets/images/favorite.svg',
                                    semanticLabel: isFav
                                        ? 'Quitar de favoritos'
                                        : 'Agregar a favoritos',
                                    onTap: () {
                                      final wasFavorite = provider.isFavorite(
                                        movie.id,
                                      );
                                      provider.toggleFavorite(movie);
                                      if (!wasFavorite) {
                                        showSuccessSnackBar(
                                          context,
                                          'Se ha agregado exitosamente',
                                        );
                                      }
                                    },
                                  );
                                },
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
/// [IntrinsicHeight].
///
/// IMPORTANTE: el [SvgPicture] fija [width]/[height] explícitos
/// ([iconSize]). Antes no los tenía (solo `fit: BoxFit.contain`), y como
/// `favorite.svg` (40x40) y `favoritewhite.svg` (64x64) declaran tamaños
/// intrínsecos distintos, `IntrinsicHeight` recalculaba un alto de fila
/// ligeramente distinto al cambiar de ícono — eso era lo que hacía que el
/// botón "cambiara" de forma al tocar favorito. Con un tamaño fijo, el
/// alto de la fila deja de depender del asset mostrado.
///
/// También agrega una animación al presionar (un pequeño "pop" hacia
/// adentro con [AnimatedScale]) y una transición de fundido/escala con
/// [AnimatedSwitcher] cuando cambia el asset (por ejemplo, al marcar o
/// desmarcar favorito).
class _ActionIcon extends StatefulWidget {
  final String asset;
  final String semanticLabel;
  final VoidCallback? onTap;
  final double iconSize;

  const _ActionIcon({
    super.key,
    required this.asset,
    required this.semanticLabel,
    this.onTap,
    this.iconSize = _HeaderState._actionIconSize,
  });

  @override
  State<_ActionIcon> createState() => _ActionIconState();
}

class _ActionIconState extends State<_ActionIcon>
    with SingleTickerProviderStateMixin {
  // Un AnimationController con un TweenSequence (1.0 → 0.75 → 1.0) es
  // determinista: sin importar cuántos rebuilds dispare el provider al
  // togglear favorito, el controller vive en este State y su animación
  // siempre arranca en 1.0 y termina en 1.0. Esto reemplaza el enfoque
  // anterior (un booleano `_pressed` + AnimatedScale), que dependía de que
  // onTapUp/onTapCancel llegaran antes del rebuild — y a veces no, dejando
  // el ícono "pegado" en su tamaño chico.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );

  late final Animation<double> _bounce = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(
        begin: 1.0,
        end: 0.72,
      ).chain(CurveTween(curve: Curves.easeOut)),
      weight: 35,
    ),
    TweenSequenceItem(
      tween: Tween(
        begin: 0.72,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeOutBack)),
      weight: 65,
    ),
  ]).animate(_controller);

  void _handleTap() {
    _controller.forward(from: 0);
    widget.onTap?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Semantics(
        button: true,
        label: widget.semanticLabel,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _handleTap,
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Center(
              child: AnimatedBuilder(
                animation: _bounce,
                builder: (context, child) =>
                    Transform.scale(scale: _bounce.value, child: child),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOutBack,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  child: SvgPicture.asset(
                    widget.asset,
                    key: ValueKey(widget.asset),
                    width: widget.iconSize,
                    height: widget.iconSize,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
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
