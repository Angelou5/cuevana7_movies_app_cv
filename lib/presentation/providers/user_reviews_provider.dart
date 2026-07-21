import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/user_review.dart';
import 'package:cuevana7_movies_app_cv/shared/api_client.dart';

class UserReviewsProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();
  static const String _titlesCacheKey = 'movie_titles_cache';

  UserReview? myReview;
  List<UserReview> allMyReviews = [];
  Map<int, String> movieTitles = {};
  bool isLoading = false;
  String? error;

  UserReviewsProvider() {
    _loadTitlesCache();
  }

  Future<void> _loadTitlesCache() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_titlesCacheKey);
    if (raw != null) {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      movieTitles = decoded.map((k, v) => MapEntry(int.parse(k), v as String));
      notifyListeners();
    }
  }

  Future<void> _saveTitlesCache() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = movieTitles.map((k, v) => MapEntry(k.toString(), v));
    await prefs.setString(_titlesCacheKey, jsonEncode(raw));
  }

  Future<void> loadMyReview(int movieId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final data = await _api.get('/reviews/movie/$movieId');
      if (data != null && data.isNotEmpty) {
        myReview = UserReview.fromJson(data);
      } else {
        myReview = null;
      }
    } catch (e) {
      myReview = null;
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadAllMyReviews() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final list = await _api.getList('/reviews/me');
      allMyReviews = list.map((j) => UserReview.fromJson(j)).toList();
    } catch (e) {
      allMyReviews = [];
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMovieTitles(List<int> movieIds) async {
    final token = dotenv.env['ACCESS_TOKEN'] ?? '';
    final uniqueIds = movieIds.toSet().where((id) => !movieTitles.containsKey(id));

    if (uniqueIds.isEmpty) return;

    final futures = uniqueIds.map((id) async {
      try {
        final url = Uri.parse('https://api.themoviedb.org/3/movie/$id?language=es-MX');
        final response = await http.get(url, headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
        }).timeout(const Duration(seconds: 5));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          movieTitles[id] = data['title'] as String? ?? 'Sin título';
        } else {
          movieTitles[id] = 'Sin título';
        }
      } catch (_) {
        movieTitles[id] = 'Sin título';
      }
    });

    await Future.wait(futures);
    notifyListeners();
    _saveTitlesCache();
  }

  Future<void> loadReviewsAndTitles() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final list = await _api.getList('/reviews/me');
      allMyReviews = list.map((j) => UserReview.fromJson(j)).toList();
    } catch (e) {
      allMyReviews = [];
      error = e.toString();
    }

    if (allMyReviews.isNotEmpty) {
      final ids = allMyReviews.map((r) => r.movieId).toList();
      final token = dotenv.env['ACCESS_TOKEN'] ?? '';
      final uniqueIds = ids.toSet().where((id) => !movieTitles.containsKey(id));

      if (uniqueIds.isNotEmpty) {
        final futures = uniqueIds.map((id) async {
          try {
            final url = Uri.parse('https://api.themoviedb.org/3/movie/$id?language=es-MX');
            final response = await http.get(url, headers: {
              'Authorization': 'Bearer $token',
              'accept': 'application/json',
            }).timeout(const Duration(seconds: 5));
            if (response.statusCode == 200) {
              final data = jsonDecode(response.body);
              movieTitles[id] = data['title'] as String? ?? 'Sin título';
            } else {
              movieTitles[id] = 'Sin título';
            }
          } catch (_) {
            movieTitles[id] = 'Sin título';
          }
        });
        await Future.wait(futures);
        _saveTitlesCache();
      }
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> createReview(int movieId, String content, int? rating) async {
    try {
      final data = await _api.post('/reviews', {
        'movieId': movieId,
        'content': content,
        'rating': rating,
      });
      if (data != null) {
        myReview = UserReview.fromJson(data);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateReview(String reviewId, String content, int? rating) async {
    try {
      final data = await _api.put('/reviews/$reviewId', {
        'content': content,
        'rating': rating,
      });
      if (data != null) {
        myReview = UserReview.fromJson(data);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteReview(String reviewId) async {
    try {
      final ok = await _api.delete('/reviews/$reviewId');
      if (ok) {
        myReview = null;
        allMyReviews.removeWhere((r) => r.id == reviewId);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
