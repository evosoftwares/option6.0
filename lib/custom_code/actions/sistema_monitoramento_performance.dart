import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Sistema de monitoramento de performance em tempo real
class SistemaMonitoramentoPerformance {
  static final SistemaMonitoramentoPerformance _instance = 
      SistemaMonitoramentoPerformance._internal();
  
  factory SistemaMonitoramentoPerformance() => _instance;
  
  SistemaMonitoramentoPerformance._internal();

  Timer? _monitoringTimer;
  final List<PerformanceMetric> _metrics = [];
  final StreamController<PerformanceReport> _reportController = 
      StreamController<PerformanceReport>.broadcast();

  /// Stream de relatórios de performance
  Stream<PerformanceReport> get performanceStream => _reportController.stream;

  /// Inicia o monitoramento de performance
  void startMonitoring({Duration interval = const Duration(seconds: 5)}) {
    if (_monitoringTimer?.isActive == true) return;

    debugPrint('🚀 [PERFORMANCE] Iniciando monitoramento de performance');
    
    _monitoringTimer = Timer.periodic(interval, (timer) async {
      try {
        final report = await _collectPerformanceData();
        _reportController.add(report);
        
        // Log crítico se performance estiver degradada
        if (report.healthScore < 70) {
          debugPrint('⚠️ [PERFORMANCE] Performance degradada: ${report.healthScore}%');
        }
      } catch (e) {
        debugPrint('❌ [PERFORMANCE] Erro ao coletar métricas: $e');
      }
    });
  }

  /// Para o monitoramento
  void stopMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
    debugPrint('🛑 [PERFORMANCE] Monitoramento parado');
  }

  /// Coleta dados de performance do sistema
  Future<PerformanceReport> _collectPerformanceData() async {
    final timestamp = DateTime.now();
    
    // Métricas de memória
    final memoryUsage = await _getMemoryUsage();
    
    // Métricas de CPU (simuladas no Flutter)
    final cpuUsage = await _getCpuUsage();
    
    // Métricas de frames
    final frameMetrics = _getFrameMetrics();
    
    // Calcular score de saúde
    final healthScore = _calculateHealthScore(memoryUsage, cpuUsage, frameMetrics);
    
    final report = PerformanceReport(
      timestamp: timestamp,
      memoryUsageMB: memoryUsage,
      cpuUsagePercent: cpuUsage,
      frameMetrics: frameMetrics,
      healthScore: healthScore,
    );

    // Manter histórico limitado
    _metrics.add(PerformanceMetric(
      timestamp: timestamp,
      memoryUsage: memoryUsage,
      cpuUsage: cpuUsage,
      healthScore: healthScore,
    ));

    // Limitar histórico a 100 entradas
    if (_metrics.length > 100) {
      _metrics.removeAt(0);
    }

    return report;
  }

  /// Obtém uso de memória em MB
  Future<double> _getMemoryUsage() async {
    try {
      if (Platform.isAndroid) {
        // No Android, usar informações do sistema
        final result = await Process.run('cat', ['/proc/meminfo']);
        final lines = result.stdout.toString().split('\n');
        
        for (final line in lines) {
          if (line.startsWith('MemAvailable:')) {
            final parts = line.split(RegExp(r'\s+'));
            if (parts.length >= 2) {
              final availableKB = int.tryParse(parts[1]) ?? 0;
              return availableKB / 1024.0; // Converter para MB
            }
          }
        }
      }
      
      // Fallback: estimativa baseada no isolate atual
      return 50.0; // MB estimado
    } catch (e) {
      return 0.0;
    }
  }

  /// Obtém uso de CPU (simulado)
  Future<double> _getCpuUsage() async {
    // No Flutter, não temos acesso direto ao CPU
    // Simular baseado na carga de trabalho atual
    final startTime = DateTime.now().microsecondsSinceEpoch;
    
    // Pequena operação para medir responsividade
    for (int i = 0; i < 1000; i++) {
      // Operação leve
    }
    
    final endTime = DateTime.now().microsecondsSinceEpoch;
    final duration = endTime - startTime;
    
    // Converter para porcentagem estimada (0-100)
    return (duration / 10000.0).clamp(0.0, 100.0);
  }

  /// Obtém métricas de frames
  FrameMetrics _getFrameMetrics() {
    // Simular métricas de frame baseadas no estado atual
    // Em uma implementação real, isso seria integrado com o WidgetsBinding
    return FrameMetrics(
      averageFPS: 60.0,
      droppedFrames: 0,
      jankFrames: 0,
    );
  }

  /// Calcula score de saúde do sistema (0-100)
  int _calculateHealthScore(double memory, double cpu, FrameMetrics frames) {
    int score = 100;
    
    // Penalizar alto uso de CPU
    if (cpu > 80) score -= 30;
    else if (cpu > 60) score -= 20;
    else if (cpu > 40) score -= 10;
    
    // Penalizar baixa memória disponível
    if (memory < 20) score -= 25;
    else if (memory < 50) score -= 15;
    else if (memory < 100) score -= 5;
    
    // Penalizar frames perdidos
    if (frames.droppedFrames > 5) score -= 20;
    else if (frames.droppedFrames > 2) score -= 10;
    
    // Penalizar jank
    if (frames.jankFrames > 3) score -= 15;
    else if (frames.jankFrames > 1) score -= 5;
    
    return score.clamp(0, 100);
  }

  /// Obtém relatório de performance atual
  PerformanceReport? getCurrentReport() {
    if (_metrics.isEmpty) return null;
    
    final latest = _metrics.last;
    return PerformanceReport(
      timestamp: latest.timestamp,
      memoryUsageMB: latest.memoryUsage,
      cpuUsagePercent: latest.cpuUsage,
      frameMetrics: FrameMetrics(averageFPS: 60.0, droppedFrames: 0, jankFrames: 0),
      healthScore: latest.healthScore,
    );
  }

  /// Obtém histórico de métricas
  List<PerformanceMetric> getMetricsHistory() => List.from(_metrics);

  /// Limpa o histórico
  void clearHistory() {
    _metrics.clear();
    debugPrint('🧹 [PERFORMANCE] Histórico limpo');
  }

  /// Dispose dos recursos
  void dispose() {
    stopMonitoring();
    _reportController.close();
  }
}

