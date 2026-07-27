import '../../../domain/entities/actor_detail.dart';

class ActorDetailMapper {
  static const String _profileBase = 'https://image.tmdb.org/t/p/w500';

  static ActorDetail fromJson(Map<String, dynamic> json) {
    return ActorDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Desconocido',
      biography:
          (json['biography'] != null && json['biography'].toString().isNotEmpty)
          ? json['biography']
          : 'No hay biografía disponible para este actor.',
      profilePath: json['profile_path'] != null
          ? '$_profileBase${json['profile_path']}'
          : '',
      birthday: json['birthday'] ?? '',
      deathday: json['deathday'],
      placeOfBirth: json['place_of_birth'] ?? '',
      knownForDepartment: json['known_for_department'] ?? '',
      popularity: (json['popularity'] ?? 0).toDouble(),
    );
  }
}
