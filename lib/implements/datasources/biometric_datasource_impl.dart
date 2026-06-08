import 'package:local_auth/local_auth.dart';

import '../../domain/datasources/biometric_datasource.dart';

class BiometricDatasourceImpl implements BiometricDatasource {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  Future<bool> authenticate() async {
    try {
      return await auth.authenticate(
        localizedReason: 'Usa tu huella para iniciar sesión',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> canAuthenticate() async {
    return await auth.canCheckBiometrics;
  }
}