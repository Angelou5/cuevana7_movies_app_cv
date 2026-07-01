import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../repository/users_repository.dart';
import 'package:cuevana7_movies_app_cv/services/jwt_service.dart';

class UsersController {
  final ImplementUserRepository userRepository;

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

      final token = GenerarJWT(user);

      return Response.ok(
        jsonEncode({
          'message': 'Login exitoso',
          'user': {
            'id': user.id,
            'name': user.name,
            'email': user.email,
            'rol': user.rol.name,
          },
          'token': token,
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      // 1. IMPRIME EL ERROR REAL EN TU CONSOLA xd
      print('==== ERROR DETONADO EN SIGNIN ====');
      print(e); 
      
      return Response(
        401,
        // 2. MÁNDALO TAMBIÉN EN EL JSON PARA QUE LO VEAS EN POSTMAN jasjda
        body: jsonEncode({
          'error': 'Credenciales inválidas',
          'detalle_real': e.toString(), 
        }),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  //Handler para Inicio de Sesión con Google
  // Handler para Inicio de Sesión con Google
  Future<Response> handleGoogleSignIn(Request request) async {
    try {
      final payload = await request.readAsString();
      final body = jsonDecode(payload) as Map<String, dynamic>;

      // Esperamos un JSON en el body que traiga {'idToken': '...'}
      if (body['idToken'] == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'El campo idToken es requerido'}),
          headers: {'content-type': 'application/json'},
        );
      }

      // Invocamos la lógica que acabamos de poner en el repositorio
      final user = await userRepository.signInWithGoogle(body['idToken']);

      // Usamos tu mismo método para firmar el token JWT de tu servidor
      final token = GenerarJWT(user);

      return Response.ok(
        jsonEncode({
          'message': 'Login con Google exitoso',
          'user': {
            'id': user.id,
            'name': user.name,
            'email': user.email,
            'rol': user.rol.name,
          },
          'token': token, // Tu JWT seguro de vuelta a la app móvil
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      print('==== ERROR DETONADO EN GOOGLE SIGNIN ====');
      print(e);
      
      return Response(
        401,
        body: jsonEncode({
          'error': 'Autenticación con Google fallida',
          'detalle_real': e.toString(),
        }),
        headers: {'content-type': 'application/json'},
      );
    }
  }
}