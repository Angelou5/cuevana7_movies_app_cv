class ActorDetail {
  final int id;
  final String name;
  final String biography;
  final String profilePath;
  final String birthday;
  final String? deathday;
  final String placeOfBirth;
  final String knownForDepartment;
  final double popularity;

  const ActorDetail({
    required this.id,
    required this.name,
    required this.biography,
    required this.profilePath,
    required this.birthday,
    this.deathday,
    required this.placeOfBirth,
    required this.knownForDepartment,
    required this.popularity,
  });
}
