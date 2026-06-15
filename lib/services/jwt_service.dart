import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'dart:io';
import 'package:cuevana7_movies_app_cv/domain/entities/user.dart';

String GenerarJWT(User user) {
  final secretKey = Platform.environment['JWT_SECRET_KEY'];

  final jwt = JWT(
    {
      'id': user.id,
      'email': user.email,
      'rol': user.rol.name,
    },
    issuer: 'com.cuevana7',
  );

  final token = jwt.sign(SecretKey(secretKey!)
  , expiresIn: Duration(days: 3));
  
  return token;
}