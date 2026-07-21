import 'package:postgres/postgres.dart';
import 'package:cuevana7_movies_app_cv/domain/datasources/user_reviews_datasources.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/user_review.dart';

class UserReviewsDataSourceImplement implements UserReviewsDataSource {
  final PostgreSQLConnection connection;

  UserReviewsDataSourceImplement(this.connection);

  UserReview _mapRow(PostgreSQLResultRow row) {
    return UserReview(
      id: row[0] as String,
      userId: row[1] as String,
      movieId: row[2] as int,
      rating: row[3] as int?,
      content: row[4] as String,
      createdAt: row[5] as DateTime,
      updatedAt: row[6] as DateTime,
    );
  }

  @override
  Future<UserReview?> getByUserAndMovie(String userId, int movieId) async {
    final result = await connection.query(
      'SELECT id, user_id, movie_id, rating, content, created_at, updated_at '
      'FROM user_reviews WHERE user_id = @userId AND movie_id = @movieId',
      substitutionValues: {'userId': userId, 'movieId': movieId},
    );
    if (result.isEmpty) return null;
    return _mapRow(result.first);
  }

  @override
  Future<UserReview> create(
    String userId,
    int movieId,
    String content,
    int? rating,
  ) async {
    final result = await connection.query(
      r'''
        INSERT INTO user_reviews (user_id, movie_id, content, rating)
        VALUES (@userId, @movieId, @content, @rating)
        RETURNING id, user_id, movie_id, rating, content, created_at, updated_at
      ''',
      substitutionValues: {
        'userId': userId,
        'movieId': movieId,
        'content': content,
        'rating': rating,
      },
    );
    if (result.affectedRowCount == 0) {
      throw Exception('No se pudo crear la reseña');
    }
    return _mapRow(result.first);
  }

  @override
  Future<UserReview> update(
    String reviewId,
    String userId,
    String content,
    int? rating,
  ) async {
    final result = await connection.query(
      r'''
        UPDATE user_reviews
        SET content = @content, rating = @rating
        WHERE id = @reviewId AND user_id = @userId
        RETURNING id, user_id, movie_id, rating, content, created_at, updated_at
      ''',
      substitutionValues: {
        'reviewId': reviewId,
        'userId': userId,
        'content': content,
        'rating': rating,
      },
    );
    if (result.isEmpty) {
      throw Exception('Reseña no encontrada o no pertenece al usuario');
    }
    return _mapRow(result.first);
  }

  @override
  Future<void> delete(String reviewId, String userId) async {
    final result = await connection.query(
      'DELETE FROM user_reviews WHERE id = @reviewId AND user_id = @userId',
      substitutionValues: {'reviewId': reviewId, 'userId': userId},
    );
    if (result.affectedRowCount == 0) {
      throw Exception('Reseña no encontrada o no pertenece al usuario');
    }
  }
}
