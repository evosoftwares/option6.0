import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'place.dart';
import 'lat_lng.dart';
import 'trip_suggestions_service.dart';

/// Sistema Avançado de Auto-complete
/// Categoriza, rankeia e enriquece resultados de busca
class AdvancedAutocomplete {
  AdvancedAutocomplete._();

  static AdvancedAutocomplete? _instance;
  static AdvancedAutocomplete get instance => _instance ??= AdvancedAutocomplete._();

  /// Processa e enriquece resultados de autocomplete
  Future<List<EnhancedResult>> processResults({
    required List<dynamic> rawResults,
    required String query,
    LatLng? userLocation,
    String? context, // 'origem', 'destino', 'parada'
  }) async {
    try {
      final enhancedResults = <EnhancedResult>[];

      // 1. Converter resultados brutos para objetos enriquecidos
      for (final result in rawResults) {
        final enhanced = await _enhanceResult(result, userLocation);
        if (enhanced != null) {
          enhancedResults.add(enhanced);
        }
      }

      // 2. Aplicar categorização
      final categorizedResults = _categorizeResults(enhancedResults);

      // 3. Aplicar ranking inteligente
      final rankedResults = _rankResults(categorizedResults, query, userLocation, context);

      // 4. Adicionar sugestões contextuais se necessário
      if (rankedResults.length < 5) {
        final suggestions = await _getContextualSuggestions(query, context, userLocation);
        rankedResults.addAll(suggestions);
      }

      // 5. Limitar resultados e garantir diversidade
      final finalResults = _ensureDiversity(rankedResults, maxResults: 8);

      debugPrint('🚀 Auto-complete avançado: ${finalResults.length} resultados processados');
      return finalResults;

    } catch (e) {
      debugPrint('❌ Erro no auto-complete avançado: $e');
      return [];
    }
  }

  /// Enriquece um resultado individual com metadados
  Future<EnhancedResult?> _enhanceResult(dynamic rawResult, LatLng? userLocation) async {
    try {
      // Extrair informações básicas do resultado
      final description = rawResult['description'] ?? '';
      final placeId = rawResult['place_id'] ?? '';
      final types = List<String>.from(rawResult['types'] ?? []);

      if (description.isEmpty || placeId.isEmpty) return null;

      // Determinar categoria baseada nos types
      final category = _determineCategory(types, description);

      // Calcular distância se localização disponível
      double? distance;
      String? distanceText;
      if (userLocation != null && rawResult['geometry'] != null) {
        final lat = rawResult['geometry']['location']['lat']?.toDouble();
        final lng = rawResult['geometry']['location']['lng']?.toDouble();

        if (lat != null && lng != null) {
          distance = Geolocator.distanceBetween(
            userLocation.latitude, userLocation.longitude,
            lat, lng,
          ) / 1000; // em km

          distanceText = distance < 1.0
              ? '${(distance * 1000).round()}m'
              : '${distance.toStringAsFixed(1)}km';
        }
      }

      // Extrair endereço estruturado
      final structuredFormatting = rawResult['structured_formatting'] ?? {};
      final mainText = structuredFormatting['main_text'] ?? description;
      final secondaryText = structuredFormatting['secondary_text'] ?? '';

      return EnhancedResult(
        placeId: placeId,
        description: description,
        mainText: mainText,
        secondaryText: secondaryText,
        category: category,
        types: types,
        distance: distance,
        distanceText: distanceText,
        relevanceScore: 0.0, // Será calculado no ranking
        icon: _getIconForCategory(category),
        isRecent: false, // Será determinado posteriormente
        isFavorite: false, // Seria carregado de favoritos salvos
      );

    } catch (e) {
      debugPrint('❌ Erro ao enriquecer resultado: $e');
      return null;
    }
  }

