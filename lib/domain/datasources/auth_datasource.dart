import 'package:cuevana7_movies_app_cv/domain/entities/user.dart';

// Contrato que define qué puede hacer el datasource de autenticación.
// La implementación real (que llama a la API) va en infrastructure/datasources/.
abstract class AuthDatasource {
  /// Inicia sesión con email y contraseña.
  /// Lanza excepción si las credenciales son incorrectas.
  Future<UserEntity> login({required String email, required String password});

  /// Registra un nuevo usuario.
  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
  });

  /// Cierra la sesión del usuario actual.
  Future<void> logout();
}
