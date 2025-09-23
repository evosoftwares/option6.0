// lib/domain/value_objects/email.dart
class Email {
  final String value;
  
  const Email._(this.value);
  
  factory Email(String value) {
    if (!_isValid(value)) {
      throw InvalidEmailException('Invalid email format: $value');
    }
    return Email._(value);
  }
  
  static bool _isValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Email && other.value == value);
  }
  
  @override
  int get hashCode => value.hashCode;
  
  @override
  String toString() => value;
}

class InvalidEmailException implements Exception {
  final String message;
  const InvalidEmailException(this.message);
}
