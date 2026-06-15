import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

Middleware verificarJwt() {
  return (Handler innerHandler) {
    return (Request request) async {
      // primero se busca la cabecera de auth
      final authHeader = request.headers['Authorization'];

      // Si no trae pulsera o no empieza con "Bearer ", pa' fuera
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response.forbidden(
          'Acceso denegado: Falta el token o el formato es incorrecto');
      }

      // 2. Le quitamos la palabra "Bearer " para quedarnos solo con el token largo
      final token = authHeader.substring(7);

      try {
        // 3. Verificamos que la firma sea tuya y que no haya caducado (los 3 días)
        final jwtSecret = Platform.environment['JWT_SECRET_KEY'];
        final jwt = JWT.verify(token, SecretKey(jwtSecret!));

        // 4. (Opcional pero pro) Guardamos los datos del usuario en el Request
        // Así tu controlador sabe QUÍEN hizo la petición
        final peticionModificada = request
        .change(context: {'usuarioPayload': jwt.payload});

        // 5. El cadenero lo deja pasar a la siguiente función (tu controlador)
        return Future.sync(() => innerHandler(peticionModificada));

      } catch (e) {
        // Si el token caducó o es falso, la librería lanza un error y lo rebotamos
        return Response.forbidden(
          'Token inválido o expirado jasjda');
      }
    };
  };
}