import '../../../domain/entities/movie_image.dart';

class MovieImageMapper {
  // Miniatura liviana para la galería horizontal
  static const String _thumbBase = 'https://image.tmdb.org/t/p/w300';
  // Calidad completa para el visor a pantalla completa
  static const String _fullBase = 'https://image.tmdb.org/t/p/original';

  static MovieImage fromJson(Map<String, dynamic> json) {
    final path = json['file_path']?.toString() ?? '';
    return MovieImage(
      thumbnailUrl: path.isNotEmpty ? '$_thumbBase$path' : '',
      fullUrl: path.isNotEmpty ? '$_fullBase$path' : '',
      aspectRatio: (json['aspect_ratio'] ?? 1.78).toDouble(),
    );
  }
}
