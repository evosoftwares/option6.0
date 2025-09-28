import 'dart:math';
import 'package:flutter/material.dart';
import '/backend/supabase/supabase.dart';
import '/backend/supabase/database/database.dart';
import '/auth/supabase_auth/auth_util.dart';
import 'place.dart';

// Tipos de sugestões
enum SuggestionType { recent, frequent, timePattern, nearby, favorite }

/// Sistema Inteligente de Sugestões
/// Aprende com o histórico de viagens para sugerir locais relevantes
class TripSuggestionsService {
  TripSuggestionsService._();

  static TripSuggestionsService? _instance;
  static TripSuggestionsService get instance => _instance ??= TripSuggestionsService._();

  // Cache das sugestões
  List<SuggestionItem>? _cachedSuggestions;
  DateTime? _lastCacheUpdate;
  static const int _cacheExpiryMinutes = 30;
  String? _appUserIdCache;
  String? _passengerIdCache;

  /// Obtém sugestões inteligentes para o usuário
  Future<List<SuggestionItem>> getSuggestions({
    String? context, // 'origem', 'destino', 'parada'
    LatLng? currentLocation,
    DateTime? currentTime,
    bool forceRefresh = false,
  }) async {
    try {
      // Verificar cache
      if (!forceRefresh && _isValidCache()) {
        debugPrint('🎯 Retornando sugestões do cache');
        return _cachedSuggestions!;
      }

      debugPrint('🧠 Gerando sugestões inteligentes...');

      final suggestions = <SuggestionItem>[];
      currentTime ??= DateTime.now();

      // 1. Locais recentes (últimas 2 semanas)
      final recentPlaces = await _getRecentPlaces();
      suggestions.addAll(recentPlaces);

      // 2. Locais frequentes (mais visitados)
      final frequentPlaces = await _getFrequentPlaces();
      suggestions.addAll(frequentPlaces);

      // 3. Padrões temporais (baseado no horário)
      final timeBasedPlaces = await _getTimeBasedSuggestions(currentTime);
      suggestions.addAll(timeBasedPlaces);

      // 4. Locais favoritos salvos
      final favoritePlaces = await _getFavoritePlaces();
      suggestions.addAll(favoritePlaces);

      // 5. POIs próximos (se temos localização atual)
      if (currentLocation != null) {
        final nearbyPOIs = await _getNearbyPOIs(currentLocation);
        suggestions.addAll(nearbyPOIs);
      }

      // 6. Remover duplicatas e ordenar por relevância
      final uniqueSuggestions = _deduplicateAndScore(suggestions, context, currentTime);

      // 6. Limitar a 8 sugestões para não poluir a UI
      final finalSuggestions = uniqueSuggestions.take(8).toList();

      // Atualizar cache
      _cachedSuggestions = finalSuggestions;
      _lastCacheUpdate = DateTime.now();

      debugPrint('✅ ${finalSuggestions.length} sugestões geradas');
      return finalSuggestions;

    } catch (e) {
      debugPrint('❌ Erro ao gerar sugestões: $e');
      return [];
    }
  }

  /// Busca locais recentes baseados no histórico de trips
  Future<List<SuggestionItem>> _getRecentPlaces() async {
    try {
      final twoWeeksAgo = DateTime.now().subtract(Duration(days: 14));

      final passengerId = await _getCurrentPassengerId();
      if (passengerId == null || passengerId.isEmpty) {
        debugPrint('⚠️ Sem passenger_id para buscar locais recentes.');
        return [];
      }

      final trips = await TripsTable().queryRows(
        queryFn: (q) => q
            .eq('passenger_id', passengerId)
            .gte('created_at', twoWeeksAgo.toIso8601String())
            .order('created_at', ascending: false)
            .limit(20),
      );

      final suggestions = <SuggestionItem>[];

      for (final trip in trips) {
        // Adicionar origem
        if (trip.originAddress != null &&
            trip.originLatitude != null &&
            trip.originLongitude != null) {
          suggestions.add(SuggestionItem(
            place: FFPlace(
              latLng: LatLng(trip.originLatitude!, trip.originLongitude!),
              name: _extractMainAddressPart(trip.originAddress!),
              address: trip.originAddress!,
              city: trip.originNeighborhood ?? '',
              state: '',
              country: '',
              zipCode: '',
            ),
            type: SuggestionType.recent,
            score: 0.8,
            subtitle: 'Usado recentemente',
            icon: Icons.history,
          ));
        }

        // Adicionar destino
        if (trip.destinationAddress != null &&
            trip.destinationLatitude != null &&
            trip.destinationLongitude != null) {
          suggestions.add(SuggestionItem(
            place: FFPlace(
              latLng: LatLng(trip.destinationLatitude!, trip.destinationLongitude!),
              name: _extractMainAddressPart(trip.destinationAddress!),
              address: trip.destinationAddress!,
              city: trip.destinationNeighborhood ?? '',
              state: '',
              country: '',
              zipCode: '',
            ),
            type: SuggestionType.recent,
            score: 0.8,
            subtitle: 'Usado recentemente',
            icon: Icons.history,
          ));
        }
      }

      return suggestions;
    } catch (e) {
      debugPrint('❌ Erro ao buscar locais recentes: $e');
      return [];
    }
  }

