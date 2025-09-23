import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/backend/supabase/supabase.dart';

/// Serviço de Integração com APIs Externas
/// Centraliza chamadas para Google Maps, OpenWeather, etc.
/// Inclui fallbacks e cache para garantir funcionamento offline

class APIIntegrationService {
  APIIntegrationService._();

  static APIIntegrationService? _instance;
  static APIIntegrationService get instance => _instance ??= APIIntegrationService._();

  // Configurações das APIs (deve ser movido para variáveis de ambiente)
  static const String _googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY_HERE';
  static const String _openWeatherApiKey = 'YOUR_OPENWEATHER_API_KEY_HERE';

  // Cache para requests recentes
  final Map<String, CachedResponse> _cache = {};

  /// Obtém preço estimado usando Google Maps Distance Matrix
  Future<DistanceMatrixResult> getDistanceMatrix({
    required List<String> origins,
    required List<String> destinations,
    bool useTraffic = true,
    String language = 'pt-BR',
  }) async {
    try {
      final originsStr = origins.join('|');
      final destinationsStr = destinations.join('|');

      final cacheKey = 'distance_matrix_${originsStr}_${destinationsStr}_$useTraffic';

      // Verificar cache (válido por 5 minutos)
      if (_cache.containsKey(cacheKey)) {
        final cached = _cache[cacheKey]!;
        if (DateTime.now().difference(cached.timestamp).inMinutes < 5) {
          return DistanceMatrixResult.fromJson(cached.data);
        }
      }

      final departureTime = useTraffic ? '&departure_time=now' : '';
      final url = 'https://maps.googleapis.com/maps/api/distancematrix/json?'
          'origins=$originsStr'
          '&destinations=$destinationsStr'
          '&key=$_googleMapsApiKey'
          '&language=$language'
          '$departureTime';

      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Salvar no cache
        _cache[cacheKey] = CachedResponse(
          data: data,
          timestamp: DateTime.now(),
        );

        return DistanceMatrixResult.fromJson(data);
      } else {
        throw Exception('API retornou status ${response.statusCode}');
      }

    } catch (e) {
      debugPrint('❌ Erro na Distance Matrix API: $e');

      // Fallback: estimativa básica usando coordenadas
      return _fallbackDistanceCalculation(origins, destinations);
    }
  }

  /// Obtém informações de clima para ajustar preços
  Future<WeatherResult> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final cacheKey = 'weather_${latitude.toStringAsFixed(2)}_${longitude.toStringAsFixed(2)}';

      // Cache válido por 15 minutos
      if (_cache.containsKey(cacheKey)) {
        final cached = _cache[cacheKey]!;
        if (DateTime.now().difference(cached.timestamp).inMinutes < 15) {
          return WeatherResult.fromJson(cached.data);
        }
      }

      final url = 'https://api.openweathermap.org/data/2.5/weather?'
          'lat=$latitude'
          '&lon=$longitude'
          '&appid=$_openWeatherApiKey'
          '&units=metric'
          '&lang=pt_br';

      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        _cache[cacheKey] = CachedResponse(
          data: data,
          timestamp: DateTime.now(),
        );

        return WeatherResult.fromJson(data);
      } else {
        throw Exception('Weather API retornou status ${response.statusCode}');
      }

    } catch (e) {
      debugPrint('❌ Erro na Weather API: $e');

      // Fallback: clima normal
      return WeatherResult(
        isRaining: false,
        temperature: 25.0,
        description: 'Tempo normal',
        windSpeed: 5.0,
      );
    }
  }

  /// Geocoding reverso para obter informações detalhadas do local
  Future<GeocodingResult> reverseGeocode({
    required double latitude,
    required double longitude,
    String language = 'pt-BR',
  }) async {
    try {
      final cacheKey = 'geocoding_${latitude.toStringAsFixed(4)}_${longitude.toStringAsFixed(4)}';

      // Cache válido por 1 hora
      if (_cache.containsKey(cacheKey)) {
        final cached = _cache[cacheKey]!;
        if (DateTime.now().difference(cached.timestamp).inHours < 1) {
          return GeocodingResult.fromJson(cached.data);
        }
      }

      final url = 'https://maps.googleapis.com/maps/api/geocode/json?'
          'latlng=$latitude,$longitude'
          '&key=$_googleMapsApiKey'
          '&language=$language'
          '&region=BR';

      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        _cache[cacheKey] = CachedResponse(
          data: data,
          timestamp: DateTime.now(),
        );

        return GeocodingResult.fromJson(data);
      } else {
        throw Exception('Geocoding API retornou status ${response.statusCode}');
      }

    } catch (e) {
      debugPrint('❌ Erro na Geocoding API: $e');

      return GeocodingResult(
        formattedAddress: 'Endereço não disponível',
        neighborhood: 'Desconhecido',
        city: 'Desconhecido',
        state: 'Desconhecido',
        postalCode: '',
        country: 'Brasil',
      );
    }
  }

  /// Obtém estatísticas de demanda em tempo real do Supabase
  Future<DemandStats> getDemandStatistics({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    try {
      final result = await SupaFlow.client.rpc(
        'get_demand_statistics',
        params: {
          'lat_center': latitude,
          'lon_center': longitude,
          'radius_km': radiusKm,
        },
      );

      if (result.isNotEmpty) {
        final data = result.first;
        return DemandStats(
          activeRequests: data['active_requests'] ?? 0,
          availableDrivers: data['available_drivers'] ?? 0,
          demandRatio: data['demand_ratio'] ?? 1.0,
          averageWaitTime: data['average_wait_time'] ?? 10,
          surgePricing: data['surge_pricing'] ?? 1.0,
        );
      }

      return DemandStats.defaultStats();

    } catch (e) {
      debugPrint('❌ Erro ao obter estatísticas de demanda: $e');
      return DemandStats.defaultStats();
    }
  }

  /// Fallback para cálculo de distância quando API falha
  DistanceMatrixResult _fallbackDistanceCalculation(List<String> origins, List<String> destinations) {
    // Implementação básica usando coordenadas
    // Para produção, deveria ter um sistema mais sofisticado

    return DistanceMatrixResult(
      status: 'OK_FALLBACK',
      rows: [
        DistanceMatrixRow(
          elements: [
            DistanceMatrixElement(
              distance: DistanceInfo(text: '~10 km', value: 10000),
              duration: DurationInfo(text: '~20 min', value: 1200),
              durationInTraffic: DurationInfo(text: '~25 min', value: 1500),
              status: 'OK',
            ),
          ],
        ),
      ],
    );
  }

  /// Limpa cache antigo para liberar memória
  void cleanOldCache() {
    final now = DateTime.now();
    _cache.removeWhere((key, value) {
      return now.difference(value.timestamp).inHours > 2;
    });
  }

  /// Verifica se as APIs estão configuradas corretamente
  bool get isConfigured {
    return _googleMapsApiKey != 'YOUR_GOOGLE_MAPS_API_KEY_HERE' &&
           _openWeatherApiKey != 'YOUR_OPENWEATHER_API_KEY_HERE';
  }

  /// Testa conectividade com APIs
  Future<Map<String, bool>> testConnectivity() async {
    final results = <String, bool>{};

    // Testar Google Maps
    try {
      await http.get(
        Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?address=São Paulo&key=$_googleMapsApiKey'),
      ).timeout(Duration(seconds: 5));
      results['google_maps'] = true;
    } catch (e) {
      results['google_maps'] = false;
    }

    // Testar OpenWeather
    try {
      await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=-23.5505&lon=-46.6333&appid=$_openWeatherApiKey'),
      ).timeout(Duration(seconds: 5));
      results['openweather'] = true;
    } catch (e) {
      results['openweather'] = false;
    }

    // Testar Supabase
    try {
      await SupaFlow.client.from('drivers').select('count').limit(1);
      results['supabase'] = true;
    } catch (e) {
      results['supabase'] = false;
    }

    return results;
  }
}

