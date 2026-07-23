class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server error']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No network']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache error']);
}

class RateLimitException implements Exception {
  final String message;
  const RateLimitException([this.message = 'Rate limit exceeded']);
}