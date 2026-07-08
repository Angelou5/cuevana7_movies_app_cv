import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/review.dart';
import '../../domain/repository/movies_repository.dart';
import '../../shared/http_utils.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
  RequestError? error;
  int currentPage = 1;

  final Map<int, Movie> _favorites = {};
  static const String _favoritesKey = 'favorite_movies';

  List<Movie> get favoriteMovies => _favorites.values.toList();

  bool isFavorite(int movieId) => _favorites.containsKey(movieId);

  Future<void> toggleFavorite(Movie movie) async {
    if (_favorites.containsKey(movie.id)) {
      _favorites.remove(movie.id);
    } else {
      _favorites[movie.id] = movie;
    }

    await _saveFavorites();

    notifyListeners();
  }

  MovieProvider(this.repository);

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final json = _favorites.values.map((movie) => movie.toJson()).toList();

    await prefs.setString(_favoritesKey, jsonEncode(json));
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(_favoritesKey);

    if (jsonString == null) return;

    final List decoded = jsonDecode(jsonString);

    _favorites.clear();

    for (final movieJson in decoded) {
      final movie = Movie.fromJson(movieJson);

      _favorites[movie.id] = movie;
    }

    notifyListeners();
  }

  // 👈 llamar desde onChanged del TextField
  void onSearchChanged(String query) {
    _debounce?.cancel();

    // Limpiar espacios en blanco al inicio y al final de la consulta
    final cleanQuery = query.trim();

    if (cleanQuery.isEmpty || cleanQuery.length < 3) {
      searchResults = [];
      isSearching = false;
      notifyListeners();
      return;
    }

    isSearching = true;
    notifyListeners();

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      try {
        searchResults = await repository.searchMovies(cleanQuery);
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
      error = classifyError(e);
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
      error = classifyError(e);
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
