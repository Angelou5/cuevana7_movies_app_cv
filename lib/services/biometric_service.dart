import 'package:flutter/services.dart';

class BiometricService {
  static const _channel = MethodChannel(
    'com.example.cuevana7_movies_app_cv/biometric',
  );

  Future<bool> authenticate({String reason = 'Usa tu huella'}) async {
    try {
      return await _channel.invokeMethod<bool>('authenticate', {'reason': reason}) ?? false;
    } catch (_) {
      return false;
    }
  }
}
