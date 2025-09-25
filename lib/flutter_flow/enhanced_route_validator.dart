import 'dart:math' as math;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/backend/supabase/supabase.dart';
import 'place.dart';
import 'route_validator.dart';

/// Sistema Avançado de Validação e Precificação de Rotas
/// Integra APIs externas para cálculos precisos de rotas e preços
/// Substitui estimativas básicas por dados reais de trânsito e roteamento

class EnhancedRouteValidator {
  EnhancedRouteValidator._();

  static EnhancedRouteValidator? _instance;
  static EnhancedRouteValidator get instance => _instance ??= EnhancedRouteValidator._();

  // Cache para evitar chamadas desnecessárias
  final Map<String, RouteCalculationResult> _routeCache = {};
  final Map<String, PricingResult> _pricingCache = {};

  // Configurações da API (adicionar no .env)
  static const String _googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  // ignore: unused_field
  static const String _mapboxApiKey = 'YOUR_MAPBOX_API_KEY';

  // Constantes de precificação dinâmica
  static const double _baseRate = 8.0; // Taxa base R$ 8,00
  static const double _kmRateNormal = 2.5; // R$ 2,50/km normal
  static const double _kmRatePeak = 3.0; // R$ 3,00/km horário pico
  static const double _stopRate = 5.0; // R$ 5,00 por parada
  static const double _waitingRate = 0.5; // R$ 0,50 por minuto de espera
  static const double _nightSurcharge = 1.2; // 20% adicional noturno
  // ignore: unused_field
  static const double _rainSurcharge = 1.15; // 15% adicional chuva

  /// Validação avançada com dados reais de roteamento
  Future<EnhancedValidationResult> validateRouteAdvanced({
    required FFPlace? origin,
    required FFPlace? destination,
    List<FFPlace>? stops,
    String vehicleCategory = 'standard',
    bool useRealTimeTraffic = true,
    bool calculateAlternatives = false,
  }) async {
    try {
      final issues = <ValidationIssue>[];
      final warnings = <ValidationWarning>[];

      // 1. Validações básicas (reutilizar do sistema atual)
      final basicValidation = await _performBasicValidations(origin, destination, stops);
      issues.addAll(basicValidation.issues);
      warnings.addAll(basicValidation.warnings);

      if (!basicValidation.isValid) {
        return EnhancedValidationResult(
          isValid: false,
          issues: issues,
          warnings: warnings,
        );
      }

      // 2. Cálculo de rota com API externa
      final routeResult = await _calculateRealRoute(
        origin: origin!,
        destination: destination!,
        stops: stops,
        useTraffic: useRealTimeTraffic,
      );

      if (!routeResult.success) {
        issues.add(ValidationIssue(
          type: ValidationIssueType.systemError,
          message: 'Não foi possível calcular a rota',
          action: 'Verifique os endereços e tente novamente',
          details: routeResult.error,
        ));
        return EnhancedValidationResult(
          isValid: false,
          issues: issues,
          warnings: warnings,
        );
      }

      // 3. Cálculo de preço dinâmico
      final pricingResult = await _calculateDynamicPricing(
        routeData: routeResult,
        vehicleCategory: vehicleCategory,
        origin: origin,
        destination: destination,
        stops: stops,
      );

      // 4. Validações avançadas baseadas em dados reais
      final advancedWarnings = await _performAdvancedValidations(
        routeResult,
        pricingResult,
        origin,
        destination,
        stops,
      );
      warnings.addAll(advancedWarnings);

      // 5. Verificar disponibilidade de motoristas na região
      final availabilityCheck = await _checkDriverAvailability(origin, vehicleCategory);
      if (!availabilityCheck.hasDrivers) {
        warnings.add(ValidationWarning(
          type: ValidationWarningType.trafficConcern,
          message: 'Poucos motoristas disponíveis na região',
          details: 'Tempo de espera pode ser maior que o normal',
        ));
      }

      return EnhancedValidationResult(
        isValid: true,
        issues: issues,
        warnings: warnings,
        routeData: routeResult,
        pricingData: pricingResult,
        estimatedWaitTime: availabilityCheck.estimatedWaitTime,
        alternatives: calculateAlternatives ? await _calculateAlternativeRoutes(origin, destination, stops) : null,
      );

    } catch (e) {
      debugPrint('❌ Erro na validação avançada: $e');
      return EnhancedValidationResult(
        isValid: false,
        issues: [
          ValidationIssue(
            type: ValidationIssueType.systemError,
            message: 'Erro no sistema de validação',
            action: 'Tente novamente em alguns segundos',
            details: e.toString(),
          )
        ],
        warnings: [],
      );
    }
  }

