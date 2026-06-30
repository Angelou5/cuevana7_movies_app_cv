import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final dynamic movie;
  const MovieCard({super.key, this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              ],
            ),
    );
  }
}
