class APIException implements Exception {
  final String message;
  final int statusCode;

  const APIException({required this.message, required this.statusCode});
}

class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});
}

class ServerException implements Exception {
  final String message;

  const ServerException({required this.message});
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({required this.message});
}

class AuthenticationException implements Exception {
  final String message;

  const AuthenticationException({required this.message});
}

class DatabaseException implements Exception {
  final String message;

  const DatabaseException({required this.message});
}

class InvalidInputException implements Exception {
  final String message;

  const InvalidInputException({required this.message});
}

class NotFoundException implements Exception {
  final String message;

  const NotFoundException({required this.message});
}