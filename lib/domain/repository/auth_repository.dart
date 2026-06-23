import 'package:cuevana7_movies_app_cv/domain/entities/user.dart';

// El repositorio es la capa entre el dominio y el datasource.
// Permite cambiar la fuente de datos sin tocar la lógica de negocio.
abstract class AuthRepository {
  Future<UserEntity> login({required String email, required String password});

  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
  });

  Future<void> logout();
}