  /// Determina categoria baseada nos types do Google Places
  ResultCategory _determineCategory(List<String> types, String description) {
    // Residencial
    if (types.any((type) => ['street_address', 'premise', 'subpremise'].contains(type))) {
      return ResultCategory.residential;
    }

    // Empresas/Comércio
    if (types.any((type) => [
      'store', 'restaurant', 'shopping_mall', 'gas_station',
      'bank', 'hospital', 'pharmacy', 'supermarket'
    ].contains(type))) {
      return ResultCategory.business;
    }

    // Pontos turísticos/Marcos
    if (types.any((type) => [
      'tourist_attraction', 'park', 'museum', 'church',
      'stadium', 'university', 'school'
    ].contains(type))) {
      return ResultCategory.landmark;
    }

    // Transporte
    if (types.any((type) => [
      'airport', 'train_station', 'subway_station', 'bus_station'
    ].contains(type))) {
      return ResultCategory.transport;
    }

    // Padrão: endereço
    return ResultCategory.address;
  }

  /// Aplica categorização aos resultados
  List<EnhancedResult> _categorizeResults(List<EnhancedResult> results) {
    // Agrupar por categoria para análise
    final categories = <ResultCategory, List<EnhancedResult>>{};

    for (final result in results) {
      categories.putIfAbsent(result.category, () => []).add(result);
    }

    debugPrint('📊 Categorização: ${categories.map((k, v) => MapEntry(k.toString(), v.length))}');

    return results; // Mantém ordem original, categorização é informativa
  }

