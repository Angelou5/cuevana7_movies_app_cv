import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:cuevana7_movies_app_cv/implements/controllers/users_controller.dart';
import 'package:cuevana7_movies_app_cv/services/middleware_verify.dart';

class ApiRouter {
  final UsersController usersController;

  ApiRouter({required this.usersController});

  Router get router {
    final router = Router();

    // Endpoints del servidor usando Shelf
    router.post('/auth/google', usersController.handleGoogleSignIn);
    router.post('/signup', usersController.handleSignUp);
    router.post('/signin', usersController.handleSignIn);
    router.get('/prueba', (Request request) {
      return Response.ok('¡Servidor Shelf funcionando correctamente!');
    });

    // Aqui se colocaran rutas protegidas por jwt

    final routerProtected = Router();
    // ejemplo xd
    routerProtected.get('/protegida', (Request request) {
      final usuarioPayload = request.context['usuarioPayload'];
      return Response.ok('Ruta accedida del usuario: $usuarioPayload');
    });

    final pipelineProtegida = Pipeline()
    .addMiddleware(verificarJwt())
    .addHandler(routerProtected.call);
    

    
    router.mount('/api', pipelineProtegida);

    return router;
  }
}
