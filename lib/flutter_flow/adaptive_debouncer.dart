import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Sistema de Debounce Adaptativo
/// Ajusta automaticamente os tempos de debounce baseado no comportamento do usuário
class AdaptiveDebouncer {
  AdaptiveDebouncer._();

  static AdaptiveDebouncer? _instance;
  static AdaptiveDebouncer get instance => _instance ??= AdaptiveDebouncer._();

  Timer? _timer;
  String _lastQuery = '';
  DateTime? _lastSearchTime;

  // Configurações adaptativas
  static const int _defaultDelayMs = 800;
  static const int _minDelayMs = 300;
  static const int _maxDelayMs = 1500;
  static const int _fastUserThreshold = 50; // buscas em 30 dias

  // Métricas do usuário
  int _searchCount = 0;
  double _averageTypingSpeed = 0.0;
  DateTime? _lastStatsUpdate;

  /// Executa função com debounce adaptativo
  void debounce({
    required String query,
    required VoidCallback onExecute,
    bool immediate = false,
  }) async {
    // Cancelar timer anterior
    _timer?.cancel();

    // Se for busca imediata (ex: cache hit)
    if (immediate) {
      onExecute();
      return;
    }

    // Calcular delay adaptativo
    final delay = await _calculateAdaptiveDelay(query);

    _timer = Timer(Duration(milliseconds: delay), () {
      _updateUserMetrics(query);
      onExecute();
    });
  }

  /// Cancela debounce pendente
  void cancel() {
    _timer?.cancel();
  }

  /// Calcula delay baseado no perfil do usuário
  Future<int> _calculateAdaptiveDelay(String query) async {
    await _loadUserStats();

    // Delay base
    int delay = _defaultDelayMs;

    // 1. Ajustar baseado na experiência do usuário
    if (_searchCount > _fastUserThreshold) {
      delay = (_defaultDelayMs * 0.7).round(); // 30% mais rápido para usuários experientes
    }

    // 2. Ajustar baseado na velocidade de digitação
    if (_averageTypingSpeed > 0) {
      if (_averageTypingSpeed > 3.0) { // caracteres por segundo
        delay = (delay * 0.8).round(); // Usuário digita rápido
      } else if (_averageTypingSpeed < 1.5) {
        delay = (delay * 1.2).round(); // Usuário digita devagar
      }
    }

    // 3. Ajustar baseado no tamanho da query
    if (query.length < 3) {
      delay = (delay * 1.5).round(); // Delay maior para queries curtas
    } else if (query.length > 8) {
      delay = (delay * 0.9).round(); // Delay menor para queries longas
    }

    // 4. Boost se query é similar à anterior (usuário refinando)
    if (_isRefinement(query)) {
      delay = (delay * 0.6).round(); // Resposta mais rápida para refinamentos
    }

    // 5. Aplicar limites
    delay = delay.clamp(_minDelayMs, _maxDelayMs);

    debugPrint('🎯 Debounce adaptativo: ${delay}ms para "$query"');
    return delay;
  }

  /// Verifica se a query atual é um refinamento da anterior
  bool _isRefinement(String query) {
    if (_lastQuery.isEmpty || query.isEmpty) return false;

    // Se a nova query contém a anterior, é um refinamento
    return query.toLowerCase().contains(_lastQuery.toLowerCase()) ||
           _lastQuery.toLowerCase().contains(query.toLowerCase());
  }

  /// Atualiza métricas do usuário
  void _updateUserMetrics(String query) async {
    final now = DateTime.now();

    // Calcular velocidade de digitação
    if (_lastSearchTime != null && _lastQuery.isNotEmpty) {
      final timeDiff = now.difference(_lastSearchTime!).inMilliseconds;
      final charDiff = (query.length - _lastQuery.length).abs();

      if (timeDiff > 0 && charDiff > 0) {
        final currentSpeed = (charDiff / timeDiff) * 1000; // caracteres por segundo
        _averageTypingSpeed = _averageTypingSpeed == 0.0
            ? currentSpeed
            : (_averageTypingSpeed * 0.8) + (currentSpeed * 0.2); // Média móvel
      }
    }

    _lastQuery = query;
    _lastSearchTime = now;
    _searchCount++;

    // Salvar estatísticas periodicamente
    if (_lastStatsUpdate == null ||
        now.difference(_lastStatsUpdate!).inMinutes > 5) {
      await _saveUserStats();
      _lastStatsUpdate = now;
    }
  }

  /// Carrega estatísticas do usuário
  Future<void> _loadUserStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _searchCount = prefs.getInt('adaptive_search_count') ?? 0;
      _averageTypingSpeed = prefs.getDouble('adaptive_typing_speed') ?? 0.0;

      final lastUpdate = prefs.getString('adaptive_last_update');
      if (lastUpdate != null) {
        _lastStatsUpdate = DateTime.parse(lastUpdate);

        // Reset estatísticas se muito antigas (30 dias)
        if (DateTime.now().difference(_lastStatsUpdate!).inDays > 30) {
          await _resetStats();
        }
      }
    } catch (e) {
      debugPrint('❌ Erro ao carregar estatísticas adaptativas: $e');
    }
  }

  /// Salva estatísticas do usuário
  Future<void> _saveUserStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('adaptive_search_count', _searchCount);
      await prefs.setDouble('adaptive_typing_speed', _averageTypingSpeed);
      await prefs.setString('adaptive_last_update', DateTime.now().toIso8601String());

      debugPrint('💾 Estatísticas salvas: $_searchCount buscas, ${_averageTypingSpeed.toStringAsFixed(2)} c/s');
    } catch (e) {
      debugPrint('❌ Erro ao salvar estatísticas adaptativas: $e');
    }
  }

  /// Reset estatísticas
  Future<void> _resetStats() async {
    _searchCount = 0;
    _averageTypingSpeed = 0.0;
    _lastStatsUpdate = null;
    await _saveUserStats();
    debugPrint('🔄 Estatísticas adaptativas resetadas');
  }

  /// Obtém informações de debug
  Map<String, dynamic> getDebugInfo() {
    return {
      'searchCount': _searchCount,
      'averageTypingSpeed': _averageTypingSpeed,
      'lastQuery': _lastQuery,
      'isExperiencedUser': _searchCount > _fastUserThreshold,
    };
  }

  /// Limpar recursos
  void dispose() {
    _timer?.cancel();
  }
}

/// Configurações de debounce personalizáveis
class DebounceConfig {
  final int defaultDelayMs;
  final int minDelayMs;
  final int maxDelayMs;
  final int experienceThreshold;
  final bool enableAdaptive;

  const DebounceConfig({
    this.defaultDelayMs = 800,
    this.minDelayMs = 300,
    this.maxDelayMs = 1500,
    this.experienceThreshold = 50,
    this.enableAdaptive = true,
  });
}