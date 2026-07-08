import '/domain/entities/actor.dart';

class ActorMapper {
  static Actor fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      character: json['character'] ?? '',
      profilePath: json['profile_path'] != null
          ? 'https://image.tmdb.org/t/p/w185${json['profile_path']}'
          : '',
    );
  }
}
