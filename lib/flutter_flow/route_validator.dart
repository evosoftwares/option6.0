import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'place.dart';
import 'lat_lng.dart';

/// Sistema de Validação Preventiva de Rotas
/// Previne problemas comuns antes de solicitar viagens
class RouteValidator {
  RouteValidator._();

  static RouteValidator? _instance;
  static RouteValidator get instance => _instance ??= RouteValidator._();

  // Constantes de validação
  static const double _minDistanceMeters = 500.0; // Mínimo 500m
  static const double _maxDistanceKm = 300.0; // Máximo 300km (dobrado)
  static const double _maxStopsDistance = 50.0; // Máximo 50km entre paradas
  static const int _maxStops = 4; // Máximo 4 paradas

  /// Valida uma rota completa antes da solicitação
  Future<RouteValidationResult> validateRoute({
    required FFPlace? origin,
    required FFPlace? destination,
    List<FFPlace>? stops,
  }) async {
    try {
      final issues = <ValidationIssue>[];
      final warnings = <ValidationWarning>[];

      // 1. Validações básicas
      if (origin == null) {
        issues.add(ValidationIssue(
          type: ValidationIssueType.missingOrigin,
          message: 'Selecione o local de partida',
          action: 'Toque em "Partida" para escolher',
        ));
      }

      if (destination == null) {
        issues.add(ValidationIssue(
          type: ValidationIssueType.missingDestination,
          message: 'Selecione o destino',
          action: 'Toque em "Destino" para escolher',
        ));
      }

      // Se não tem origem ou destino, não pode continuar
      if (origin == null || destination == null) {
        return RouteValidationResult(
          isValid: false,
          issues: issues,
          warnings: warnings,
        );
      }

      // 2. Validar distância origem-destino
      final mainDistance = _calculateDistance(origin.latLng, destination.latLng);

      if (mainDistance < _minDistanceMeters / 1000) {
        issues.add(ValidationIssue(
          type: ValidationIssueType.tooShort,
          message: 'Origem e destino estão muito próximos',
          action: 'Distância mínima: ${(_minDistanceMeters / 1000).toStringAsFixed(1)}km',
          details: 'Distância atual: ${(mainDistance * 1000).toStringAsFixed(0)}m',
        ));
      }

      if (mainDistance > _maxDistanceKm) {
        issues.add(ValidationIssue(
          type: ValidationIssueType.tooLong,
          message: 'Viagem muito longa',
          action: 'Distância máxima: ${_maxDistanceKm.toStringAsFixed(0)}km',
          details: 'Distância atual: ${mainDistance.toStringAsFixed(1)}km',
        ));
      }

      // 3. Validar paradas
      if (stops != null && stops.isNotEmpty) {
        if (stops.length > _maxStops) {
          issues.add(ValidationIssue(
            type: ValidationIssueType.tooManyStops,
            message: 'Muitas paradas selecionadas',
            action: 'Máximo ${_maxStops} paradas permitidas',
            details: 'Atual: ${stops.length} paradas',
          ));
        }

        // Validar distância entre paradas
        final stopsValidation = _validateStops(origin, destination, stops);
        issues.addAll(stopsValidation.issues);
        warnings.addAll(stopsValidation.warnings);
      }

      // 4. Validações geográficas
      final geoValidation = await _validateGeographicConstraints(origin, destination, stops);
      warnings.addAll(geoValidation);

      // 5. Estimativas e avisos
      final routeWarnings = _generateRouteWarnings(origin, destination, stops, mainDistance);
      warnings.addAll(routeWarnings);

      return RouteValidationResult(
        isValid: issues.isEmpty,
        issues: issues,
        warnings: warnings,
        estimatedDistance: mainDistance,
        estimatedDuration: _estimateDuration(mainDistance, stops),
        estimatedCost: _estimateCost(mainDistance, stops),
      );

    } catch (e) {
      debugPrint('❌ Erro na validação de rota: $e');
      return RouteValidationResult(
        isValid: false,
        issues: [
          ValidationIssue(
            type: ValidationIssueType.systemError,
            message: 'Erro ao validar rota',
            action: 'Tente novamente',
            details: e.toString(),
          )
        ],
        warnings: [],
      );
    }
  }

