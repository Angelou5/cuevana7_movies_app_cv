import 'package:cuevana7_movies_app_cv/domain/entities/user_review.dart';

abstract class UserReviewsRepository {
  Future<UserReview?> getByUserAndMovie(String userId, int movieId);
  Future<UserReview> create(String userId, int movieId, String content, int? rating);
  Future<UserReview> update(String reviewId, String userId, String content, int? rating);
  Future<void> delete(String reviewId, String userId);
}