  /// Aplica ranking inteligente baseado em múltiplos fatores
  List<EnhancedResult> _rankResults(
    List<EnhancedResult> results,
    String query,
    LatLng? userLocation,
    String? context,
  ) {
    for (final result in results) {
      double score = 0.0;

      // 1. Relevância textual (40%)
      score += _calculateTextRelevance(result, query) * 0.4;

      // 2. Proximidade (25%)
      if (result.distance != null) {
        final proximityScore = math.max(0.0, 1.0 - (result.distance! / 50.0)); // Normalizar até 50km
        score += proximityScore * 0.25;
      }

      // 3. Categoria relevante ao contexto (20%)
      score += _getCategoryContextBoost(result.category, context) * 0.2;

      // 4. Popularidade/Tipo de local (15%)
      score += _getPopularityScore(result) * 0.15;

      result.relevanceScore = score;
    }

    // Ordenar por score descendente
    results.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));

    return results;
  }

  /// Calcula relevância textual entre resultado e query
  double _calculateTextRelevance(EnhancedResult result, String query) {
    final queryLower = query.toLowerCase();
    final mainTextLower = result.mainText.toLowerCase();
    final descriptionLower = result.description.toLowerCase();

    // Pontuação por correspondência exata
    if (mainTextLower == queryLower) return 1.0;
    if (mainTextLower.startsWith(queryLower)) return 0.9;
    if (mainTextLower.contains(queryLower)) return 0.7;
    if (descriptionLower.contains(queryLower)) return 0.5;

    // Pontuação por palavras em comum
    final queryWords = queryLower.split(' ');
    final mainWords = mainTextLower.split(' ');

    int matchCount = 0;
    for (final queryWord in queryWords) {
      if (queryWord.length > 2 && mainWords.any((word) => word.contains(queryWord))) {
        matchCount++;
      }
    }

    return matchCount / queryWords.length * 0.6;
  }

  /// Boost de categoria baseado no contexto
  double _getCategoryContextBoost(ResultCategory category, String? context) {
    if (context == null) return 0.5;

    switch (context) {
      case 'origem':
        // Para origem, favorecer endereços residenciais e recentes
        if (category == ResultCategory.residential) return 1.0;
        if (category == ResultCategory.transport) return 0.8;
        break;

      case 'destino':
        // Para destino, favorecer comércios e pontos turísticos
        if (category == ResultCategory.business) return 1.0;
        if (category == ResultCategory.landmark) return 0.9;
        if (category == ResultCategory.transport) return 0.8;
        break;

      case 'parada':
        // Para paradas, favorecer comércios e serviços
        if (category == ResultCategory.business) return 1.0;
        if (category == ResultCategory.landmark) return 0.7;
        break;
    }

    return 0.5; // Score neutro
  }

  /// Score de popularidade baseado no tipo de local
  double _getPopularityScore(EnhancedResult result) {
    // Tipos mais comuns/populares recebem score maior
    const popularTypes = {
      'shopping_mall': 1.0,
      'restaurant': 0.9,
      'hospital': 0.9,
      'school': 0.8,
      'gas_station': 0.8,
      'bank': 0.7,
      'store': 0.7,
    };

    double maxScore = 0.0;
    for (final type in result.types) {
      final score = popularTypes[type] ?? 0.5;
      if (score > maxScore) maxScore = score;
    }

    return maxScore;
  }

  /// Obtém sugestões contextuais adicionais
  Future<List<EnhancedResult>> _getContextualSuggestions(
    String query,
    String? context,
    LatLng? userLocation,
  ) async {
    try {
      // Buscar sugestões do histórico de trips
      final tripSuggestions = await TripSuggestionsService.instance.getSuggestions(
        context: context,
        currentLocation: userLocation,
      );

      final results = <EnhancedResult>[];

      for (final suggestion in tripSuggestions.take(3)) {
        results.add(EnhancedResult(
          placeId: 'suggestion_${suggestion.place.latLng.latitude}_${suggestion.place.latLng.longitude}',
          description: suggestion.place.address,
          mainText: suggestion.place.name,
          secondaryText: suggestion.subtitle,
          category: ResultCategory.recent,
          types: ['recent_suggestion'],
          distance: userLocation != null
              ? Geolocator.distanceBetween(
                  userLocation.latitude, userLocation.longitude,
                  suggestion.place.latLng.latitude, suggestion.place.latLng.longitude,
                ) / 1000
              : null,
          distanceText: null,
          relevanceScore: suggestion.score,
          icon: suggestion.icon,
          isRecent: suggestion.type == SuggestionType.recent,
          isFavorite: suggestion.type == SuggestionType.favorite,
        ));
      }

      return results;
    } catch (e) {
      debugPrint('❌ Erro ao buscar sugestões contextuais: $e');
      return [];
    }
  }

  /// Garante diversidade nos resultados finais
  List<EnhancedResult> _ensureDiversity(List<EnhancedResult> results, {int maxResults = 8}) {
    final finalResults = <EnhancedResult>[];
    final categoryCount = <ResultCategory, int>{};

    for (final result in results) {
      if (finalResults.length >= maxResults) break;

      final categoryLimit = _getCategoryLimit(result.category);
      final currentCount = categoryCount[result.category] ?? 0;

      if (currentCount < categoryLimit) {
        finalResults.add(result);
        categoryCount[result.category] = currentCount + 1;
      }
    }

    return finalResults;
  }

  /// Limite por categoria para garantir diversidade
  int _getCategoryLimit(ResultCategory category) {
    switch (category) {
      case ResultCategory.residential: return 3;
      case ResultCategory.business: return 3;
      case ResultCategory.landmark: return 2;
      case ResultCategory.transport: return 2;
      case ResultCategory.recent: return 2;
      case ResultCategory.address: return 4;
    }
  }

  /// Ícone para categoria
  IconData _getIconForCategory(ResultCategory category) {
    switch (category) {
      case ResultCategory.residential: return Icons.home;
      case ResultCategory.business: return Icons.business;
      case ResultCategory.landmark: return Icons.place;
      case ResultCategory.transport: return Icons.directions_transit;
      case ResultCategory.recent: return Icons.history;
      case ResultCategory.address: return Icons.location_on;
    }
  }
}

/// Resultado enriquecido com metadados
class EnhancedResult {
  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;
  final ResultCategory category;
  final List<String> types;
  final double? distance;
  final String? distanceText;
  double relevanceScore;
  final IconData icon;
  final bool isRecent;
  final bool isFavorite;

  EnhancedResult({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
    required this.category,
    required this.types,
    this.distance,
    this.distanceText,
    this.relevanceScore = 0.0,
    required this.icon,
    this.isRecent = false,
    this.isFavorite = false,
  });

  /// Converter para FFPlace (coordenadas serão preenchidas com Place Details)
  FFPlace toFFPlace() {
    return FFPlace(
      latLng: LatLng(0.0, 0.0), // Será preenchido com Place Details
      name: mainText,
      address: description,
      city: '',
      state: '',
      country: '',
      zipCode: '',
    );
  }
}

/// Categorias de resultados
enum ResultCategory {
  residential,    // Endereços residenciais
  business,       // Empresas e comércios
  landmark,       // Pontos turísticos e marcos
  transport,      // Estações e aeroportos
  recent,         // Locais recentes
  address,        // Endereços gerais
}