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

      // aqui solo extraemos el token
      print(authHeader);
      final token = authHeader.substring(7);

      try {
        // verificar la firma 
        final jwtSecret = Platform.environment['JWT_SECRET_KEY'];
        final jwt = JWT.verify(token, SecretKey(jwtSecret!));

        // guardar datos del usuario en request
        final peticionModificada = request
        .change(context: {'usuarioPayload': jwt.payload});

        // todo bien
        return Future.sync(() => innerHandler(peticionModificada));

      } catch (e) {
        //si caduca o es falso
        return Response.forbidden(
          'Token inválido o expirado jasjda');
      }
    };
  };
} 