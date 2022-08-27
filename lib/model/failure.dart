class RouteNotExistsException implements Exception {}

class ServerException implements Exception {
  const ServerException([this.message]);
  final String? message;
}

class Failure {
  const Failure([this.message]);
  final String? message;
}

class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message]);
}

class ConnectivityFailure extends Failure {
  const ConnectivityFailure([super.message]);
}
