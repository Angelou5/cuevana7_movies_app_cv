import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../domain/repositories/users_repositories.dart';

class UsersController {
  final UserRepository userRepository;

  UsersController({required this.userRepository});

  // Handler para Registro (Sign Up)
  Future<Response> handleSignUp(Request request) async {
    try {
      final payload = await request.readAsString();
      final body = jsonDecode(payload) as Map<String, dynamic>;

      if (body['name'] == null || body['email'] == null || body['password'] == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Faltan campos obligatorios: name, email o password'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final user = await userRepository.signUp(
        body['name'],
        body['email'],
        body['password'],
      );

      return Response( // Usamos 201 Created de forma manual
        201,
        body: jsonEncode({
          'message': 'Usuario creado con éxito',
          'user': {
            'id': user.id,
            'name': user.name,
            'email': user.email,
            'rol': user.rol.name,
          }
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  // Handler para Inicio de Sesión (Sign In)
  Future<Response> handleSignIn(Request request) async {
    try {
      final payload = await request.readAsString();
      final body = jsonDecode(payload) as Map<String, dynamic>;

      if (body['email'] == null || body['password'] == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Email y password son requeridos'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final user = await userRepository.signIn(
        body['email'],
        body['password'],
      );

      return Response.ok(
        jsonEncode({
          'message': 'Login exitoso',
          'user': {
            'id': user.id,
            'name': user.name,
            'email': user.email,
            'rol': user.rol.name,
          }
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response(
        401, // Unauthorized
        body: jsonEncode({'error': 'Credenciales inválidas'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }
}