  /// Valida paradas individualmente
  StopsValidationResult _validateStops(FFPlace origin, FFPlace destination, List<FFPlace> stops) {
    final issues = <ValidationIssue>[];
    final warnings = <ValidationWarning>[];

    for (int i = 0; i < stops.length; i++) {
      final stop = stops[i];

      // Verificar se parada não é igual à origem ou destino
      if (_arePlacesEqual(stop, origin)) {
        issues.add(ValidationIssue(
          type: ValidationIssueType.duplicateLocation,
          message: 'Parada ${i + 1} é igual à origem',
          action: 'Escolha um local diferente',
        ));
      }

      if (_arePlacesEqual(stop, destination)) {
        issues.add(ValidationIssue(
          type: ValidationIssueType.duplicateLocation,
          message: 'Parada ${i + 1} é igual ao destino',
          action: 'Escolha um local diferente',
        ));
      }

      // Verificar distância da parada
      final distanceFromOrigin = _calculateDistance(origin.latLng, stop.latLng);
      final distanceFromDestination = _calculateDistance(stop.latLng, destination.latLng);

      if (distanceFromOrigin > _maxStopsDistance || distanceFromDestination > _maxStopsDistance) {
        warnings.add(ValidationWarning(
          type: ValidationWarningType.longDetour,
          message: 'Parada ${i + 1} pode causar desvio longo',
          details: 'Distância: ${math.max(distanceFromOrigin, distanceFromDestination).toStringAsFixed(1)}km',
        ));
      }

      // Verificar paradas duplicadas
      for (int j = i + 1; j < stops.length; j++) {
        if (_arePlacesEqual(stop, stops[j])) {
          issues.add(ValidationIssue(
            type: ValidationIssueType.duplicateLocation,
            message: 'Paradas ${i + 1} e ${j + 1} são iguais',
            action: 'Remova uma das paradas duplicadas',
          ));
        }
      }
    }

    return StopsValidationResult(issues: issues, warnings: warnings);
  }

  /// Validações geográficas (áreas de serviço, etc.)
  Future<List<ValidationWarning>> _validateGeographicConstraints(
    FFPlace origin,
    FFPlace destination,
    List<FFPlace>? stops,
  ) async {
    final warnings = <ValidationWarning>[];

    try {
      // Aqui você pode implementar validações específicas como:
      // - Verificar se está dentro da área de cobertura
      // - Alertar sobre áreas de trânsito complicado
      // - Avisar sobre horários de pico em certas regiões

      // Exemplo: avisar sobre viagens para aeroportos
      if (_isAirportLocation(destination)) {
        warnings.add(ValidationWarning(
          type: ValidationWarningType.specialLocation,
          message: 'Destino parece ser um aeroporto',
          details: 'Considere o tempo extra para embarque/desembarque',
        ));
      }

      // Exemplo: avisar sobre regiões de trânsito intenso
      if (_isHighTrafficArea(origin) || _isHighTrafficArea(destination)) {
        warnings.add(ValidationWarning(
          type: ValidationWarningType.trafficConcern,
          message: 'Rota passa por área de trânsito intenso',
          details: 'Tempo de viagem pode ser maior em horários de pico',
        ));
      }

      return warnings;
    } catch (e) {
      debugPrint('❌ Erro na validação geográfica: $e');
      return warnings;
    }
  }

  /// Gera avisos baseados na rota
  List<ValidationWarning> _generateRouteWarnings(
    FFPlace origin,
    FFPlace destination,
    List<FFPlace>? stops,
    double mainDistance,
  ) {
    final warnings = <ValidationWarning>[];
    final now = DateTime.now();

    // Aviso para viagens longas
    if (mainDistance > 50.0) {
      warnings.add(ValidationWarning(
        type: ValidationWarningType.longTrip,
        message: 'Viagem longa detectada',
        details: 'Distância: ${mainDistance.toStringAsFixed(1)}km - Tempo estimado: ${_formatDuration(_estimateDuration(mainDistance, stops))}',
      ));
    }

    // Aviso para horários de pico
    final hour = now.hour;
    if ((hour >= 7 && hour <= 9) || (hour >= 17 && hour <= 19)) {
      warnings.add(ValidationWarning(
        type: ValidationWarningType.rushHour,
        message: 'Horário de pico detectado',
        details: 'Trânsito pode estar mais intenso neste horário',
      ));
    }

    // Aviso para muitas paradas
    if (stops != null && stops.length >= 3) {
      warnings.add(ValidationWarning(
        type: ValidationWarningType.multipleStops,
        message: 'Múltiplas paradas selecionadas',
        details: '${stops.length} paradas podem aumentar significativamente o tempo de viagem',
      ));
    }

    return warnings;
  }

