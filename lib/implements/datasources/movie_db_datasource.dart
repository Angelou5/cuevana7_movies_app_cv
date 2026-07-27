import 'dart:async';
import 'dart:convert';
import 'package:cuevana7_movies_app_cv/domain/entities/review.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../domain/datasources/movies_datasources.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/actor.dart';
import '../../domain/entities/actor_detail.dart';
import '../../domain/entities/movie_image.dart';
import 'mappers/actor_mapper.dart';
import 'mappers/actor_detail_mapper.dart';
import 'mappers/movie_mapper.dart';
import 'mappers/movie_image_mapper.dart';

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

    final response = await http
        .get(
          url,
          headers: {
            'Authorization': 'Bearer $_token',
            'accept': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Error al cargar pelis de TMDB: ${response.statusCode}');
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
    final response = await http
        .get(
          url,
          headers: {
            'Authorization': 'Bearer $_token',
            'accept': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 10));
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
    final response = await http
        .get(
          url,
          headers: {
            'Authorization': 'Bearer $_token',
            'accept': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 10));
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

    final urlEs = Uri.parse('$_baseUrl/movie/$movieId/videos?language=es-MX');
    final urlEn = Uri.parse('$_baseUrl/movie/$movieId/videos');

    try {
      var response = await http
          .get(urlEs, headers: headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;
        final key = _pickTrailerKey(results);
        if (key != null) return key;
      }

      response = await http
          .get(urlEn, headers: headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;
        final key = _pickTrailerKey(results);
        if (key != null) return key;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  String? _pickTrailerKey(List results) {
    final youtube = results.where((v) => v['site'] == 'YouTube').toList();
    if (youtube.isEmpty) return null;

    const preferred = ['Trailer', 'Teaser', 'Clip'];
    for (final type in preferred) {
      final match = youtube.firstWhere(
        (v) => v['type'] == type,
        orElse: () => null,
      );
      if (match != null) return match['key'] as String;
    }

    return (youtube.first)['key'] as String?;
  }

  @override
  Future<List<Actor>> getMovieCast(int movieId) async {
    final url = Uri.parse('$_baseUrl/movie/$movieId/credits?language=es-MX');

    final response = await http
        .get(
          url,
          headers: {
            'Authorization': 'Bearer $_token',
            'accept': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Error cargando reparto: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);

    return (data['cast'] as List)
        .map((actor) => ActorMapper.fromJson(actor))
        .toList();
  }

  // NUEVO: detalle del actor (biografía, foto, lugar de nacimiento, etc.)
  @override
  Future<ActorDetail> getActorDetails(int actorId) async {
    final headers = {
      'Authorization': 'Bearer $_token',
      'accept': 'application/json',
    };

    final urlEs = Uri.parse('$_baseUrl/person/$actorId?language=es-MX');
    final urlEn = Uri.parse('$_baseUrl/person/$actorId');

    var response = await http
        .get(urlEs, headers: headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Si TMDB no tiene biografía traducida al español, cae al inglés
      final hasBio =
          data['biography'] != null && (data['biography'] as String).isNotEmpty;
      if (hasBio) {
        return ActorDetailMapper.fromJson(data);
      }

      final responseEn = await http
          .get(urlEn, headers: headers)
          .timeout(const Duration(seconds: 10));
      if (responseEn.statusCode == 200) {
        final dataEn = jsonDecode(responseEn.body);
        data['biography'] = dataEn['biography'];
        return ActorDetailMapper.fromJson(data);
      }
      return ActorDetailMapper.fromJson(data);
    }

    response = await http
        .get(urlEn, headers: headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Error cargando el actor: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    return ActorDetailMapper.fromJson(data);
  }

  // NUEVO: filmografía del actor
  @override
  Future<List<Movie>> getActorMovies(int actorId) async {
    final url = Uri.parse(
      '$_baseUrl/person/$actorId/movie_credits?language=es-MX',
    );

    final response = await http
        .get(
          url,
          headers: {
            'Authorization': 'Bearer $_token',
            'accept': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Error cargando filmografía: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final cast = (data['cast'] as List? ?? [])
        .map((movie) => MovieMapper.fromJson(movie))
        .toList();

    // Ordenar por fecha de estreno, más recientes primero
    cast.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));

    return cast;
  }

  // NUEVO: galería de imágenes de la película (backdrops + posters)
  @override
  Future<List<MovieImage>> getMovieImages(int movieId) async {
    // include_image_language trae también las imágenes "sin idioma"
    // (las artísticas, que TMDB no asocia a ningún idioma en particular)
    final url = Uri.parse(
      '$_baseUrl/movie/$movieId/images?include_image_language=es,en,null',
    );

    final response = await http
        .get(
          url,
          headers: {
            'Authorization': 'Bearer $_token',
            'accept': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Error cargando la galería: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);

    final backdrops = (data['backdrops'] as List? ?? [])
        .map((j) => MovieImageMapper.fromJson(j))
        .toList();
    final posters = (data['posters'] as List? ?? [])
        .map((j) => MovieImageMapper.fromJson(j))
        .toList();

    // Limitamos la galería a un máximo de 50 imágenes
    final allImages = [...backdrops, ...posters];
    return allImages.take(50).toList();
  }
}