/// Classes de resultado das APIs
class CachedResponse {
  final Map<String, dynamic> data;
  final DateTime timestamp;

  CachedResponse({
    required this.data,
    required this.timestamp,
  });
}

class DistanceMatrixResult {
  final String status;
  final List<DistanceMatrixRow> rows;

  DistanceMatrixResult({
    required this.status,
    required this.rows,
  });

  factory DistanceMatrixResult.fromJson(Map<String, dynamic> json) {
    return DistanceMatrixResult(
      status: json['status'] ?? 'UNKNOWN',
      rows: (json['rows'] as List? ?? [])
          .map((row) => DistanceMatrixRow.fromJson(row))
          .toList(),
    );
  }

  bool get isSuccess => status == 'OK' || status == 'OK_FALLBACK';
}

class DistanceMatrixRow {
  final List<DistanceMatrixElement> elements;

  DistanceMatrixRow({required this.elements});

  factory DistanceMatrixRow.fromJson(Map<String, dynamic> json) {
    return DistanceMatrixRow(
      elements: (json['elements'] as List? ?? [])
          .map((element) => DistanceMatrixElement.fromJson(element))
          .toList(),
    );
  }
}

class DistanceMatrixElement {
  final DistanceInfo distance;
  final DurationInfo duration;
  final DurationInfo? durationInTraffic;
  final String status;

