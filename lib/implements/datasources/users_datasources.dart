import 'package:cuevana7_movies_app_cv/domain/datasources/users_datasources.dart';
import 'package:cuevana7_movies_app_cv/domain/entities/user.dart';
import 'package:postgres/postgres.dart';


class UsersDataSourceImplement implements UsersDataSource {
 
  final PostgreSQLConnection connection; 

  UsersDataSourceImplement(this.connection);// humberto

  @override
  Future<User> getUser(String userId) async {
    final conn = connection;
    final result = await conn.query(
      'SELECT id, name, email, password, rol, createdAt, updatedAt FROM users WHERE id = @userId',
      substitutionValues: {'userId': userId},
    );

    if (result.isEmpty) {
      throw Exception('Usuario no encontrado');
    }

    final row = result.first;
    return User(id: row[0], name: row[1], email: row[2]
    , password: row[3], rol: row[4], createdAt: row[5], updatedAt: row[6]);
  }
  
  @override
  Future<User> saveUser(String name, String email, String password) async {
    final conn = connection; // gael
    final result =await conn.query(
      r'''
        INSERT INTO users 
        ( name, email, password)
        VALUES 
        (@name, @email, @password)
        RETURNING id, name, email, password, rol, createdAt, updatedAt;
       ''',
      substitutionValues: {
        'name': name,
        'email': email,
        'password': password,
    
      },
    );
    if(result.affectedRowCount == 0) {
      throw Exception('Failed to save user');
    }
    return User(
      id: result.first[0],
      name: result.first[1],
      email: result.first[2],
      password: result.first[3],
      rol: result.first[4],
      createdAt: result.first[5],
      updatedAt: result.first[6]
    );
  }

  @override
  Future <User?> findByEmail(String email) async {
    final conn = connection;
    final result = await conn.query(
      'SELECT id, name, email, password, rol, createdAt, updatedAt FROM users WHERE email = @email',
      substitutionValues: {'email': email},
    );

    if (result.isEmpty) {
      return null;
    }

    final row = result.first;
    return User(id: row[0], name: row[1], email: row[2], password: row[3], rol: row[4], createdAt: row[5], updatedAt: row[6]);
  }
}