  /// Busca locais frequentes baseados na frequência de uso
  Future<List<SuggestionItem>> _getFrequentPlaces() async {
    try {
      final thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));

      final passengerId = await _getCurrentPassengerId();
      if (passengerId == null || passengerId.isEmpty) {
        debugPrint('⚠️ Sem passenger_id para buscar locais frequentes.');
        return [];
      }

      final trips = await TripsTable().queryRows(
        queryFn: (q) => q
            .eq('passenger_id', passengerId)
            .gte('created_at', thirtyDaysAgo.toIso8601String()),
      );

      // Mapear locais por endereço e contar frequência
      final addressFrequency = <String, LocationFrequency>{};

      for (final trip in trips) {
        _countLocationFrequency(addressFrequency, trip.originAddress,
            trip.originLatitude, trip.originLongitude, trip.originNeighborhood);
        _countLocationFrequency(addressFrequency, trip.destinationAddress,
            trip.destinationLatitude, trip.destinationLongitude, trip.destinationNeighborhood);
      }

      // Converter para sugestões
      final suggestions = <SuggestionItem>[];
      final sortedFrequencies = addressFrequency.values.toList()
        ..sort((a, b) => b.count.compareTo(a.count));

      for (final freq in sortedFrequencies.take(5)) {
        if (freq.count >= 3) { // Apenas locais usados 3+ vezes
          suggestions.add(SuggestionItem(
            place: FFPlace(
              latLng: LatLng(freq.latitude, freq.longitude),
              name: _extractMainAddressPart(freq.address),
              address: freq.address,
              city: freq.neighborhood,
              state: '',
              country: '',
              zipCode: '',
            ),
            type: SuggestionType.frequent,
            score: 0.9 + (freq.count * 0.01), // Mais frequente = maior score
            subtitle: 'Usado ${freq.count}x este mês',
            icon: Icons.favorite,
          ));
        }
      }