  /// Métodos auxiliares
  double _calculateDistance(LatLng from, LatLng to) {
    return Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    ) / 1000; // Retorna em km
  }

  bool _arePlacesEqual(FFPlace place1, FFPlace place2) {
    // Considera iguais se estão a menos de 100m de distância
    const tolerance = 0.1; // 100m em km
    final distance = _calculateDistance(place1.latLng, place2.latLng);
    return distance < tolerance;
  }

  int _estimateDuration(double distanceKm, List<FFPlace>? stops) {
    // Estimativa básica: 35 km/h + 5 min por parada
    final baseMinutes = (distanceKm / 35 * 60).round();
    final stopMinutes = (stops?.length ?? 0) * 5;
    return baseMinutes + stopMinutes;
  }

  double _estimateCost(double distanceKm, List<FFPlace>? stops) {
    // Estimativa básica: R$ 2,50/km + R$ 5,00 por parada + taxa base R$ 8,00
    const baseRate = 8.0;
    const kmRate = 2.5;
    const stopRate = 5.0;

    return baseRate + (distanceKm * kmRate) + ((stops?.length ?? 0) * stopRate);
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) {
      return '${hours}h${mins}min';
    }
    return '${mins}min';
  }

  bool _isAirportLocation(FFPlace place) {
    final name = place.name.toLowerCase();
    final address = place.address.toLowerCase();

    return name.contains('aeroporto') ||
           name.contains('airport') ||
           address.contains('aeroporto') ||
           address.contains('airport') ||
           name.contains('gru') ||
           name.contains('guarulhos') ||
           name.contains('congonhas') ||
           name.contains('viracopos');
  }

  bool _isHighTrafficArea(FFPlace place) {
    final address = place.address.toLowerCase();

    // Áreas conhecidas de trânsito intenso (exemplo para São Paulo)
    return address.contains('marginal') ||
           address.contains('radial') ||
           address.contains('anhangabaú') ||
           address.contains('paulista') ||
           address.contains('faria lima') ||
           address.contains('berrini');
  }
}

/// Resultado da validação de rota
class RouteValidationResult {
  final bool isValid;
  final List<ValidationIssue> issues;
  final List<ValidationWarning> warnings;
  final double? estimatedDistance;
  final int? estimatedDuration;
  final double? estimatedCost;

  RouteValidationResult({
    required this.isValid,
    required this.issues,
    required this.warnings,
    this.estimatedDistance,
    this.estimatedDuration,
    this.estimatedCost,
  });

  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasCriticalIssues => issues.any((issue) => issue.type.isCritical);
}

/// Resultado da validação de paradas
class StopsValidationResult {
  final List<ValidationIssue> issues;
  final List<ValidationWarning> warnings;

  StopsValidationResult({
    required this.issues,
    required this.warnings,
  });
}

/// Problemas que impedem a viagem
class ValidationIssue {
  final ValidationIssueType type;
  final String message;
  final String action;
  final String? details;

  ValidationIssue({
    required this.type,
    required this.message,
    required this.action,
    this.details,
  });
}

/// Avisos que não impedem mas alertam o usuário
class ValidationWarning {
  final ValidationWarningType type;
  final String message;
  final String? details;

  ValidationWarning({
    required this.type,
    required this.message,
    this.details,
  });
}

enum ValidationIssueType {
  missingOrigin,
  missingDestination,
  tooShort,
  tooLong,
  tooManyStops,
  duplicateLocation,
  systemError;

  bool get isCritical => this != systemError;
}

enum ValidationWarningType {
  longTrip,
  longDetour,
  rushHour,
  multipleStops,
  specialLocation,
  trafficConcern,
}