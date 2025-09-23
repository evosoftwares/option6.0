// lib/domain/value_objects/money.dart
class Money {
  final int centavos; // Evita problemas de ponto flutuante
  
  const Money._(this.centavos);
  
  factory Money.fromReais(double reais) {
    return Money._((reais * 100).round());
  }
  
  factory Money.fromCentavos(int centavos) {
    if (centavos < 0) {
      throw ArgumentError('Money cannot be negative');
    }
    return Money._(centavos);
  }
  
  factory Money.zero() => const Money._(0);
  
  double get reais => centavos / 100.0;
  
  Money add(Money other) => Money._(centavos + other.centavos);
  Money subtract(Money other) => Money._(centavos - other.centavos);
  Money multiply(int factor) => Money._(centavos * factor);
  Money divide(int divisor) => Money._((centavos / divisor).round());
  
  bool isZero() => centavos == 0;
  bool isPositive() => centavos > 0;
  bool isNegative() => centavos < 0;
  
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Money && other.centavos == centavos);
  }
  
  @override
  int get hashCode => centavos.hashCode;
  
  @override
  String toString() => 'R\$ ${reais.toStringAsFixed(2)}';
}
