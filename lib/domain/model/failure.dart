class RouteNotExistsException implements Exception {}

class ServerException implements Exception {
  const ServerException(this.message);
  final String message;

  @override
  String toString() {
    return message;
  }
}

class Failure {}

class ServerFailure extends Failure {}

class DatabaseFailure extends Failure {}

class ConnectivityFailure extends Failure {}
