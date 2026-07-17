import 'package:flutter/material.dart';
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
import 'package:cuevana7_movies_app_cv/presentation/widgets/movie_detail_header.dart';

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
    _loadData();
  }

  void _loadData() {
    final repo = context.read<MovieProvider>().repository;
    final movie = widget.movie;

    final genreId = movie.genreIds.isNotEmpty
        ? int.tryParse(movie.genreIds.first)
        : null;
    setState(() {
      _similarFuture = genreId == null
          ? Future.value(<Movie>[])
          : repo
                .getByGenre(genreId)
                .then((list) => list.where((m) => m.id != movie.id).toList());
      _reviewsFuture = repo.getMovieReviews(movie.id);
      _castFuture = repo.getMovieCast(movie.id);
    });
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
            child: RefreshIndicator(
              color: AppColors.white,
              backgroundColor: Colors.transparent,
              onRefresh: () async {
                _loadData();
                await Future.wait([
                  _similarFuture,
                  _reviewsFuture,
                  _castFuture,
                ]);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<MovieProvider>(
                      builder: (context, provider, _) {
                        final isFav = provider.isFavorite(movie.id);
                        return MovieDetailHeader(
                          movie: movie,
                          rating: rating,
                          isFavorite: isFav,
                          onFavoriteToggle: () {
                            final wasFavorite =
                                provider.isFavorite(movie.id);
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
                    const SizedBox(height: 10),
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
                                Icon(
                                  Icons.chevron_right,
                                  color: AppColors.white,
                                ),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24),
                            scrollDirection: Axis.horizontal,
                            itemCount: similar.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 10),
                            itemBuilder: (_, i) =>
                                MovieCard(movie: similar[i]),
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
                                  message:
                                      'No se pudieron cargar las reseñas',
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
                                    padding: const EdgeInsets.only(
                                      bottom: 12,
                                    ),
                                    child: ReviewCard(
                                      movieReview: MovieReview(
                                        r,
                                        movie.title,
                                      ),
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
      ),
    );
  }
}
