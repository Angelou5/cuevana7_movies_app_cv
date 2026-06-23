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
  List<Movie> moviesComedia = [];
  List<Movie> moviesTerror = [];
  List<Movie> moviesAccion = [];
  List<Movie> moviesSuspenso = [];
  List<Movie> moviesFamilia = []; // Para ver en familia

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
      await loadGenreMovies();
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

  Future<void> loadGenreMovies() async {
    try {
      moviesComedia = await repository.getByGenre(35); // Comedia
      moviesTerror = await repository.getByGenre(27); // Terror
      moviesAccion = await repository.getByGenre(28); // Acción
      moviesSuspenso = await repository.getByGenre(53); // Suspenso/Thriller
      moviesFamilia = await repository.getByGenre(10751); // Familia
    } catch (e) {
      debugPrint('Error cargando géneros: $e');
    }
    notifyListeners();
  }

  Future<void> _loadAllReviews() async {
    movieReviews = [];
    for (final movie in movies.take(20)) {
      try {
        final reviews = await repository.getMovieReviews(movie.id);
        debugPrint(
          'Reviews for ${movie.id} (${movie.title}): ${reviews.length}',
        );
        for (final r in reviews) {
          if(r.content.length < 1000){
            movieReviews.add(MovieReview(r, movie.title));
            }
        }
        
      } catch (e) {
        debugPrint('Error loading reviews for ${movie.id}: $e');
      }
    }
    notifyListeners();
  }
}
