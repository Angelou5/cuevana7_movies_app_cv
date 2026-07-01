import 'dart:convert';
import 'package:http/http.dart' as http;
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

  @override
  Future<User> signInWithGoogle(String idToken) async {
    try {
      // 1. Validar el token directo con el endpoint oficial de Google
      final url = Uri.parse('https://oauth2.googleapis.com/tokeninfo?id_token=$idToken');
      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Token de Google inválido, alterado o expirado');
      }

      // 2. Extraer el payload seguro que nos devuelve Google
      final payload = jsonDecode(response.body) as Map<String, dynamic>;
      
      final String email = payload['email'];
      final String name = payload['name'] ?? 'Usuario de Google';
      final String googleId = payload['sub']; // ID único del usuario en Google

      // 3. Buscar si el usuario ya existe en tu Postgres por correo
      User? user = await dataSource.findByEmail(email);

      if (user == null) {
        // Si no existe, lo registramos en caliente en Postgres.
        // Le ponemos una contraseña dummy o vacía, ya que siempre se validará vía Google.
        final String dummyPassword = BCrypt.hashpw(googleId, BCrypt.gensalt());
        user = await dataSource.saveUser(name, email, dummyPassword);
      }

      return user;
    } catch (e) {
      throw Exception('Error en signInWithGoogle (Backend): $e');
    }
  }
}