  /// Calcula rota real usando Google Maps Directions API
  Future<RouteCalculationResult> _calculateRealRoute({
    required FFPlace origin,
    required FFPlace destination,
    List<FFPlace>? stops,
    bool useTraffic = true,
  }) async {
    try {
      // Criar chave de cache
      final cacheKey = _generateCacheKey(origin, destination, stops, useTraffic);
      if (_routeCache.containsKey(cacheKey)) {
        final cached = _routeCache[cacheKey]!;
        // Cache válido por 10 minutos
        if (DateTime.now().difference(cached.calculatedAt).inMinutes < 10) {
          return cached;
        }
      }

      // Construir URL da API
      final originStr = '${origin.latLng.latitude},${origin.latLng.longitude}';
      final destinationStr = '${destination.latLng.latitude},${destination.latLng.longitude}';

      String waypointsStr = '';
      if (stops != null && stops.isNotEmpty) {
        waypointsStr = '&waypoints=' + stops
            .map((stop) => '${stop.latLng.latitude},${stop.latLng.longitude}')
            .join('|');
      }

      final trafficModel = useTraffic ? '&departure_time=now&traffic_model=best_guess' : '';

      final url = 'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=$originStr'
          '&destination=$destinationStr'
          '$waypointsStr'
          '&key=$_googleMapsApiKey'
          '$trafficModel'
          '&language=pt-BR'
          '&region=BR';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        return RouteCalculationResult(
          success: false,
          error: 'Erro na API: ${response.statusCode}',
        );
      }

      final data = jsonDecode(response.body);

      if (data['status'] != 'OK') {
        return RouteCalculationResult(
          success: false,
          error: 'API retornou: ${data['status']}',
        );
      }

      final route = data['routes'][0];
      final leg = route['legs'][0];

      final result = RouteCalculationResult(
        success: true,
        distanceMeters: leg['distance']['value'],
        durationSeconds: leg['duration']['value'],
        durationInTrafficSeconds: leg['duration_in_traffic']?['value'],
        polyline: route['overview_polyline']['points'],
        bounds: _parseBounds(route['bounds']),
        steps: _parseSteps(leg['steps']),
        calculatedAt: DateTime.now(),
      );

      // Salvar no cache
      _routeCache[cacheKey] = result;

      return result;

    } catch (e) {
      debugPrint('❌ Erro ao calcular rota: $e');
      return RouteCalculationResult(
        success: false,
        error: 'Erro interno: ${e.toString()}',
      );
    }
  }

  /// Cálculo de preço dinâmico baseado em múltiplos fatores
  Future<PricingResult> _calculateDynamicPricing({
    required RouteCalculationResult routeData,
    required String vehicleCategory,
    required FFPlace origin,
    required FFPlace destination,
    List<FFPlace>? stops,
  }) async {
    try {
      final cacheKey = 'pricing_${vehicleCategory}_${routeData.distanceMeters}_${DateTime.now().hour}';
      if (_pricingCache.containsKey(cacheKey)) {
        final cached = _pricingCache[cacheKey]!;
        if (DateTime.now().difference(cached.calculatedAt).inMinutes < 5) {
          return cached;
        }
      }

      // 1. Preço base
      double basePrice = _baseRate;

      // 2. Preço por distância (considerando trânsito)
      final distanceKm = routeData.distanceMeters / 1000;
      final isRushHour = _isRushHour();
      final kmRate = isRushHour ? _kmRatePeak : _kmRateNormal;
      final distancePrice = distanceKm * kmRate;

      // 3. Preço por paradas
      final stopsPrice = (stops?.length ?? 0) * _stopRate;

      // 4. Adicional por tempo de trânsito
      double trafficSurcharge = 0.0;
      if (routeData.durationInTrafficSeconds != null && routeData.durationInTrafficSeconds! > routeData.durationSeconds) {
        final extraMinutes = (routeData.durationInTrafficSeconds! - routeData.durationSeconds) / 60;
        trafficSurcharge = extraMinutes * _waitingRate;
      }

      // 5. Adicional noturno (22h às 6h)
      double nightSurcharge = 0.0;
      if (_isNightTime()) {
        nightSurcharge = (basePrice + distancePrice) * (_nightSurcharge - 1.0);
      }

      // 6. Adicional por categoria de veículo
      final vehicleMultiplier = _getVehicleCategoryMultiplier(vehicleCategory);

      // 7. Verificar condições climáticas
      final weatherSurcharge = await _getWeatherSurcharge(origin);

      // 8. Surge pricing baseado na demanda
      final demandMultiplier = await _getDemandMultiplier(origin, destination);

      // Cálculo final
      final subtotal = (basePrice + distancePrice + stopsPrice + trafficSurcharge + nightSurcharge) * vehicleMultiplier;
      final surchargeAmount = subtotal * (weatherSurcharge - 1.0) + subtotal * (demandMultiplier - 1.0);
      final totalPrice = subtotal + surchargeAmount;

      // Preço mínimo
      final minimumPrice = _getMinimumPrice(vehicleCategory);
      final finalPrice = math.max(totalPrice, minimumPrice);

      final result = PricingResult(
        basePrice: basePrice,
        distancePrice: distancePrice,
        stopsPrice: stopsPrice,
        trafficSurcharge: trafficSurcharge,
        nightSurcharge: nightSurcharge,
        vehicleMultiplier: vehicleMultiplier,
        weatherSurcharge: weatherSurcharge,
        demandMultiplier: demandMultiplier,
        totalPrice: finalPrice,
        breakdown: _generatePriceBreakdown(
          basePrice,
          distancePrice,
          stopsPrice,
          trafficSurcharge,
          nightSurcharge,
          surchargeAmount,
        ),
        calculatedAt: DateTime.now(),
      );

      _pricingCache[cacheKey] = result;
      return result;

    } catch (e) {
      debugPrint('❌ Erro no cálculo de preço: $e');
      return PricingResult(
        basePrice: _baseRate,
        distancePrice: (routeData.distanceMeters / 1000) * _kmRateNormal,
        stopsPrice: 0.0,
        trafficSurcharge: 0.0,
        nightSurcharge: 0.0,
        vehicleMultiplier: 1.0,
        weatherSurcharge: 1.0,
        demandMultiplier: 1.0,
        totalPrice: _baseRate + ((routeData.distanceMeters / 1000) * _kmRateNormal),
        breakdown: {'Erro': 'Falha no cálculo, usando preço base'},
        calculatedAt: DateTime.now(),
      );
    }
  }

  /// Verifica disponibilidade de motoristas em tempo real
  Future<DriverAvailabilityResult> _checkDriverAvailability(FFPlace origin, String vehicleCategory) async {
    try {
      final availability = await SupaFlow.client.rpc(
        'verificar_disponibilidade_motoristas',
        params: {
          'categoria_veiculo': vehicleCategory,
          'lat_origem': origin.latLng.latitude,
          'lon_origem': origin.latLng.longitude,
          'raio_km': 10.0,
        },
      );

      if (availability.isNotEmpty) {
        final data = availability.first;
        return DriverAvailabilityResult(
          hasDrivers: (data['motoristas_disponiveis'] ?? 0) > 0,
          availableCount: data['motoristas_disponiveis'] ?? 0,
          estimatedWaitTime: data['tempo_medio_chegada'] ?? 15,
        );
      }

      return DriverAvailabilityResult(
        hasDrivers: false,
        availableCount: 0,
        estimatedWaitTime: 20,
      );

    } catch (e) {
      debugPrint('❌ Erro ao verificar disponibilidade: $e');
      return DriverAvailabilityResult(
        hasDrivers: true, // Assumir disponível se houver erro
        availableCount: 1,
        estimatedWaitTime: 15,
      );
    }
  }

  /// Validações básicas (reutiliza sistema atual)
  Future<BasicValidationResult> _performBasicValidations(FFPlace? origin, FFPlace? destination, List<FFPlace>? stops) async {
    // Implementação básica similar ao RouteValidator atual
    final issues = <ValidationIssue>[];
    final warnings = <ValidationWarning>[];

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

    return BasicValidationResult(
      isValid: issues.isEmpty,
      issues: issues,
      warnings: warnings,
    );
  }

  /// Validações avançadas baseadas em dados reais
  Future<List<ValidationWarning>> _performAdvancedValidations(
    RouteCalculationResult routeData,
    PricingResult pricingData,
    FFPlace origin,
    FFPlace destination,
    List<FFPlace>? stops,
  ) async {
    final warnings = <ValidationWarning>[];

    // Viagem muito cara
    if (pricingData.totalPrice > 150.0) {
      warnings.add(ValidationWarning(
        type: ValidationWarningType.longTrip,
        message: 'Viagem com preço elevado',
        details: 'R\$ ${pricingData.totalPrice.toStringAsFixed(2)} - Verifique se está correto',
      ));
      }

      // Trânsito muito intenso
      if (routeData.durationInTrafficSeconds != null) {
        final extraTime = (routeData.durationInTrafficSeconds! - routeData.durationSeconds) / 60;
        if (extraTime > 30) {
          warnings.add(ValidationWarning(
            type: ValidationWarningType.trafficConcern,
            message: 'Trânsito muito intenso detectado',
            details: '+${extraTime.toStringAsFixed(0)} min devido ao trânsito',
          ));
        }
      }

    return warnings;
  }

  /// Métodos auxiliares de precificação
  bool _isRushHour() {
    final hour = DateTime.now().hour;
    return (hour >= 7 && hour <= 9) || (hour >= 17 && hour <= 19);
  }

  bool _isNightTime() {
    final hour = DateTime.now().hour;
    return hour >= 22 || hour <= 6;
  }

  double _getVehicleCategoryMultiplier(String category) {
    switch (category.toLowerCase()) {
      case 'economy':
        return 0.9;
      case 'standard':
        return 1.0;
      case 'premium':
        return 1.4;
      case 'suv':
        return 1.6;
      case 'van':
        return 1.8;
      default:
        return 1.0;
    }
  }

  double _getMinimumPrice(String category) {
    switch (category.toLowerCase()) {
      case 'economy':
        return 12.0;
      case 'standard':
        return 15.0;
      case 'premium':
        return 20.0;
      case 'suv':
        return 25.0;
      case 'van':
        return 30.0;
      default:
        return 15.0;
    }
  }

  Future<double> _getWeatherSurcharge(FFPlace location) async {
    try {
      // Integração com API de clima (OpenWeatherMap, etc.)
      // Por enquanto, retorna valor padrão
      return 1.0; // Sem adicional
    } catch (e) {
      return 1.0;
    }
  }

  Future<double> _getDemandMultiplier(FFPlace origin, FFPlace destination) async {
    try {
      // Calcular surge pricing baseado na demanda atual vs motoristas disponíveis
      // Por enquanto, retorna valor padrão
      return 1.0; // Sem surge
    } catch (e) {
      return 1.0;
    }
  }

  Map<String, dynamic> _generatePriceBreakdown(
    double basePrice,
    double distancePrice,
    double stopsPrice,
    double trafficSurcharge,
    double nightSurcharge,
    double surchargeAmount,
  ) {
    final breakdown = <String, dynamic>{};

    breakdown['Taxa base'] = 'R\$ ${basePrice.toStringAsFixed(2)}';
    breakdown['Distância'] = 'R\$ ${distancePrice.toStringAsFixed(2)}';

    if (stopsPrice > 0) {
      breakdown['Paradas'] = 'R\$ ${stopsPrice.toStringAsFixed(2)}';
    }

    if (trafficSurcharge > 0) {
      breakdown['Trânsito extra'] = 'R\$ ${trafficSurcharge.toStringAsFixed(2)}';
    }

    if (nightSurcharge > 0) {
      breakdown['Adicional noturno'] = 'R\$ ${nightSurcharge.toStringAsFixed(2)}';
    }

    if (surchargeAmount > 0) {
      breakdown['Adicionais'] = 'R\$ ${surchargeAmount.toStringAsFixed(2)}';
    }

    return breakdown;
  }

  /// Métodos auxiliares de cache e parsing
  String _generateCacheKey(FFPlace origin, FFPlace destination, List<FFPlace>? stops, bool useTraffic) {
    final stopsKey = stops?.map((s) => '${s.latLng.latitude},${s.latLng.longitude}').join('_') ?? '';
    return '${origin.latLng.latitude}_${origin.latLng.longitude}_${destination.latLng.latitude}_${destination.latLng.longitude}_${stopsKey}_$useTraffic';
  }

  Map<String, dynamic> _parseBounds(Map<String, dynamic> bounds) {
    return {
      'northeast': bounds['northeast'],
      'southwest': bounds['southwest'],
    };
  }

  List<Map<String, dynamic>> _parseSteps(List<dynamic> steps) {
    return steps.map((step) => {
      'distance': step['distance']['text'],
      'duration': step['duration']['text'],
      'instructions': step['html_instructions'],
      'maneuver': step['maneuver'] ?? '',
    }).toList();
  }

  Future<List<RouteCalculationResult>> _calculateAlternativeRoutes(FFPlace origin, FFPlace destination, List<FFPlace>? stops) async {
    // Implementar cálculo de rotas alternativas
    return [];
  }

  /// Limpar cache periodicamente
  void clearCache() {
    _routeCache.clear();
    _pricingCache.clear();
  }
}

