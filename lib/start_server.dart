import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'config/api/api_router.dart';
import 'implements/controllers/users_controller.dart';
import 'implements/repository/users_repository.dart';

void main() async {
  // 1. Inicializas tu repositorio (el que conecta a Postgres)
  final userRepository = PostgresUserRepository();

  // 2. Inyectas el repositorio al controlador de Shelf
  final usersController = UsersController(userRepository: userRepository);

  // 3. Creas el router de la API
  final apiRouter = ApiRouter(usersController: usersController);

  // 4. Creamos el pipeline con el logger de Shelf
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(apiRouter.router.call);

  // 5. Encendemos el servidor en el puerto 3000
  final server = await io.serve(handler, '0.0.0.0', 3000);
  print('Servidor Shelf escuchando en http://${server.address.host}:${server.port}');
}