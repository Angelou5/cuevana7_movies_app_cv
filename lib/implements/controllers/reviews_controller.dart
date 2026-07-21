import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:cuevana7_movies_app_cv/implements/repository/user_reviews_repository_impl.dart';

class ReviewsController {
  final ImplementUserReviewsRepository repository;

  ReviewsController({required this.repository});

  String _getUserId(Request request) {
    final payload = request.context['usuarioPayload'] as Map<String, dynamic>;
    return payload['id'] as String;
  }

  // GET /api/reviews/movie/:movieId
  Future<Response> handleGetByMovie(Request request, String movieId) async {
    try {
      final userId = _getUserId(request);
      final review = await repository.getByUserAndMovie(
        userId,
        int.parse(movieId),
      );
      if (review == null) {
        return Response.ok(
          jsonEncode(null),
          headers: {'content-type': 'application/json'},
        );
      }
      return Response.ok(
        jsonEncode(review.toJson()),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  // GET /api/reviews/me
  Future<Response> handleGetAllByUser(Request request) async {
    try {
      final userId = _getUserId(request);
      final reviews = await repository.getAllByUser(userId);
      return Response.ok(
        jsonEncode(reviews.map((r) => r.toJson()).toList()),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  // POST /api/reviews
  Future<Response> handleCreateReview(Request request) async {
    try {
      final userId = _getUserId(request);
      final body =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      if (body['movieId'] == null || body['content'] == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'movieId y content son requeridos'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final rating = body['rating'] as int?;
      if (rating != null && (rating < 1 || rating > 5)) {
        return Response.badRequest(
          body: jsonEncode({'error': 'rating debe ser entre 1 y 5'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final existing = await repository.getByUserAndMovie(
        userId,
        body['movieId'] as int,
      );
      if (existing != null) {
        return Response.badRequest(
          body: jsonEncode({
            'error': 'Ya tienes una reseña para esta película',
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      final review = await repository.create(
        userId,
        body['movieId'] as int,
        body['content'] as String,
        body['rating'] as int?,
      );

      return Response(
        201,
        body: jsonEncode(review.toJson()),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  // PUT /api/reviews/:id
  Future<Response> handleUpdateReview(
    Request request,
    String reviewId,
  ) async {
    try {
      final userId = _getUserId(request);
      final body =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      if (body['content'] == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'content es requerido'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final rating = body['rating'] as int?;
      if (rating != null && (rating < 1 || rating > 5)) {
        return Response.badRequest(
          body: jsonEncode({'error': 'rating debe ser entre 1 y 5'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final review = await repository.update(
        reviewId,
        userId,
        body['content'] as String,
        body['rating'] as int?,
      );

      return Response.ok(
        jsonEncode(review.toJson()),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  // DELETE /api/reviews/:id
  Future<Response> handleDeleteReview(
    Request request,
    String reviewId,
  ) async {
    try {
      final userId = _getUserId(request);
      await repository.delete(reviewId, userId);
      return Response.ok(
        jsonEncode({'message': 'Reseña eliminada'}),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'content-type': 'application/json'},
      );
    }
  }
}
