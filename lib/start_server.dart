import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'config/api/api_router.dart';
import 'implements/controllers/users_controller.dart';
import 'implements/repository/users_repository.dart';
import 'implements/datasources/users_datasources.dart';
import 'package:postgres/postgres.dart';
import 'config/db/connect.dart';

void main() async {
  // 1. Abrir la conexión a la BD UNA sola vez al arrancar el server
  final PostgreSQLConnection dbConnection = await connect();

  // 2. Inyectar la conexión al Datasource
  final dataSource = UsersDataSourceImplement(dbConnection);

  // 3. Inyectar el Datasource al Repositorio
  final userRepository = ImplementUserRepository(dataSource);

  // 4. Inyectar el repositorio al controlador
  final usersController = UsersController(userRepository: userRepository);

  // 5. Configurar el router con el controlador
  final apiRouter = ApiRouter(usersController: usersController);

  // 6. Configurar el servidor
  final handler = Pipeline()
      
      .addMiddleware(logRequests())
      .addHandler(apiRouter.router.call);

  final server = await io.serve(handler, '0.0.0.0', 3000);
  print('Servidor Shelf escuchando en http://${server.address.host}:${server.port}');
}