import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/auth_provider.dart';
import 'package:cuevana7_movies_app_cv/presentation/providers/movie_provider.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';

class HomeScreen extends StatefulWidget {
  static const String name = 'home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieProvider>().loadNowPlaying();
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            icon: const Icon(Icons.logout, color: AppColors.hint, size: 20),
                            onPressed: () {
                              context.read<AuthProvider>().logout();
                              context.go('/login');
                            },
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          Hero(
                            tag: 'app-logo',
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 36,
                              height: 36,
                            ),
                          ),
                          const SizedBox(width: 10),

                          Expanded(
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.inputFill,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Row(
                                children: [
                                  SizedBox(width: 14),
                                  Icon(Icons.search, color: AppColors.hint, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Buscar',
                                    style: TextStyle(
                                      color: AppColors.hint,
                                      fontSize: 16,
                                      fontFamily: 'InclusiveSans',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Géneros populares',
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
                      child: Row(
                        children: [
                          _GenreChip(label: 'Terror'),
                          const SizedBox(width: 8),
                          _GenreChip(label: 'Comedia'),
                          const SizedBox(width: 8),
                          _GenreChip(label: 'Suspenso'),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.hint,
                            size: 20,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Novedades',
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
                      child: SizedBox(
                        height: 140,
                        child: movieProvider.isLoading && movieProvider.movies.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : movieProvider.error != null && movieProvider.movies.isEmpty
                                ? Center(
                                    child: Text(
                                      '${movieProvider.error}',
                                      style: TextStyle(
                                        color: AppColors.hint,
                                        fontFamily: 'InclusiveSans',
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: movieProvider.movies.length + 1,
                                    separatorBuilder: (_, _) => const SizedBox(width: 10),
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
                                                  onTap: () => context.read<MovieProvider>().loadNextPage(),
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
                    ),

                    const SizedBox(height: 20),

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
                              children: movieProvider.movieReviews.take(2).map((mr) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _ReviewCard(movieReview: mr),
                                );
                              }).toList(),
                            ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              decoration: const BoxDecoration(
                color: AppColors.dark,
                border: Border(
                  top: BorderSide(color: AppColors.inputFill, width: 0.5),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Icon(Icons.home, color: AppColors.buttonText, size: 26),
                  Icon(
                    Icons.bookmark_border,
                    color: AppColors.buttonText,
                    size: 26,
                  ),
                  Icon(
                    Icons.favorite_border,
                    color: AppColors.buttonText,
                    size: 26,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenreChip extends StatelessWidget {
  final String label;
  const _GenreChip({required this.label});

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
      child: movie != null && movie.posterPath.isNotEmpty
          ? Image.network(
              movie.posterPath,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox(),
            )
          : null,
    );
  }
}

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
