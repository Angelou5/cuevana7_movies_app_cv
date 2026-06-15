import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/review.dart';
import '../../domain/repository/movies_repository.dart';

class MovieReview {
  final Review review;
  final String movieTitle;
  MovieReview(this.review, this.movieTitle);
}

class MovieProvider extends ChangeNotifier {
  final MovieRepositories repository;
  List<Movie> movies = [];
  List<MovieReview> movieReviews = [];
  bool isLoading = false;
  String? error;
  int currentPage = 1;

  MovieProvider(this.repository);

  Future<void> loadNowPlaying() async {
    currentPage = 1;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      movies = await repository.getNowPlaying();
      await _loadAllReviews();
    } catch (e) {
      error = e.toString();
      movies = [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadNextPage() async {
    currentPage++;
    isLoading = true;
    notifyListeners();

    try {
      final newMovies = await repository.getNowPlaying(page: currentPage);
      movies.addAll(newMovies);
      await _loadAllReviews();
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> _loadAllReviews() async {
    movieReviews = [];
    for (final movie in movies.take(5)) {
      try {
        final reviews = await repository.getMovieReviews(movie.id);
        debugPrint('Reviews for ${movie.id} (${movie.title}): ${reviews.length}');
        for (final r in reviews) {
          movieReviews.add(MovieReview(r, movie.title));
        }
      } catch (e) {
        debugPrint('Error loading reviews for ${movie.id}: $e');
      }
    }
    notifyListeners();
  }
}
