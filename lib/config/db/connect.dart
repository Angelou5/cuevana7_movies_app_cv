import 'package:postgres/postgres.dart';

Future<PostgreSQLConnection> connect() async {
  final connection = PostgreSQLConnection(
    'localhost',   // Host
    5432,   // Port
    'cuevana7_movies_app_cv_db', // Database name
    username: 'postgres', // no siempre es lo mismo eh xd cambienlo si no es el mismo user
    password: 'postgres',
  );

  try {
    await connection.open();
    print('Conexión a postgres');

    
   /* final results = await connection.query('SELECT * FROM users');
    for (var row in results) {
      print(row);
    }*/
    return connection;
  } catch (e) {
    print('Fallo de conexión: $e');
    throw Exception('Excepción: $e');

   }
  }