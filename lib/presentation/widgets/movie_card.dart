import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/movie_provider.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/app_snackbar.dart';

class MovieCard extends StatelessWidget {
  final dynamic movie;
  const MovieCard({super.key, this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: movie == null
          ? null
          : () => context.push('/movie/${movie.id}', extra: movie),
      child: Container(
        width: 145,
        decoration: BoxDecoration(
          color: const Color(0xFF262524),
          borderRadius: BorderRadius.circular(10),
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
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            const Color(0xFF262524).withValues(alpha: 0.85),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Text(
                        movie.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: 'InclusiveSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: _FavoriteButton(movieId: movie.id, movie: movie),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Botón de favorito superpuesto en la esquina superior derecha del
/// poster. Usa [Consumer] (en vez de [context.watch] a nivel de todo
/// [MovieCard]) para que solo este pequeño botón se reconstruya al
/// marcar/desmarcar favorito, sin repintar el poster completo.
///
/// Incluye una animación al presionar ([AnimatedScale], un pequeño "pop"
/// hacia adentro) y una transición de fundido/escala ([AnimatedSwitcher])
/// al cambiar entre el ícono de contorno y el relleno.
class _FavoriteButton extends StatefulWidget {
  final int movieId;
  final dynamic movie;
  const _FavoriteButton({required this.movieId, required this.movie});

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton>
    with SingleTickerProviderStateMixin {
  // Mismo patrón que en el ícono de favorito de movie_detail_screen:
  // un AnimationController con TweenSequence (1.0 → 0.72 → 1.0) que
  // siempre termina en 1.0, sin depender de un booleano que se podía
  // desincronizar con el rebuild que dispara el cambio de favorito.
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

  void _handleTap(MovieProvider provider) {
    _controller.forward(from: 0);
    final wasFavorite = provider.isFavorite(widget.movieId);
    provider.toggleFavorite(widget.movie);
    if (!wasFavorite) {
      showSuccessSnackBar(context, 'Se ha agregado exitosamente');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, provider, _) {
        final isFav = provider.isFavorite(widget.movieId);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _handleTap(provider),
          child: Padding(
            // Zona de toque cómoda sin agregar ningún fondo visible.
            padding: const EdgeInsets.all(6),
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
                  isFav
                      ? 'assets/images/favoritewhite.svg'
                      : 'assets/images/favorite.svg',
                  key: ValueKey(isFav),
                  width: 26,
                  height: 26,
                  colorFilter: const ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
