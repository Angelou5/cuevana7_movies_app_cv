import 'package:flutter/material.dart';

class WideMovieCard extends StatefulWidget {
  final dynamic movie;
  // Callbacks para pausar/reanudar el carrusel automático desde afuera
  final VoidCallback? onShowDescription;
  final VoidCallback? onHideDescription;

  const WideMovieCard({
    super.key,
    this.movie,
    this.onShowDescription,
    this.onHideDescription,
  });

  @override
  State<WideMovieCard> createState() => _WideMovieCardState();
}

class _WideMovieCardState extends State<WideMovieCard> {
  bool _showDescription = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 48;
    final movie = widget.movie;

    return GestureDetector(
      onTap: () {
        if (_showDescription) {
          setState(() => _showDescription = false);
          // Reanuda el carrusel al cerrar tocando fuera
          widget.onHideDescription?.call();
        }
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: const Color(0xFF312F2D),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.hardEdge,
        child: movie == null
            ? null
            : Stack(
                fit: StackFit.expand,
                children: [
                  if (movie.backdropPath.isNotEmpty)
                    Image.network(
                      movie.backdropPath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox(),
                    ),
                  Container(
                    color: const Color(0xFF0F0F0F).withValues(alpha: 0.32),
                  ),

                  // ── Fondo oscuro al abrir descripción ────────────
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: _showDescription ? 1.0 : 0.0,
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.75),
                    ),
                  ),

                  // ── Panel de descripción completa con scroll ──────
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: _showDescription ? 1.0 : 0.0,
                    child: IgnorePointer(
                      ignoring: !_showDescription,
                      child: Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Text(
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
                                ),
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () {
                                  setState(() => _showDescription = false);
                                  widget.onHideDescription?.call();
                                },
                                child: Text(
                                  'Cerrar',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.70),
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
                    ),
                  ),

                  // ── Vista normal con título + "Ver más" ───────────
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: _showDescription ? 0.0 : 1.0,
                    child: IgnorePointer(
                      ignoring: _showDescription,
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
                                Colors.black.withValues(alpha: 0.88),
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
                                        fontSize: 24,
                                        fontFamily: 'InclusiveSans',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    if (movie.overview.isNotEmpty)
                                      Text(
                                        movie.overview,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'InclusiveSans',
                                          height: 1.4,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  setState(() => _showDescription = true);
                                  // Pausa el carrusel al abrir
                                  widget.onShowDescription?.call();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.55,
                                      ),
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
                ),
              ],
              ),
      ),
    );
  }
}
