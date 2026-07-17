import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/movie.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/action_icon.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/measure_size.dart';

/// Header de la pantalla de detalle de película: imagen de fondo borrosa,
/// título, rating, sinopsis expandible y botones de acción.
class MovieDetailHeader extends StatefulWidget {
  final Movie movie;
  final String rating;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback? onPlayTrailer;

  const MovieDetailHeader({
    super.key,
    required this.movie,
    required this.rating,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.onPlayTrailer,
  });

  @override
  State<MovieDetailHeader> createState() => _MovieDetailHeaderState();
}

class _MovieDetailHeaderState extends State<MovieDetailHeader> {
  bool _isExpanded = false;
  double _panelHeight = 230;

  static const int _overviewCollapsedThreshold = 140;
  static const double _backdropHeight = 460;
  static const double _panelOverlap = 80;

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final year = movie.releaseDate.year;
    final certification = movie.adult ? 'R' : 'PG';
    final meta = '$year · $certification';
    final overviewIsLong = movie.overview.length > _overviewCollapsedThreshold;
    final totalHeight = _backdropHeight - _panelOverlap + _panelHeight;

    return AnimatedContainer(
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

          // ── Panel flotante con blur ──────────────────────────
          Positioned(
            top: _backdropHeight - _panelOverlap,
            left: 16,
            right: 16,
            child: MeasureSize(
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
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: widget.onPlayTrailer,
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
                              ),
                              const SizedBox(width: 8),
                              ActionIcon(
                                asset: widget.isFavorite
                                    ? 'assets/images/favoritewhite.svg'
                                    : 'assets/images/favorite.svg',
                                semanticLabel: widget.isFavorite
                                    ? 'Quitar de favoritos'
                                    : 'Agregar a favoritos',
                                onTap: widget.onFavoriteToggle,
                              ),
                              const SizedBox(width: 8),
                              ActionIcon(
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
