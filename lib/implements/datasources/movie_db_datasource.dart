import 'dart:async';
import 'dart:convert';
import 'package:cuevana7_movies_app_cv/domain/entities/review.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../domain/datasources/movies_datasources.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/actor.dart';
import 'mappers/actor_mapper.dart';
import 'mappers/movie_mapper.dart';

class MovieDbDatasource implements MovieDatasources {
  final String _baseUrl = 'https://api.themoviedb.org/3';
  late final String _token;

  MovieDbDatasource() {
    _token = dotenv.env['ACCESS_TOKEN'] ?? '';
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final url = Uri.parse(
      '$_baseUrl/movie/now_playing?page=$page&language=es-MX',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Error al cargar pelis de TMDB: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);

    final List<Movie> movies = (data['results'] as List)
        .map((movieJson) => MovieMapper.fromJson(movieJson))
        .toList();

    return movies;
  }

  // se implemento getMoviesByGenre que llama al endpoint de TMDB
  @override
  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async {
    final url = Uri.parse(
      '$_baseUrl/discover/movie?with_genres=$genreId&page=$page&language=es-MX',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception(
        'Error al cargar pelis por género de TMDB: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);

    final List<Movie> movies = (data['results'] as List)
        .map((movieJson) => MovieMapper.fromJson(movieJson))
        .toList();

    return movies;
  }

  @override
  Future<List<Review>> getMovieReviews(int movieId) async {
    final headers = {
      'Authorization': 'Bearer $_token',
      'accept': 'application/json',
    };

    final urlEs = Uri.parse('$_baseUrl/movie/$movieId/reviews?language=es-MX');
    final urlEn = Uri.parse('$_baseUrl/movie/$movieId/reviews');

    final responses = await Future.wait([
      http.get(urlEs, headers: headers).timeout(const Duration(seconds: 10)),
      http.get(urlEn, headers: headers).timeout(const Duration(seconds: 10)),
    ]);

    final all = <Review>[];
    final seen = <String>{};

    for (final res in responses) {
      if (res.statusCode != 200) continue;
      final data = jsonDecode(res.body);
      for (final json in data['results'] as List) {
        final details = json['author_details'] ?? {};
        final review = Review(
          author: json['author'] ?? 'Anónimo',
          content: json['content'] ?? '',
          rating: (details['rating'] as num?)?.toDouble(),
          avatarPath: details['avatar_path']?.toString(),
        );
        final key = '${review.author}|${review.content.substring(0, 40)}';
        if (seen.add(key)) {
          all.add(review);
        }
      }
    }

    return all;
  }

  @override
  Future<List<Movie>> getByGenre(int genreId, {int page = 1}) async {
    final url = Uri.parse(
      '$_baseUrl/discover/movie?with_genres=$genreId&page=$page&language=es-MX&sort_by=popularity.desc&with_original_language=en',
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw Exception('Error al cargar por género: ${response.statusCode}');
    }
    final data = jsonDecode(response.body);
    return (data['results'] as List)
        .map((j) => MovieMapper.fromJson(j))
        .toList();
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.parse(
      '$_baseUrl/search/movie?query=${Uri.encodeComponent(query)}&language=es-MX&page=1',
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw Exception('Error al buscar: ${response.statusCode}');
    }
    final data = jsonDecode(response.body);
    return (data['results'] as List)
        .map((j) => MovieMapper.fromJson(j))
        .toList();
  }

  @override
  Future<String?> getMovieTrailerKey(int movieId) async {
    final headers = {
      'Authorization': 'Bearer $_token',
      'accept': 'application/json',
    };

    //Para buscar trailer en español o ingles
    final urlEs = Uri.parse('$_baseUrl/movie/$movieId/videos?language=es-MX');
    final urlEn = Uri.parse('$_baseUrl/movie/$movieId/videos');

    try{
      var response = await http.get(urlEs, headers: headers).timeout(const Duration(seconds: 10));

      if(response.statusCode != 200){
        final data = jsonDecode(response.body);
        final results = data['results'] as List;

        final trailer = results.firstWhere(
          (v) => v['site'] == 'YouTube' && v['type'] == 'Trailer',
          orElse: () => null,
          );
        }

        //Por si no hay en español, buscamos en ingles
        response = await http.get(urlEn, headers: headers).timeout(const Duration(seconds: 10));

        if(response.statusCode != 200){
        final data = jsonDecode(response.body);
        final results = data['results'] as List;

        final trailer = results.firstWhere(
          (v) => v['site'] == 'YouTube' && v['type'] == 'Trailer',
          orElse: () => null,
          );
          if(trailer != null) return trailer['key'] as String;
        }
        return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Actor>> getMovieCast(int movieId) async {
    final url = Uri.parse('$_baseUrl/movie/$movieId/credits?language=es-MX');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Error cargando reparto: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);

    return (data['cast'] as List)
        .map((actor) => ActorMapper.fromJson(actor))
        .toList();
  }
}
