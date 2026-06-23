
import 'package:cuevana7_movies_app_cv/domain/entities/user.dart';

abstract class UserRepository {

  Future<User> signIn(String email, String password);

  Future<User> signUp(String name, String email, String password);
  
  Future<void> signOut();

}