import 'dart:async';
import 'dart:io';

enum ErrorType { network, notFound, server, unknown }

class RequestError {
  final ErrorType type;
  final String message;
  final int? statusCode;

  const RequestError({
    required this.type,
    required this.message,
    this.statusCode,
  });
}

RequestError classifyError(Object error, [int? statusCode]) {
  if (statusCode != null) {
    if (statusCode == 404) {
      return RequestError(
        type: ErrorType.notFound,
        message: 'No se encontro lo que buscas',
        statusCode: statusCode,
      );
    }
    if (statusCode >= 500) {
      return RequestError(
        type: ErrorType.server,
        message: 'Error del servidor, intenta mas tarde',
        statusCode: statusCode,
      );
    }
    return RequestError(
      type: ErrorType.unknown,
      message: 'Error inesperado (codigo $statusCode)',
      statusCode: statusCode,
    );
  }

  if (error is SocketException || error is HttpException) {
    return const RequestError(
      type: ErrorType.network,
      message: 'Sin conexion a internet, revisa tu red',
    );
  }

  if (error is TimeoutException) {
    return const RequestError(
      type: ErrorType.network,
      message: 'La conexion tardo demasiado, intenta de nuevo',
    );
  }

  return RequestError(
    type: ErrorType.unknown,
    message: error.toString(),
  );
}
