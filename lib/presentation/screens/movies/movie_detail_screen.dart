import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/movie.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/review.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/movie_provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/user_reviews_provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/movie_card.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/review_card.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/app_snackbar.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/bottom_fade_mask.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/actor.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/movie_image.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/cast_carousel.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/movie_gallery.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/error_view.dart';
import 'package:cuevana7_movies_app_cv/shared/http_utils.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/movie_detail_header.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/user_review_card.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/review_form.dart';
import 'package:cuevana7_movies_app_cv/presentation/widgets/trailer_player.dart';

class MovieDetailScreen extends StatefulWidget {
  static const String name = 'movie-detail';
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  static const double sectionSpacing = 24;

  late Future<List<Movie>> _similarFuture;
  late Future<List<Actor>> _castFuture;
  late Future<List<Review>> _tmdbReviewsFuture;
  late Future<List<MovieImage>> _galleryFuture;
  bool _showAllCast = false;
  bool _showAllSimilar = false;
  bool _showAllTmdbReviews = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    // Cargar la reseña del usuario para esta película
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserReviewsProvider>().loadMyReview(widget.movie.id);
      context.read<MovieProvider>().loadTrailer(widget.movie.id);
    });
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
      _castFuture = repo.getMovieCast(movie.id);
      _galleryFuture = repo.getMovieImages(movie.id);
      _tmdbReviewsFuture = context
          .read<MovieProvider>()
          .getMovieReviewsForMovie(movie.id);
    });
  }

  void _openReviewForm({String? initialContent, int? initialRating}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReviewForm(
        initialContent: initialContent,
        initialRating: initialRating,
        submitLabel: initialContent != null
            ? 'Actualizar reseña'
            : 'Publicar reseña',
        onSubmit: (content, rating) async {
          final provider = context.read<UserReviewsProvider>();
          final review = provider.myReview;
          if (review != null) {
            return provider.updateReview(review.id, content, rating);
          } else {
            return provider.createReview(widget.movie.id, content, rating);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final rating = (movie.voteAverage).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(color: AppColors.background),
        child: SafeArea(
          bottom: false,
          child: BottomFadeMask(
            fadeHeightFraction: 0.06,
            child: RefreshIndicator(
              color: AppColors.white,
              backgroundColor: Colors.transparent,
              onRefresh: () async {
                _loadData();
                context.read<UserReviewsProvider>().loadMyReview(movie.id);
                await Future.wait([
                  _similarFuture,
                  _castFuture,
                  _galleryFuture,
                  _tmdbReviewsFuture,
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
                            final wasFavorite = provider.isFavorite(movie.id);
                            provider.toggleFavorite(movie);
                            if (!wasFavorite) {
                              showSuccessSnackBar(
                                context,
                                'Se ha agregado exitosamente',
                              );
                            }
                          },
                          onPlayTrailer: provider.trailerKey != null
                              ? () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => TrailerPlayer(
                                      videoId: provider.trailerKey!,
                                    ),
                                  );
                                }
                              : null,
                          isLoadingTrailer: provider.isLoadingTrailer,
                          onWriteReview: () => _openReviewForm(),
                        );
                      },
                    ),

                    const SizedBox(height: sectionSpacing),

                    // ── Galería ──────────────────────────────────
                    FutureBuilder<List<MovieImage>>(
                      future: _galleryFuture,
                      builder: (context, snapshot) {
                        // Si no hay imágenes (o falló la carga), no
                        // mostramos la sección en vez de dejar un
                        // espacio vacío o un error poco relevante.
                        if (snapshot.hasError) return const SizedBox.shrink();
                        if (snapshot.hasData && snapshot.data!.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                'Galería',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 24,
                                  fontFamily: 'InclusiveSans',
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (!snapshot.hasData)
                              const SizedBox(
                                height: 200,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            else
                              MovieGallery(images: snapshot.data!),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: sectionSpacing),

                    // ── Reparto ──────────────────────────────────
                    FutureBuilder<List<Actor>>(
                      future: _castFuture,
                      builder: (context, snapshot) {
                        final cast = snapshot.data;
                        final hasMore =
                            cast != null && !_showAllCast && cast.length > 5;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Reparto',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 24,
                                      fontFamily: 'InclusiveSans',
                                    ),
                                  ),
                                  if (hasMore)
                                    GestureDetector(
                                      onTap: () =>
                                          setState(() => _showAllCast = true),
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
                            if (snapshot.hasError)
                              SizedBox(
                                height: 170,
                                child: ErrorView(
                                  error: classifyError(snapshot.error!),
                                ),
                              )
                            else if (!snapshot.hasData)
                              const SizedBox(
                                height: 170,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.white,
                                  ),
                                ),
                              )
                            else
                              CastCarousel(cast: cast!, showAll: _showAllCast),
                          ],
                        );
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
                          if (!_showAllSimilar)
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _showAllSimilar = true),
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
                          final displayCount = _showAllSimilar
                              ? similar.length
                              : (similar.length > 5 ? 5 : similar.length);
                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            scrollDirection: Axis.horizontal,
                            itemCount: displayCount,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 10),
                            itemBuilder: (_, i) => MovieCard(movie: similar[i]),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: sectionSpacing),

                    // ── Mi reseña (solo si existe) ────────────────
                    Consumer<UserReviewsProvider>(
                      builder: (context, reviewsProvider, _) {
                        final myReview = reviewsProvider.myReview;
                        if (myReview == null) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: UserReviewCard(
                            review: myReview,
                            onEdit: () => _openReviewForm(
                              initialContent: myReview.content,
                              initialRating: myReview.rating,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: sectionSpacing),

                    // ── Reseñas de la comunidad ────────────────────
                    FutureBuilder<List<Review>>(
                      future: _tmdbReviewsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) return const SizedBox.shrink();
                        if (!snapshot.hasData) return const SizedBox.shrink();
                        final reviews = snapshot.data!;
                        if (reviews.isEmpty) return const SizedBox.shrink();

                        final displayCount = _showAllTmdbReviews
                            ? reviews.length
                            : (reviews.length > 5 ? 5 : reviews.length);

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Reseñas de la comunidad',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 24,
                                      fontFamily: 'InclusiveSans',
                                    ),
                                  ),
                                  if (reviews.length > 5 &&
                                      !_showAllTmdbReviews)
                                    GestureDetector(
                                      onTap: () => setState(
                                        () => _showAllTmdbReviews = true,
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Ver más',
                                            style: TextStyle(
                                              color: AppColors.hint,
                                              fontSize: 14,
                                              fontFamily: 'Montserrat',
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            color: AppColors.hint,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: displayCount,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (_, i) => ReviewCard(
                                  movieReview: MovieReview(
                                    reviews[i],
                                    movie.title,
                                  ),
                                  showTitle: false,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),
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
