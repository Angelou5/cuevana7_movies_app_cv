import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:cuevana7_movies_app_cv/implements/controllers/users_controller.dart';
import 'package:cuevana7_movies_app_cv/implements/controllers/reviews_controller.dart';
import 'package:cuevana7_movies_app_cv/services/middleware_verify.dart';

class ApiRouter {
  final UsersController usersController;
  final ReviewsController reviewsController;

  ApiRouter({
    required this.usersController,
    required this.reviewsController,
  });

  Router get router {
    final router = Router();

    // Endpoints públicos
    router.post('/auth/google', usersController.handleGoogleSignIn);
    router.post('/signup', usersController.handleSignUp);
    router.post('/signin', usersController.handleSignIn);
    router.get('/prueba', (Request request) {
      return Response.ok('¡Servidor Shelf funcionando correctamente!');
    });

    // Rutas protegidas por JWT
    final routerProtected = Router();
    routerProtected.get('/protegida', (Request request) {
      final usuarioPayload = request.context['usuarioPayload'];
      return Response.ok('Ruta accedida del usuario: $usuarioPayload');
    });

    // ── Reseñas de usuarios ──────────────────────────────────
    routerProtected.get('/reviews/movie/<movieId>',
        reviewsController.handleGetByMovie);
    routerProtected.post('/reviews', reviewsController.handleCreateReview);
    routerProtected.put('/reviews/<id>', reviewsController.handleUpdateReview);
    routerProtected.delete(
        '/reviews/<id>', reviewsController.handleDeleteReview);

    final pipelineProtegida = Pipeline()
        .addMiddleware(verificarJwt())
        .addHandler(routerProtected.call);

    router.mount('/api', pipelineProtegida);

    return router;
  }
}