      return suggestions;
    } catch (e) {
      debugPrint('❌ Erro ao buscar locais frequentes: $e');
      return [];
    }
  }

  /// Sugestões baseadas em padrões temporais
  Future<List<SuggestionItem>> _getTimeBasedSuggestions(DateTime currentTime) async {
    try {
      final suggestions = <SuggestionItem>[];
      final hour = currentTime.hour;
      final isWeekday = currentTime.weekday <= 5;
      
      String timeContext = '';
      if (hour >= 6 && hour <= 10) {
        timeContext = 'manhã';
      } else if (hour >= 17 && hour <= 21) {
        timeContext = 'noite';
      }

      if (timeContext.isNotEmpty) {
        // Buscar viagens no mesmo período nas últimas 4 semanas
        final fourWeeksAgo = DateTime.now().subtract(Duration(days: 28));

        final passengerId = await _getCurrentPassengerId();
        if (passengerId == null || passengerId.isEmpty) {
          debugPrint('⚠️ Sem passenger_id para buscar padrões temporais.');
          return [];
        }

        final trips = await TripsTable().queryRows(
          queryFn: (q) => q
              .eq('passenger_id', passengerId)
              .gte('created_at', fourWeeksAgo.toIso8601String()),
        );

        final timePatterns = <String, int>{};

        for (final trip in trips) {
          if (trip.createdAt != null) {
            final tripTime = trip.createdAt!;
            final tripHour = tripTime.hour;
            final tripIsWeekday = tripTime.weekday <= 5;

            // Verificar se está no mesmo período
            bool sameTimePattern = false;
            if (timeContext == 'manhã' && tripHour >= 6 && tripHour <= 10) {
              sameTimePattern = true;
            } else if (timeContext == 'noite' && tripHour >= 17 && tripHour <= 21) {
              sameTimePattern = true;
            }

            if (sameTimePattern && tripIsWeekday == isWeekday) {
              // Contar destinos comuns neste horário
              if (trip.destinationAddress != null) {
                final key = trip.destinationAddress!;
                timePatterns[key] = (timePatterns[key] ?? 0) + 1;
              }
            }
          }
        }

        // Adicionar sugestões baseadas em padrões
        for (final entry in timePatterns.entries) {
          if (entry.value >= 2) { // Usado 2+ vezes neste horário
            // Buscar dados completos do local
            final matchingTrip = trips.firstWhere(
              (trip) => trip.destinationAddress == entry.key,
              orElse: () => trips.first,
            );

            if (matchingTrip.destinationLatitude != null &&
                matchingTrip.destinationLongitude != null) {
              suggestions.add(SuggestionItem(
                place: FFPlace(
                  latLng: LatLng(matchingTrip.destinationLatitude!,
                                matchingTrip.destinationLongitude!),
                  name: _extractMainAddressPart(entry.key),
                  address: entry.key,
                  city: matchingTrip.destinationNeighborhood ?? '',
                  state: '',
                  country: '',
                  zipCode: '',
                ),
                type: SuggestionType.timePattern,
                score: 0.85,
                subtitle: 'Comum pela $timeContext',
                icon: timeContext == 'manhã' ? Icons.wb_sunny : Icons.nightlight_round,
              ));
            }
          }
        }
      }

      return suggestions;
    } catch (e) {
      debugPrint('❌ Erro ao buscar padrões temporais: $e');
      return [];
    }
  }

  /// Busca locais favoritos salvos pelo usuário
  Future<List<SuggestionItem>> _getFavoritePlaces() async {
    try {
      final appUserId = await _getCurrentAppUserId();
      if (appUserId == null || appUserId.isEmpty) {
        debugPrint('⚠️ Sem app_user.id para buscar favoritos.');
        return [];
      }

      final savedPlaces = await SavedPlacesTable().queryRows(
        queryFn: (q) => q
            .eq('user_id', appUserId)
            .order('created_at', ascending: false)
            .limit(10),
      );

      final suggestions = <SuggestionItem>[];

      for (final place in savedPlaces) {
        if (place.address != null &&
            place.latitude != null &&
            place.longitude != null) {
          suggestions.add(SuggestionItem(
            place: FFPlace(
              latLng: LatLng(place.latitude!, place.longitude!),
              name: place.label ?? _extractMainAddressPart(place.address!),
              address: place.address!,
              city: '',
              state: '',
              country: '',
              zipCode: '',
            ),
            type: SuggestionType.favorite,
            score: 0.95, // Score alto para favoritos
            subtitle: 'Local salvo',
            icon: Icons.favorite,
          ));
        }
      }

      return suggestions;
    } catch (e) {
      debugPrint('❌ Erro ao buscar favoritos: $e');
      return [];
    }
  }

  /// Remove duplicatas e aplica scoring inteligente
  List<SuggestionItem> _deduplicateAndScore(
    List<SuggestionItem> suggestions,
    String? context,
    DateTime currentTime,
  ) {
    // Agrupar por coordenadas similares (raio de 100m)
    final uniqueMap = <String, SuggestionItem>{};

    for (final suggestion in suggestions) {
      final key = _getLocationKey(suggestion.place.latLng);

      if (uniqueMap.containsKey(key)) {
        // Manter o com maior score
        if (suggestion.score > uniqueMap[key]!.score) {
          uniqueMap[key] = suggestion;
        }
      } else {
        uniqueMap[key] = suggestion;
      }
    }

    // Aplicar boost baseado no contexto e hora
    final uniqueList = uniqueMap.values.toList();
    for (final suggestion in uniqueList) {
      // Boost para sugestões relevantes ao contexto
      if (context == 'origem' && suggestion.type == SuggestionType.timePattern) {
        suggestion.score += 0.1;
      }
      if (context == 'destino' && suggestion.type == SuggestionType.frequent) {
        suggestion.score += 0.1;
      }
    }

    // Ordenar por score
    uniqueList.sort((a, b) => b.score.compareTo(a.score));
    return uniqueList;
  }

  /// Auxiliares
  void _countLocationFrequency(
    Map<String, LocationFrequency> frequencyMap,
    String? address,
    double? lat,
    double? lng,
    String? neighborhood,
  ) {
    if (address != null && lat != null && lng != null) {
      if (frequencyMap.containsKey(address)) {
        frequencyMap[address]!.count++;
      } else {
        frequencyMap[address] = LocationFrequency(
          address: address,
          latitude: lat,
          longitude: lng,
          neighborhood: neighborhood ?? '',
          count: 1,
        );
      }
    }
  }

  String _extractMainAddressPart(String fullAddress) {
    // Extrair parte principal do endereço
    final parts = fullAddress.split(',');
    if (parts.isNotEmpty) {
      return parts.first.trim();
    }
    return fullAddress;
  }

  String _getLocationKey(LatLng location) {
    // Gerar chave baseada em coordenadas arredondadas (raio ~100m)
    final latRounded = (location.latitude * 1000).round() / 1000;
    final lngRounded = (location.longitude * 1000).round() / 1000;
    return '${latRounded}_${lngRounded}';
  }

  bool _isValidCache() {
    return _cachedSuggestions != null &&
           _lastCacheUpdate != null &&
           DateTime.now().difference(_lastCacheUpdate!).inMinutes < _cacheExpiryMinutes;
  }

  // Helpers para mapear o usuário atual para app_users.id e passengers.id
  Future<String?> _getCurrentAppUserId() async {
    if (_appUserIdCache != null) return _appUserIdCache;
    try {
      // Buscar por fcm_token (mapeado ao Firebase UID)
      final byFcm = await AppUsersTable().queryRows(
        queryFn: (q) => q.eq('fcm_token', currentUserUid).limit(1),
      );
      if (byFcm.isNotEmpty) {
        _appUserIdCache = byFcm.first.id;
        return _appUserIdCache;
      }

      // Fallback para email
      final byEmail = await AppUsersTable().queryRows(
        queryFn: (q) => q.eq('email', currentUserEmail).limit(1),
      );
      if (byEmail.isNotEmpty) {
        _appUserIdCache = byEmail.first.id;
        return _appUserIdCache;
      }
    } catch (e) {
      debugPrint('❌ Erro ao obter app_user.id: $e');
    }
    return null;
  }

  Future<String?> _getCurrentPassengerId() async {
    if (_passengerIdCache != null) return _passengerIdCache;
    try {
      final appUserId = await _getCurrentAppUserId();
      if (appUserId == null || appUserId.isEmpty) return null;

      final passengers = await PassengersTable().queryRows(
        queryFn: (q) => q.eq('user_id', appUserId).limit(1),
      );
      if (passengers.isNotEmpty) {
        _passengerIdCache = passengers.first.id;
        return _passengerIdCache;
      }
    } catch (e) {
      debugPrint('❌ Erro ao obter passenger.id: $e');
    }
    return null;
  }

  /// Salva um local como favorito
  Future<bool> savePlaceAsFavorite(FFPlace place, {String? customLabel}) async {
    try {
      final label = customLabel ?? place.name;

      final appUserId = await _getCurrentAppUserId();
      if (appUserId == null || appUserId.isEmpty) {
        debugPrint('⚠️ Não foi possível salvar favorito: app_user.id ausente.');
        return false;
      }

      await SavedPlacesTable().insert({
        'user_id': appUserId,
        'label': label,
        'address': place.address,
        'latitude': place.latLng.latitude,
        'longitude': place.latLng.longitude,
        'category': 'favorite',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Limpar cache para recarregar com novo favorito
      clearCache();

      debugPrint('⭐ Local salvo como favorito: $label');
      return true;
    } catch (e) {
      debugPrint('❌ Erro ao salvar favorito: $e');
      return false;
    }
  }

  /// Remove um local dos favoritos
  Future<bool> removePlaceFromFavorites(FFPlace place) async {
    try {
      final appUserId = await _getCurrentAppUserId();
      if (appUserId == null || appUserId.isEmpty) {
        debugPrint('⚠️ Não foi possível remover favorito: app_user.id ausente.');
        return false;
      }

      await SavedPlacesTable().delete(
        matchingRows: (rows) => rows
            .eq('user_id', appUserId)
            .eq('address', place.address),
      );

      // Limpar cache para recarregar sem o favorito removido
      clearCache();

      debugPrint('🗑️ Local removido dos favoritos: ${place.name}');
      return true;
    } catch (e) {
      debugPrint('❌ Erro ao remover favorito: $e');
      return false;
    }
  }

  /// Verifica se um local é favorito
  Future<bool> isPlaceFavorite(FFPlace place) async {
    try {
      final appUserId = await _getCurrentAppUserId();
      if (appUserId == null || appUserId.isEmpty) {
        return false;
      }

      final result = await SavedPlacesTable().queryRows(
        queryFn: (q) => q
            .eq('user_id', appUserId)
            .eq('address', place.address)
            .limit(1),
      );

      return result.isNotEmpty;
    } catch (e) {
      debugPrint('❌ Erro ao verificar favorito: $e');
      return false;
    }
  }

  /// Salva uma parada temporária (pré-solicitação) em saved_places usando a categoria 'temp_stop'
  Future<bool> saveTemporaryStop(FFPlace place, {String? customLabel}) async {
    try {
      final appUserId = await _getCurrentAppUserId();
      if (appUserId == null || appUserId.isEmpty) {
        debugPrint('⚠️ Não foi possível salvar parada temporária: app_user.id ausente.');
        return false;
      }

      final label = (customLabel != null && customLabel.trim().isNotEmpty)
          ? customLabel
          : (place.name.isNotEmpty ? place.name : 'Parada');

      await SavedPlacesTable().insert({
        'user_id': appUserId,
        'label': label,
        'address': place.address,
        'latitude': place.latLng.latitude,
        'longitude': place.latLng.longitude,
        'category': 'temp_stop',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      debugPrint('📝 Parada temporária salva: $label');
      return true;
    } catch (e) {
      debugPrint('❌ Erro ao salvar parada temporária: $e');
      return false;
    }
  }

  /// Remove uma parada temporária em saved_places usando address como chave de correspondência
  Future<bool> removeTemporaryStop(FFPlace place) async {
    try {
      final appUserId = await _getCurrentAppUserId();
      if (appUserId == null || appUserId.isEmpty) {
        debugPrint('⚠️ Não foi possível remover parada temporária: app_user.id ausente.');
        return false;
      }

      await SavedPlacesTable().delete(
        matchingRows: (rows) => rows
            .eq('user_id', appUserId)
            .eq('category', 'temp_stop')
            .eq('address', place.address),
      );

      debugPrint('🗑️ Parada temporária removida: ${place.name}');
      return true;
    } catch (e) {
      debugPrint('❌ Erro ao remover parada temporária: $e');
      return false;
    }
  }

  /// Busca POIs próximos baseado na localização atual
  Future<List<SuggestionItem>> _getNearbyPOIs(LatLng userLocation) async {
    try {
      // POIs populares pré-definidos por categoria
      final poiCategories = {
        'shopping': {
          'keywords': ['shopping', 'mall', 'centro comercial', 'loja'],
          'icon': Icons.shopping_bag,
          'subtitle': 'Shopping e comércio',
        },
        'food': {
          'keywords': ['restaurante', 'lanchonete', 'pizzaria', 'hamburguer', 'fast food'],
          'icon': Icons.restaurant,
          'subtitle': 'Restaurantes e alimentação',
        },
        'health': {
          'keywords': ['hospital', 'farmácia', 'clínica', 'posto de saúde'],
          'icon': Icons.local_hospital,
          'subtitle': 'Saúde e bem-estar',
        },
        'education': {
          'keywords': ['escola', 'universidade', 'faculdade', 'colégio'],
          'icon': Icons.school,
          'subtitle': 'Educação',
        },
        'transport': {
          'keywords': ['aeroporto', 'rodoviária', 'estação', 'terminal'],
          'icon': Icons.directions_bus,
          'subtitle': 'Transporte público',
        },
        'entertainment': {
          'keywords': ['cinema', 'teatro', 'parque', 'museu'],
          'icon': Icons.movie,
          'subtitle': 'Entretenimento',
        },
      };

      final suggestions = <SuggestionItem>[];

      // Buscar POIs em um raio de aproximadamente 5km
      final latRange = 0.045; // ~5km em graus de latitude
      final lngRange = 0.045; // ~5km em graus de longitude

      // Simular busca de POIs próximos conhecidos (em um app real, isto viria de uma API)
      final nearbyPOIs = await _getCommonPOIsNearLocation(
        userLocation,
        latRange,
        lngRange,
      );

      for (final poi in nearbyPOIs) {
        // Determinar categoria baseada no nome/tipo
        IconData icon = Icons.place;
        String subtitle = 'Ponto de interesse';

        for (final entry in poiCategories.entries) {
          final keywords = entry.value['keywords'] as List<String>;
          if (keywords.any((keyword) => poi['name'].toString().toLowerCase().contains(keyword))) {
            icon = entry.value['icon'] as IconData;
            subtitle = entry.value['subtitle'] as String;
            break;
          }
        }

        // Calcular distância aproximada
        final distance = _calculateDistance(
          userLocation.latitude,
          userLocation.longitude,
          poi['latitude'] as double,
          poi['longitude'] as double,
        );

        // Criar place
        final place = FFPlace(
          latLng: LatLng(poi['latitude'] as double, poi['longitude'] as double),
          name: poi['name'] as String,
          address: poi['address'] as String,
          city: poi['city'] as String,
          state: poi['state'] as String,
          country: poi['country'] as String,
          zipCode: poi['zipcode'] as String? ?? '',
        );

        // Score baseado na distância e popularidade
        final score = _calculatePOIScore(distance, poi['popularity'] as double);

        final suggestionItem = SuggestionItem(
          place: place,
          type: SuggestionType.nearby,
          score: score,
          subtitle: '$subtitle • ${distance.toStringAsFixed(1)}km',
          icon: icon,
        );

        suggestions.add(suggestionItem);
      }

      // Ordenar por score (distância + popularidade)
      suggestions.sort((a, b) => b.score.compareTo(a.score));

      debugPrint('🗺️ ${suggestions.length} POIs próximos encontrados');
      return suggestions.take(3).toList(); // Limitar a 3 POIs para não sobrecarregar

    } catch (e) {
      debugPrint('❌ Erro ao buscar POIs próximos: $e');
      return [];
    }
  }

  /// Simula busca de POIs próximos (em produção, usar Google Places Nearby API)
  Future<List<Map<String, dynamic>>> _getCommonPOIsNearLocation(
    LatLng userLocation,
    double latRange,
    double lngRange,
  ) async {
    // Simular dados de POIs populares (em produção, vir de API)
    final commonPOIs = [
      {
        'name': 'Shopping Center Norte',
        'latitude': userLocation.latitude + (latRange * 0.3),
        'longitude': userLocation.longitude + (lngRange * 0.2),
        'address': 'Av. Tucuruvi, 808 - Vila Guilherme',
        'city': 'São Paulo',
        'state': 'SP',
        'country': 'BR',
        'zipcode': '02304-000',
        'popularity': 0.9,
      },
      {
        'name': 'Hospital Sírio-Libanês',
        'latitude': userLocation.latitude - (latRange * 0.4),
        'longitude': userLocation.longitude + (lngRange * 0.1),
        'address': 'R. Dona Adma Jafet, 91 - Bela Vista',
        'city': 'São Paulo',
        'state': 'SP',
        'country': 'BR',
        'zipcode': '01308-050',
        'popularity': 0.8,
      },
      {
        'name': 'Aeroporto Internacional de Guarulhos',
        'latitude': userLocation.latitude + (latRange * 0.8),
        'longitude': userLocation.longitude - (lngRange * 0.6),
        'address': 'Rod. Hélio Smidt, s/n - Cumbica',
        'city': 'Guarulhos',
        'state': 'SP',
        'country': 'BR',
        'zipcode': '07190-100',
        'popularity': 0.95,
      },
    ];

    return commonPOIs;
  }

  /// Calcula distância entre dois pontos em km
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Raio da Terra em km

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
         sin(dLon / 2) * sin(dLon / 2));

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Converte graus para radianos
  double _toRadians(double degrees) {
    return degrees * (pi / 180);
  }

  /// Calcula score do POI baseado em distância e popularidade
  double _calculatePOIScore(double distance, double popularity) {
    // Score inversamente proporcional à distância
    final distanceScore = 1.0 / (1.0 + distance);

    // Combinar com popularidade
    return (distanceScore * 0.7) + (popularity * 0.3);
  }

  /// Limpar cache
  void clearCache() {
    _cachedSuggestions = null;
    _lastCacheUpdate = null;
    _appUserIdCache = null;
    _passengerIdCache = null;
    debugPrint('🗑️ Cache de sugestões limpo');
  }
}

/// Item de sugestão
class SuggestionItem {
  final FFPlace place;
  final SuggestionType type;
  double score;
  final String subtitle;
  final IconData icon;

  SuggestionItem({
    required this.place,
    required this.type,
    required this.score,
    required this.subtitle,
    required this.icon,
  });
}

/// Auxiliar para contar frequência de locais
class LocationFrequency {
  final String address;
  final double latitude;
  final double longitude;
  final String neighborhood;
  int count;

  LocationFrequency({
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.neighborhood,
    required this.count,
  });
}