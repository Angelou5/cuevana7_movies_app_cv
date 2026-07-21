import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'config/api/api_router.dart';
import 'implements/controllers/users_controller.dart';
import 'implements/controllers/reviews_controller.dart';
import 'implements/repository/users_repository.dart';
import 'implements/repository/user_reviews_repository_impl.dart';
import 'implements/datasources/users_datasources.dart';
import 'implements/datasources/user_reviews_datasource_impl.dart';
import 'package:postgres/postgres.dart';
import 'config/db/connect.dart';

void main() async {
  // 1. Abrir la conexión a la BD UNA sola vez al arrancar el server
  final PostgreSQLConnection dbConnection = await connect();

  // 2. Inyectar la conexión al Datasource de usuarios
  final dataSource = UsersDataSourceImplement(dbConnection);
  final userRepository = ImplementUserRepository(dataSource);
  final usersController = UsersController(userRepository: userRepository);

  // 3. Inyectar la conexión al Datasource de reseñas
  final reviewsDataSource = UserReviewsDataSourceImplement(dbConnection);
  final reviewsRepository =
      ImplementUserReviewsRepository(reviewsDataSource);
  final reviewsController =
      ReviewsController(repository: reviewsRepository);

  // 4. Configurar el router con ambos controladores
  final apiRouter = ApiRouter(
    usersController: usersController,
    reviewsController: reviewsController,
  );

  // 5. Configurar el servidor
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(apiRouter.router.call);

  final server = await io.serve(handler, '0.0.0.0', 3000);
  print(
      'Servidor Shelf escuchando en http://${server.address.host}:${server.port}');
}
