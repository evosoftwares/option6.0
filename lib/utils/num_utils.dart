// lib/utils/num_utils.dart
// Utilitários para conversão segura de valores dinâmicos em double

double? toDoubleOrNull(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

double toDoubleOrZero(dynamic value) {
  return toDoubleOrNull(value) ?? 0.0;
}