
class UserEntity{
 final String id;
 final String email;
 final String? name;
 final String? token;
 
 const UserEntity({
  required this.id,
  required this.email,
  required this.name,
  required this.token,
 });

}

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final Roles rol;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.rol,
    required this.createdAt,
    required this.updatedAt
  });
}

enum Roles{
  user, admin
}