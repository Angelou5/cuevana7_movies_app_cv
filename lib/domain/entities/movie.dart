// Entidad del dominio — no depende de ningún framework ni API
class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? token;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.token,
  });
}
