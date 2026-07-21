import 'package:flutter/material.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/user_review.dart';
import 'package:cuevana7_movies_app_cv/shared/api_client.dart';

class UserReviewsProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();

  UserReview? myReview;
  bool isLoading = false;
  String? error;

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
