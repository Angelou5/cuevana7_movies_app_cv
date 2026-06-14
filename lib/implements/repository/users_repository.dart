
import '../../domain/entities/user.dart';
import '../../domain/repository/users_repository.dart';
import '../datasources/users_datasources.dart';
import 'package:bcrypt/bcrypt.dart';

class ImplementUserRepository implements UserRepository {
  final UsersDataSourceImplement dataSource;

  ImplementUserRepository(this.dataSource);

  @override
  Future<User> signUp(String name, String email, String password) async {
  

    try {
      
      final existingUser = await dataSource.findByEmail(email);

      if (existingUser != null) {
        throw Exception('El correo electrónico ya está registrado');
      }
      // Cambiamos a 'password_hash' y 'role'
      final String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

      final User result = 
      await dataSource.saveUser(name, email, hashedPassword);

      return result;
    } catch (e) {
      throw Exception('Error en signUp (Postgres): $e');
    }  
  }

  @override
  Future<User> signIn(String email, String password) async {
    

    try {
      // Ajustamos el SELECT con 'password_hash' y 'role'
      final User? result = await dataSource.findByEmail(email);

      if (result == null || !BCrypt.checkpw(password, result.password)) {
        throw Exception('Credenciales incorrectas o usuario inexistente');
      }
      
      // TODO: falta jwt
   
      return result; 
    } catch (e) {
      throw Exception('Error en signIn (Postgres): $e');
    } 
  }

  @override
  Future<void> signOut() async {
    return;
  }
}