import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:cuevana7_movies_app_cv/implements/controllers/users_controller.dart';
class ApiRouter {
  final UsersController usersController;

  ApiRouter({required this.usersController});

  Router get router {
    final router = Router();

    // Endpoints del servidor usando Shelf
    router.post('/signup', usersController.handleSignUp);
    router.post('/signin', usersController.handleSignIn);
    router.get('/prueba', (Request request) {
      return Response.ok('¡Servidor Shelf funcionando correctamente!');
    });

    return router;
  }
}