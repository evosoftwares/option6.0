import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'place.dart';
import 'lat_lng.dart';

/// Sistema Inteligente de Geolocalização
/// Fornece localização atual com fallbacks e cache
class LocationService {
  LocationService._();

  static LocationService? _instance;
  static LocationService get instance => _instance ??= LocationService._();

  static const String _lastLocationKey = 'last_known_location';
  static const String _locationTimestampKey = 'location_timestamp';
  static const int _locationExpiryMinutes = 30;

  /// Obtém a localização atual com fallbacks inteligentes
  Future<LatLng?> getCurrentLocation({
    bool useCache = true,
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) async {
    try {
      // 1. Verificar cache se solicitado
      if (useCache) {
        final cachedLocation = await _getCachedLocation();
        if (cachedLocation != null) {
          debugPrint('📍 Localização do cache: ${cachedLocation.latitude}, ${cachedLocation.longitude}');
          return cachedLocation;
        }
      }

      // 2. Verificar se o serviço de localização está habilitado
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('❌ Serviço de localização desabilitado');
        return await _getCachedLocation(); // Fallback para cache
      }

      // 3. Verificar permissões
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('❌ Permissão de localização negada');
          return await _getCachedLocation(); // Fallback para cache
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('❌ Permissão de localização negada permanentemente');
        return await _getCachedLocation(); // Fallback para cache
      }

      // 4. Obter localização atual
      debugPrint('🌍 Obtendo localização atual...');
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: Duration(seconds: 10), // Timeout para evitar travamento
      );

      final currentLocation = LatLng(position.latitude, position.longitude);

      // 5. Armazenar no cache
      await _cacheLocation(currentLocation);

      debugPrint('✅ Localização obtida: ${currentLocation.latitude}, ${currentLocation.longitude}');
      return currentLocation;

    } catch (e) {
      debugPrint('❌ Erro ao obter localização: $e');
      return await _getCachedLocation(); // Fallback para cache
    }
  }

  /// Converte coordenadas em endereço (Reverse Geocoding)
  Future<FFPlace?> getPlaceFromLocation(LatLng location) async {
    try {
      final key = dotenv.env['GOOGLE_MAPS_API_KEY'] ??
          dotenv.env['GOOGLE_PLACES_API_KEY'] ??
          '';
      if (key.isEmpty) {
        debugPrint('❌ Google API key não encontrada');
        return null;
      }

      debugPrint('🗺️ Fazendo reverse geocoding...');

      final uri = Uri.https(
        'maps.googleapis.com',
        '/maps/api/geocode/json',
        {
          'latlng': '${location.latitude},${location.longitude}',
          'key': key,
          'language': 'pt-BR',
          'result_type': 'street_address|route|neighborhood|locality',
        },
      );

      final response = await http.get(uri);
      if (response.statusCode != 200) {
        debugPrint('❌ Reverse Geocoding HTTP ${response.statusCode}');
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['status'] != 'OK' || data['results'] == null) {
        debugPrint('❌ Reverse Geocoding error: ${data['status']}');
        return null;
      }

      final results = data['results'] as List;
      if (results.isEmpty) {
        debugPrint('❌ Nenhum resultado do reverse geocoding');
        return null;
      }

      // Pegar o primeiro resultado (mais preciso)
      final result = results.first as Map<String, dynamic>;
      final formattedAddress = result['formatted_address'] as String? ?? '';

      String name = '';
      String city = '';
      String state = '';
      String country = '';
      String zipCode = '';
      String neighborhood = '';

      // Extrair componentes do endereço
      final components = (result['address_components'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      for (final component in components) {
        final types = (component['types'] as List?)?.cast<String>() ?? [];
        final longName = component['long_name'] as String? ?? '';
        final shortName = component['short_name'] as String? ?? '';

        if (types.contains('street_number')) {
          name = '$longName $name'.trim();
        } else if (types.contains('route')) {
          name = '$name $longName'.trim();
        } else if (types.contains('neighborhood')) {
          neighborhood = longName;
        } else if (types.contains('locality')) {
          city = longName;
        } else if (types.contains('administrative_area_level_1')) {
          state = shortName;
        } else if (types.contains('country')) {
          country = longName;
        } else if (types.contains('postal_code')) {
          zipCode = longName;
        }
      }

      // Se não conseguiu extrair nome da rua, usar endereço formatado
      if (name.isEmpty) {
        name = formattedAddress.split(',').first.trim();
      }

      final place = FFPlace(
        latLng: location,
        name: name.isNotEmpty ? name : 'Localização Atual',
        address: formattedAddress,
        city: city.isNotEmpty ? city : neighborhood,
        state: state,
        country: country,
        zipCode: zipCode,
      );

      debugPrint('✅ Reverse geocoding: ${place.name}');
      return place;

    } catch (e) {
      debugPrint('❌ Erro no reverse geocoding: $e');
      return FFPlace(
        latLng: location,
        name: 'Localização Atual',
        address: 'Lat: ${location.latitude.toStringAsFixed(6)}, Lng: ${location.longitude.toStringAsFixed(6)}',
        city: '',
        state: '',
        country: '',
        zipCode: '',
      );
    }
  }

  /// Obtém localização atual como FFPlace
  Future<FFPlace?> getCurrentPlace({
    bool useCache = true,
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) async {
    try {
      final location = await getCurrentLocation(
        useCache: useCache,
        accuracy: accuracy,
      );

      if (location == null) {
        debugPrint('❌ Não foi possível obter localização');
        return null;
      }

      return await getPlaceFromLocation(location);
    } catch (e) {
      debugPrint('❌ Erro ao obter place atual: $e');
      return null;
    }
  }

  /// Verifica se localização está disponível
  Future<bool> isLocationAvailable() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;

      LocationPermission permission = await Geolocator.checkPermission();
      return permission != LocationPermission.denied &&
             permission != LocationPermission.deniedForever;
    } catch (e) {
      debugPrint('❌ Erro ao verificar disponibilidade: $e');
      return false;
    }
  }

  /// Abre configurações de localização
  Future<void> openLocationSettings() async {
    try {
      await Geolocator.openLocationSettings();
    } catch (e) {
      debugPrint('❌ Erro ao abrir configurações: $e');
    }
  }

  /// Cache da localização
  Future<void> _cacheLocation(LatLng location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastLocationKey, '${location.latitude},${location.longitude}');
      await prefs.setInt(_locationTimestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      debugPrint('❌ Erro ao cachear localização: $e');
    }
  }

  /// Recupera localização do cache
  Future<LatLng?> _getCachedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationStr = prefs.getString(_lastLocationKey);
      final timestamp = prefs.getInt(_locationTimestampKey);

      if (locationStr == null || timestamp == null) {
        return null;
      }

      // Verificar se o cache não expirou
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      if (now.difference(cacheTime).inMinutes > _locationExpiryMinutes) {
        debugPrint('🕒 Cache de localização expirado');
        return null;
      }

      final coords = locationStr.split(',');
      if (coords.length != 2) return null;

      return LatLng(
        double.parse(coords[0]),
        double.parse(coords[1]),
      );
    } catch (e) {
      debugPrint('❌ Erro ao recuperar cache: $e');
      return null;
    }
  }

  /// Limpar cache de localização
  Future<void> clearLocationCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastLocationKey);
      await prefs.remove(_locationTimestampKey);
      debugPrint('🗑️ Cache de localização limpo');
    } catch (e) {
      debugPrint('❌ Erro ao limpar cache: $e');
    }
  }

  /// Calcular distância entre dois pontos
  double calculateDistance(LatLng from, LatLng to) {
    return Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    ) / 1000; // Retorna em km
  }
}