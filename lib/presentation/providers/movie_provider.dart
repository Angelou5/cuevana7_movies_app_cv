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
  bool isLoadingGenre = false;
  RequestError? error;
  int currentPage = 1;

  int _comediaPage = 1;
  int _terrorPage = 1;
  int _accionPage = 1;
  int _suspensoPage = 1;
  int _familiaPage = 1;

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

  String _lastQuery = '';

  void onSearchChanged(String query) {
    _debounce?.cancel();
    final cleanQuery = query.trim();

    if (cleanQuery.isEmpty) {
      searchResults = [];
      isSearching = false;
      notifyListeners();
      return;
    }

    isSearching = true;
    notifyListeners();
    _lastQuery = cleanQuery;

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      try {
        final results = await repository.searchMovies(cleanQuery);
        if (cleanQuery != _lastQuery) return;
        searchResults = results;
      } catch (_) {
        if (cleanQuery != _lastQuery) return;
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
    _comediaPage = 1;
    _terrorPage = 1;
    _accionPage = 1;
    _suspensoPage = 1;
    _familiaPage = 1;
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      movies = await repository.getNowPlaying();
    } catch (e) {
      error = classifyError(e);
      movies = [];
    }
    loadGenreMovies();
    _loadAllReviews();
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
    } catch (e) {
      error = classifyError(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadNextGenrePage(int genreId) async {
    isLoadingGenre = true;
    notifyListeners();
    try {
      int page;
      switch (genreId) {
        case 35:
          page = ++_comediaPage;
          break;
        case 27:
          page = ++_terrorPage;
          break;
        case 28:
          page = ++_accionPage;
          break;
        case 53:
          page = ++_suspensoPage;
          break;
        case 10751:
          page = ++_familiaPage;
          break;
        default:
          return;
      }
      final newMovies = await repository.getByGenre(genreId, page: page);
      switch (genreId) {
        case 35:
          moviesComedia.addAll(newMovies);
          break;
        case 27:
          moviesTerror.addAll(newMovies);
          break;
        case 28:
          moviesAccion.addAll(newMovies);
          break;
        case 53:
          moviesSuspenso.addAll(newMovies);
          break;
        case 10751:
          moviesFamilia.addAll(newMovies);
          break;
      }
    } catch (e) {
      debugPrint('Error cargando más películas: $e');
    }
    isLoadingGenre = false;
    notifyListeners();
  }

  Future<void> loadGenreMovies() async {
    try {
      final results = await Future.wait([
        repository.getByGenre(35),
        repository.getByGenre(27),
        repository.getByGenre(28),
        repository.getByGenre(53),
        repository.getByGenre(10751),
      ]);
      moviesComedia = results[0];
      moviesTerror = results[1];
      moviesAccion = results[2];
      moviesSuspenso = results[3];
      moviesFamilia = results[4];
    } catch (e) {
      debugPrint('Error cargando géneros: $e');
      moviesComedia = [];
      moviesTerror = [];
      moviesAccion = [];
      moviesSuspenso = [];
      moviesFamilia = [];
    }
    notifyListeners();
  }

  Future<void> _loadAllReviews() async {
    movieReviews = [];
    final futures = movies.take(20).map((movie) async {
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
    });
    await Future.wait(futures);
    notifyListeners();
  }
}