/// Resultados das validações e cálculos
class EnhancedValidationResult {
  final bool isValid;
  final List<ValidationIssue> issues;
  final List<ValidationWarning> warnings;
  final RouteCalculationResult? routeData;
  final PricingResult? pricingData;
  final int? estimatedWaitTime;
  final List<RouteCalculationResult>? alternatives;

  EnhancedValidationResult({
    required this.isValid,
    required this.issues,
    required this.warnings,
    this.routeData,
    this.pricingData,
    this.estimatedWaitTime,
    this.alternatives,
  });

  bool get hasWarnings => warnings.isNotEmpty;
  double? get estimatedPrice => pricingData?.totalPrice;
  double? get estimatedDistance => routeData != null ? routeData!.distanceMeters / 1000 : null;
  int? get estimatedDuration => routeData?.durationSeconds != null ? routeData!.durationSeconds ~/ 60 : null;
}

class RouteCalculationResult {
  final bool success;
  final String? error;
  final int distanceMeters;
  final int durationSeconds;
  final int? durationInTrafficSeconds;
  final String polyline;
  final Map<String, dynamic> bounds;
  final List<Map<String, dynamic>> steps;
  final DateTime calculatedAt;

  RouteCalculationResult({
    required this.success,
    this.error,
    this.distanceMeters = 0,
    this.durationSeconds = 0,
    this.durationInTrafficSeconds,
    this.polyline = '',
    this.bounds = const {},
    this.steps = const [],
    DateTime? calculatedAt,
  }) : calculatedAt = calculatedAt ?? DateTime.now();
}

