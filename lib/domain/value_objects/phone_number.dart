// lib/domain/value_objects/phone_number.dart
class PhoneNumber {
  final String value;
  
  const PhoneNumber._(this.value);
  
  factory PhoneNumber(String value) {
    final cleaned = _clean(value);
    if (!_isValid(cleaned)) {
      throw InvalidPhoneNumberException('Invalid phone number: $value');
    }
    return PhoneNumber._(cleaned);
  }
  
  static String _clean(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9+]'), '');
  }
  
  static bool _isValid(String phone) {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phone);
  }
  
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PhoneNumber && other.value == value);
  }
  
  @override
  int get hashCode => value.hashCode;
  
  @override
  String toString() => value;
}

class InvalidPhoneNumberException implements Exception {
  final String message;
  const InvalidPhoneNumberException(this.message);
}
