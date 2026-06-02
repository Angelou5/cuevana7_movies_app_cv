import 'package:postgres/postgres.dart';
import '../../config/db/connect.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/users_repositories.dart';

class PostgresUserRepository implements UserRepository {
  
  @override
  Future<User> signUp(String name, String email, String password) async {
    final PostgreSQLConnection db = await connect();

    try {
      // Dejamos que Postgres genere el ID con gen_random_uuid()
      // Cambiamos a 'password_hash' y 'role'
      final List<List<dynamic>> result = await db.query(
        '''
        INSERT INTO users (name, email, password_hash)
        VALUES (@name, @email, @password)
        RETURNING id, name, email, password_hash, role, created_at, updated_at;
        ''',
        substitutionValues: {
          'name': name,
          'email': email,
          'password': password, 
        },
      );

      if (result.isEmpty) {
        throw Exception('No se pudo crear el usuario en la base de datos');
      }

      final row = result.first;
      return User(
        id: row[0].toString(),
        name: row[1].toString(),
        email: row[2].toString(),
        password: row[3].toString(),
        rol: row[4].toString() == 'admin' ? Roles.admin : Roles.user,
        createdAt: row[5] as DateTime,
        updatedAt: row[6] as DateTime,
      );
    } catch (e) {
      throw Exception('Error en signUp (Postgres): $e');
    } finally {
      await db.close();
    }
  }

  @override
  Future<User> signIn(String email, String password) async {
    final PostgreSQLConnection db = await connect();

    try {
      // Ajustamos el SELECT con 'password_hash' y 'role'
      final List<List<dynamic>> result = await db.query(
        '''
        SELECT id, name, email, password_hash, role, created_at, updated_at 
        FROM users 
        WHERE email = @email AND password_hash = @password;
        ''',
        substitutionValues: {
          'email': email,
          'password': password,
        },
      );

      if (result.isEmpty) {
        throw Exception('Credenciales incorrectas o usuario inexistente');
      }

      final row = result.first;
      return User(
        id: row[0].toString(),
        name: row[1].toString(),
        email: row[2].toString(),
        password: row[3].toString(),
        rol: row[4].toString() == 'admin' ? Roles.admin : Roles.user,
        createdAt: row[5] as DateTime,
        updatedAt: row[6] as DateTime,
      );
    } catch (e) {
      throw Exception('Error en signIn (Postgres): $e');
    } finally {
      await db.close();
    }
  }

  @override
  Future<void> signOut() async {
    return;
  }
}