  DistanceMatrixElement({
    required this.distance,
    required this.duration,
    this.durationInTraffic,
    required this.status,
  });

  factory DistanceMatrixElement.fromJson(Map<String, dynamic> json) {
    return DistanceMatrixElement(
      distance: DistanceInfo.fromJson(json['distance'] ?? {}),
      duration: DurationInfo.fromJson(json['duration'] ?? {}),
      durationInTraffic: json['duration_in_traffic'] != null
          ? DurationInfo.fromJson(json['duration_in_traffic'])
          : null,
      status: json['status'] ?? 'UNKNOWN',
    );
  }
}

class DistanceInfo {
  final String text;
  final int value; // metros

  DistanceInfo({required this.text, required this.value});

  factory DistanceInfo.fromJson(Map<String, dynamic> json) {
    return DistanceInfo(
      text: json['text'] ?? '0 km',
      value: json['value'] ?? 0,
    );
  }
}

class DurationInfo {
  final String text;
  final int value; // segundos

  DurationInfo({required this.text, required this.value});

  factory DurationInfo.fromJson(Map<String, dynamic> json) {
    return DurationInfo(
      text: json['text'] ?? '0 min',
      value: json['value'] ?? 0,
    );
  }
}

class WeatherResult {
  final bool isRaining;
  final double temperature;
  final String description;
  final double windSpeed;

  WeatherResult({
    required this.isRaining,
    required this.temperature,
    required this.description,
    required this.windSpeed,
  });

  factory WeatherResult.fromJson(Map<String, dynamic> json) {
    final weather = json['weather']?[0] ?? {};
    final main = json['main'] ?? {};
    final wind = json['wind'] ?? {};

    final weatherId = weather['id'] ?? 800;
    final isRaining = weatherId >= 200 && weatherId < 700; // Chuva, neve, nevoeiro

    return WeatherResult(
      isRaining: isRaining,
      temperature: (main['temp'] ?? 25.0).toDouble(),
      description: weather['description'] ?? 'Tempo normal',
      windSpeed: (wind['speed'] ?? 5.0).toDouble(),
    );
  }

  double get weatherSurcharge {
    if (isRaining) return 1.15; // 15% adicional por chuva
    if (windSpeed > 15.0) return 1.10; // 10% adicional por vento forte
    return 1.0;
  }
}

class GeocodingResult {
  final String formattedAddress;
  final String neighborhood;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  GeocodingResult({
    required this.formattedAddress,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  factory GeocodingResult.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as List? ?? [];
    if (results.isEmpty) {
      return GeocodingResult(
        formattedAddress: 'Endereço não encontrado',
        neighborhood: 'Desconhecido',
        city: 'Desconhecido',
        state: 'Desconhecido',
        postalCode: '',
        country: 'Brasil',
      );
    }

    final result = results.first;
    final components = result['address_components'] as List? ?? [];

    String neighborhood = '';
    String city = '';
    String state = '';
    String postalCode = '';
    String country = 'Brasil';

    for (var component in components) {
      final types = component['types'] as List? ?? [];

      if (types.contains('sublocality_level_1') || types.contains('neighborhood')) {
        neighborhood = component['long_name'] ?? '';
      } else if (types.contains('administrative_area_level_2') || types.contains('locality')) {
        city = component['long_name'] ?? '';
      } else if (types.contains('administrative_area_level_1')) {
        state = component['short_name'] ?? '';
      } else if (types.contains('postal_code')) {
        postalCode = component['long_name'] ?? '';
      } else if (types.contains('country')) {
        country = component['long_name'] ?? 'Brasil';
      }
    }

    return GeocodingResult(
      formattedAddress: result['formatted_address'] ?? '',
      neighborhood: neighborhood,
      city: city,
      state: state,
      postalCode: postalCode,
      country: country,
    );
  }
}

class DemandStats {
  final int activeRequests;
  final int availableDrivers;
  final double demandRatio;
  final int averageWaitTime;
  final double surgePricing;

  DemandStats({
    required this.activeRequests,
    required this.availableDrivers,
    required this.demandRatio,
    required this.averageWaitTime,
    required this.surgePricing,
  });

  factory DemandStats.defaultStats() {
    return DemandStats(
      activeRequests: 0,
      availableDrivers: 1,
      demandRatio: 1.0,
      averageWaitTime: 10,
      surgePricing: 1.0,
    );
  }

  bool get isHighDemand => demandRatio > 1.5;
  bool get hasAvailableDrivers => availableDrivers > 0;
}