/// Thrown by data sources. Caught by repositories and translated into
/// [Failure]s so the domain/presentation layers never see raw dio/HTTP types.
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, List<String>>? errors;

  const ServerException({
    required this.message,
    this.statusCode,
    this.errors,
  });
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Nothing cached']);
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException([this.message = 'Session expired']);
}
