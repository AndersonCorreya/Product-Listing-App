class ServerException implements Exception {
  final String message;
  final int? code;

  const ServerException(this.message, [this.code]);

  @override
  String toString() => 'ServerException: $message';
}

class NetworkException implements Exception {
  final String message;
  final int? code;

  const NetworkException(this.message, [this.code]);

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;
  final int? code;

  const CacheException(this.message, [this.code]);

  @override
  String toString() => 'CacheException: $message';
}
