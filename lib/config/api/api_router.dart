import 'package:shelf_router/shelf_router.dart';
import 'package:cuevana7_movies_app_cv/implements/controllers/users_controller.dart';
class ApiRouter {
  final UsersController usersController;

  ApiRouter({required this.usersController});

  Router get router {
    final router = Router();

    // Endpoints del servidor usando Shelf
    router.post('/signup', usersController.handleSignUp);
    router.post('/signin', usersController.handleSignIn);

    return router;
  }
}