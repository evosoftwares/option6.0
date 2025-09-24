// lib/infrastructure/exceptions/repository_exception.dart

class RepositoryException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  
  const RepositoryException(
    this.message, {
    this.code,
    this.originalError,
  });
  
  @override
  String toString() {
    if (code != null) {
      return 'RepositoryException($code): $message';
    }
    return 'RepositoryException: $message';
  }
}