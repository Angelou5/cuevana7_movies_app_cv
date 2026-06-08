import '../../domain/repositories/biometric_repository.dart';
import '../../domain/datasources/biometric_datasource.dart';

class BiometricRepositoryImpl implements BiometricRepository {
  final BiometricDatasource datasource;

  BiometricRepositoryImpl(this.datasource);

  @override
  Future<bool> authenticate() {
    return datasource.authenticate();
  }

  @override
  Future<bool> canAuthenticate() {
    return datasource.canAuthenticate();
  }
}