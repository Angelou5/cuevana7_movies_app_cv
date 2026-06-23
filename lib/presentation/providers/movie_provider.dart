import 'dart:async';
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
  List<Movie> moviesFamilia = [];
  List<MovieReview> movieReviews = [];

  List<Movie> searchResults = [];
  bool isSearching = false;
  Timer? _debounce;

  bool isLoading = false;
  String? error;
  int currentPage = 1;

  MovieProvider(this.repository);

  // 👈 llamar desde onChanged del TextField
  void onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      searchResults = [];
      isSearching = false;
      notifyListeners();
      return;
    }
    isSearching = true;
    notifyListeners();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      try {
        searchResults = await repository.searchMovies(query.trim());
      } catch (_) {
        searchResults = [];
      }
      isSearching = false;
      notifyListeners();
    });
  }

  void clearSearch() {
    _debounce?.cancel();
    searchResults = [];
    isSearching = false;
    notifyListeners();
  }

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
      moviesComedia = await repository.getByGenre(35);
      moviesTerror = await repository.getByGenre(27);
      moviesAccion = await repository.getByGenre(28);
      moviesSuspenso = await repository.getByGenre(53);
      moviesFamilia = await repository.getByGenre(10751);
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
        for (final r in reviews) {
          if (r.content.length < 1000) {
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
