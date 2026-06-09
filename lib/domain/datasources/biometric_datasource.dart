abstract class BiometricDatasource {
  Future<bool> authenticate();
  Future<bool> canAuthenticate();
}