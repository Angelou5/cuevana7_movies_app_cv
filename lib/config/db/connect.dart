import 'dart:io';

import 'package:postgres/postgres.dart';

Future<PostgreSQLConnection> connect() async {
  final host = Platform.environment['DB_HOST'];
  final dbName = Platform.environment['POSTGRES_DB'];
  final dbUser = Platform.environment['POSTGRES_USER'];
  final dbPassword = Platform.environment['POSTGRES_PASSWORD'];
  final dbPort = Platform.environment['POSTGRES_PORT'];

  final connection = PostgreSQLConnection(
    host!,   // Host  
    int.parse(dbPort!),   // Port
    dbName!, // Database name
    username: dbUser!,
    password: dbPassword!,
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