/// Métrica de performance individual
class PerformanceMetric {
  final DateTime timestamp;
  final double memoryUsage;
  final double cpuUsage;
  final int healthScore;

  PerformanceMetric({
    required this.timestamp,
    required this.memoryUsage,
    required this.cpuUsage,
    required this.healthScore,
  });
}

/// Relatório completo de performance
class PerformanceReport {
  final DateTime timestamp;
  final double memoryUsageMB;
  final double cpuUsagePercent;
  final FrameMetrics frameMetrics;
  final int healthScore;

  PerformanceReport({
    required this.timestamp,
    required this.memoryUsageMB,
    required this.cpuUsagePercent,
    required this.frameMetrics,
    required this.healthScore,
  });

  @override
  String toString() {
    return 'PerformanceReport(timestamp: $timestamp, memory: ${memoryUsageMB.toStringAsFixed(1)}MB, '
           'cpu: ${cpuUsagePercent.toStringAsFixed(1)}%, health: $healthScore%)';
  }
}

/// Métricas de frames
class FrameMetrics {
  final double averageFPS;
  final int droppedFrames;
  final int jankFrames;

  FrameMetrics({
    required this.averageFPS,
    required this.droppedFrames,
    required this.jankFrames,
  });
}

/// Função de ação para iniciar monitoramento
Future<void> iniciarMonitoramentoPerformance() async {
  final monitor = SistemaMonitoramentoPerformance();
  monitor.startMonitoring();
  
  // Escutar relatórios e logar problemas críticos
  monitor.performanceStream.listen((report) {
    if (report.healthScore < 50) {
      debugPrint('🚨 [PERFORMANCE] CRÍTICO: ${report.toString()}');
    } else if (report.healthScore < 70) {
      debugPrint('⚠️ [PERFORMANCE] ATENÇÃO: ${report.toString()}');
    }
  });
  
  debugPrint('✅ [PERFORMANCE] Sistema de monitoramento iniciado');
}

/// Função de ação para parar monitoramento
Future<void> pararMonitoramentoPerformance() async {
  final monitor = SistemaMonitoramentoPerformance();
  monitor.stopMonitoring();
  debugPrint('🛑 [PERFORMANCE] Sistema de monitoramento parado');
}