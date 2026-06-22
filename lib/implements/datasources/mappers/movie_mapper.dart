import '../../../domain/entities/movie.dart';

class MovieMapper {
  static const String _posterBase = 'https://image.tmdb.org/t/p/w500';
  static const String _backdropBase = 'https://image.tmdb.org/t/p/w780';

  static Movie fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: (json['title'] != null && json['title'].toString().isNotEmpty)
          ? json['title']
          : (json['original_title'] ?? 'Sin título'),
      overview: json['overview'] ?? 'Sin descripción',
      posterPath: json['poster_path'] != null
          ? '$_posterBase${json['poster_path']}'
          : '',
      backdropPath: json['backdrop_path'] != null
          ? '$_backdropBase${json['backdrop_path']}'
          : '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      releaseDate:
          json['release_date'] != null &&
              json['release_date'].toString().isNotEmpty
          ? DateTime.parse(json['release_date'])
          : DateTime(2000),
      adult: json['adult'] ?? false,
      video: json['video'] ?? false,
      popularity: (json['popularity'] ?? 0).toDouble(),
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      genreIds:
          (json['genre_ids'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
