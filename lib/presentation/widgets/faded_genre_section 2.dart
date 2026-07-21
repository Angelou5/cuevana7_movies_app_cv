import 'package:flutter/material.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/movie_card.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/error_view.dart';

/// Sección de género con carrusel horizontal, paginación y fade en los bordes.
class FadedGenreSection extends StatelessWidget {
  final String title;
  final List<dynamic> movies;
  final VoidCallback? onLoadMore;
  final bool isLoading;
  final dynamic error;
  final VoidCallback? onRetry;

  const FadedGenreSection({
    super.key,
    required this.title,
    required this.movies,
    this.onLoadMore,
    this.isLoading = false,
    this.error,
    this.onRetry,
  });

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
        SizedBox(
          height: 190,
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
            child: movies.isEmpty && error != null
                ? ErrorView(error: error, onRetry: onRetry)
                : movies.isEmpty
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
                    itemCount: movies.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      if (index == movies.length) {
                        return Center(
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: AppColors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: onLoadMore,
                                  child: const Icon(
                                    Icons.chevron_right,
                                    color: AppColors.hint,
                                    size: 22,
                                  ),
                                ),
                        );
                      }
                      return MovieCard(movie: movies[index]);
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
