import 'package:cuevana7_movies_app_cv/domain/entities/user.dart';

abstract class UsersDataSource {
  Future<User> getUser(String userId);

  Future<void> saveUser(User user);

 /* Future<User> login(String email, String password);

  Future<void> logout();

  Future<User> register(String email, String password);*/
}
