import 'package:cuevana7_movies_app_cv/domain/datasources/users_datasources.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/user.dart';
import 'package:cuevana7_movies_app_cv/config/db/connect.dart';
import 'package:postgres/postgres.dart';


class UsersDataSourceImpl implements UsersDataSource {
 
   final Future<PostgreSQLConnection> connection = connect(); // humberto
  @override
  Future<User> getUser(String userId) async {
    final conn = await connection;
    final result = await conn.query(
      'SELECT id, name, email, password, rol, createdAt, updatedAt FROM users WHERE id = @userId',
      substitutionValues: {'userId': userId},
    );

    if (result.isEmpty) {
      throw Exception('Usuario no encontrado');
    }

    final row = result.first;
    return User(id: row[0], name: row[1], email: row[2], password: row[3], rol: row[4], createdAt: row[5], updatedAt: row[6]);
  }
  
  @override
  Future<bool> saveUser(User user) async {
    final conn = await connection; // gael
    final result =await conn.query(
      r'''
        INSERT INTO users (id, name, email, password, rol, createdAt, updatedAt)
        VALUES (@id, @name, @email, @password, @rol, @createdAt, @updatedAt)
       ''',
      substitutionValues: {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'password': user.password,
        'rol': user.rol,
        'createdAt': user.createdAt,
        'updatedAt': user.updatedAt,
      },
    );
    if(result.affectedRowCount == 0) {
      throw Exception('Failed to save user');
    }
    return true;
  }
}