class PricingResult {
  final double basePrice;
  final double distancePrice;
  final double stopsPrice;
  final double trafficSurcharge;
  final double nightSurcharge;
  final double vehicleMultiplier;
  final double weatherSurcharge;
  final double demandMultiplier;
  final double totalPrice;
  final Map<String, dynamic> breakdown;
  final DateTime calculatedAt;

  PricingResult({
    required this.basePrice,
    required this.distancePrice,
    required this.stopsPrice,
    required this.trafficSurcharge,
    required this.nightSurcharge,
    required this.vehicleMultiplier,
    required this.weatherSurcharge,
    required this.demandMultiplier,
    required this.totalPrice,
    required this.breakdown,
    DateTime? calculatedAt,
  }) : calculatedAt = calculatedAt ?? DateTime.now();
}

class DriverAvailabilityResult {
  final bool hasDrivers;
  final int availableCount;
  final int estimatedWaitTime;

  DriverAvailabilityResult({
    required this.hasDrivers,
    required this.availableCount,
    required this.estimatedWaitTime,
  });
}

class BasicValidationResult {
  final bool isValid;
  final List<ValidationIssue> issues;
  final List<ValidationWarning> warnings;

  BasicValidationResult({
    required this.isValid,
    required this.issues,
    required this.warnings,
  });
}

// Usando definições compartilhadas de ValidationIssue/ValidationWarning de route_validator.dart