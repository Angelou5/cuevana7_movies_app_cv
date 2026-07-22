import 'package:cuevana7_movies_app_cv/domain/entities/user_review.dart';
import 'package:cuevana7_movies_app_cv/domain/repository/user_reviews_repository.dart';
import 'package:cuevana7_movies_app_cv/implements/datasources/user_reviews_datasource_impl.dart';

class ImplementUserReviewsRepository implements UserReviewsRepository {
  final UserReviewsDataSourceImplement dataSource;

  ImplementUserReviewsRepository(this.dataSource);

  @override
  Future<UserReview?> getByUserAndMovie(String userId, int movieId) {
    return dataSource.getByUserAndMovie(userId, movieId);
  }

  @override
  Future<List<UserReview>> getAllByUser(String userId) {
    return dataSource.getAllByUser(userId);
  }

  @override
  Future<UserReview> create(
    String userId,
    int movieId,
    String content,
    int? rating,
  ) {
    return dataSource.create(userId, movieId, content, rating);
  }

  @override
  Future<UserReview> update(String reviewId, String userId, String content, int? rating) {
    return dataSource.update(reviewId, userId, content, rating);
  }

  @override
  Future<void> delete(String reviewId, String userId) {
    return dataSource.delete(reviewId, userId);
  }
}
