import '/backend/supabase/supabase.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

/// Sistema Completo de Analytics e Performance Monitoring
/// Monitora métricas em tempo real do sistema de viagens
/// Gera insights para otimização e tomada de decisões

class SistemaAnalyticsPerformance {
  static SistemaAnalyticsPerformance? _instance;
  static SistemaAnalyticsPerformance get instance => _instance ??= SistemaAnalyticsPerformance._();

  SistemaAnalyticsPerformance._();

  Timer? _monitoringTimer;
  final List<PerformanceMetric> _realtimeMetrics = [];
  final Map<String, dynamic> _kpiCache = {};

  /// Inicia monitoramento contínuo do sistema
  Future<void> iniciarMonitoramento({
    Duration interval = const Duration(minutes: 5),
  }) async {
    try {
      print('📊 Iniciando sistema de analytics...');

      // Primeira coleta imediata
      await _coletarMetricasCompletas();

      // Agendar coletas periódicas
      _monitoringTimer = Timer.periodic(interval, (timer) async {
        await _coletarMetricasCompletas();
      });

      print('✅ Sistema de analytics ativo');
    } catch (e) {
      print('❌ Erro ao iniciar analytics: $e');
    }
  }

  /// Para o monitoramento
  void pararMonitoramento() {
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
    print('🛑 Monitoramento de analytics parado');
  }

  /// Coleta métricas completas do sistema
  Future<void> _coletarMetricasCompletas() async {
    try {
      final agora = DateTime.now();
      print('📈 Coletando métricas: ${agora.toString().substring(0, 19)}');

      // Métricas paralelas para performance
      final futures = await Future.wait([
        _coletarMetricasViagens(),
        _coletarMetricasMotoristas(),
        _coletarMetricasPassageiros(),
        _coletarMetricasFinanceiras(),
        _coletarMetricasDesempenho(),
        _coletarMetricasQualidade(),
      ]);

      // Consolidar métricas
      final metricas = PerformanceSnapshot(
        timestamp: agora,
        viagensMetrics: futures[0] as ViagensMetrics,
        motoristasMetrics: futures[1] as MotoristasMetrics,
        passageirosMetrics: futures[2] as PassageirosMetrics,
        financeiroMetrics: futures[3] as FinanceiroMetrics,
        desempenhoMetrics: futures[4] as DesempenhoMetrics,
        qualidadeMetrics: futures[5] as QualidadeMetrics,
      );

      // Salvar no Supabase para histórico
      await _salvarMetricasHistorico(metricas);

      // Calcular health score
      final healthScore = _calcularHealthScore(metricas);

      // Detectar anomalias
      final anomalias = await _detectarAnomalias(metricas);

      // Gerar alertas se necessário
      if (healthScore < 70 || anomalias.isNotEmpty) {
        await _gerarAlertas(healthScore, anomalias, metricas);
      }

      print('✅ Métricas coletadas - Health Score: ${healthScore.toStringAsFixed(1)}%');

    } catch (e) {
      print('❌ Erro na coleta de métricas: $e');
    }
  }

  /// Coleta métricas específicas de viagens
  Future<ViagensMetrics> _coletarMetricasViagens() async {
    try {
      final agora = DateTime.now();
      final umaHoraAtras = agora.subtract(Duration(hours: 1));
      final umDiaAtras = agora.subtract(Duration(days: 1));

      // Consultas paralelas
      final results = await Future.wait([
        // Viagens ativas
        SupaFlow.client
            .from('trips')
            .select('count')
            .neq('status', 'completed')
            .neq('status', 'cancelled'),

        // Solicitações pendentes
        SupaFlow.client
            .from('trip_requests')
            .select('count')
            .eq('status', 'searching'),

        // Viagens completadas última hora
        SupaFlow.client
            .from('trips')
            .select('id, created_at, trip_completed_at, total_fare, status')
            .eq('status', 'completed')
            .gte('trip_completed_at', umaHoraAtras.toIso8601String()),

        // Viagens completadas último dia
        SupaFlow.client
            .from('trips')
            .select('id, created_at, trip_completed_at, total_fare')
            .eq('status', 'completed')
            .gte('trip_completed_at', umDiaAtras.toIso8601String()),

        // Cancelamentos última hora
        SupaFlow.client
            .from('trips')
            .select('count')
            .eq('status', 'cancelled')
            .gte('cancelled_at', umaHoraAtras.toIso8601String()),
      ]);

      final viagensAtivas = results[0].length;
      final solicitacoesPendentes = results[1].length;
      final viagensCompletadasHora = results[2] as List;
      final viagensCompletadasDia = results[3] as List;
      final cancelamentosHora = results[4].length;

      // Cálculos de performance
      final tempoMedioViagem = _calcularTempoMedioViagem(viagensCompletadasHora);
      final taxaCancelamento = _calcularTaxaCancelamento(viagensCompletadasDia, cancelamentosHora);

      return ViagensMetrics(
        viagensAtivas: viagensAtivas,
        solicitacoesPendentes: solicitacoesPendentes,
        viagensCompletadasUltimaHora: viagensCompletadasHora.length,
        viagensCompletadasUltimoDia: viagensCompletadasDia.length,
        cancelamentosUltimaHora: cancelamentosHora,
        tempoMedioViagem: tempoMedioViagem,
        taxaCancelamento: taxaCancelamento,
        receita24h: _calcularReceita24h(viagensCompletadasDia),
      );

    } catch (e) {
      print('❌ Erro ao coletar métricas de viagens: $e');
      return ViagensMetrics.empty();
    }
  }

  /// Coleta métricas de motoristas
  Future<MotoristasMetrics> _coletarMetricasMotoristas() async {
    try {
      final agora = DateTime.now();
      final cincoMinutosAtras = agora.subtract(Duration(minutes: 5));

      final results = await Future.wait([
        // Motoristas online
        SupaFlow.client
            .from('drivers')
            .select('count')
            .eq('is_online', true)
            .eq('approval_status', 'approved'),

        // Motoristas ativos (com localização recente)
        SupaFlow.client
            .from('drivers')
            .select('count')
            .eq('is_online', true)
            .eq('approval_status', 'approved')
            .gte('last_location_update', cincoMinutosAtras.toIso8601String()),

        // Motoristas em viagem
        SupaFlow.client
            .from('trips')
            .select('driver_id')
            .neq('status', 'completed')
            .neq('status', 'cancelled'),

        // Total de motoristas aprovados
        SupaFlow.client
            .from('drivers')
            .select('count')
            .eq('approval_status', 'approved'),
      ]);

      final motoristasOnline = results[0].length;
      final motoristasAtivos = results[1].length;
      final motoristasEmViagem = results[2].length;
      final totalMotoristas = results[3].length;

      final utilizacao = totalMotoristas > 0 ? (motoristasEmViagem / totalMotoristas) * 100 : 0.0;

      return MotoristasMetrics(
        totalMotoristas: totalMotoristas,
        motoristasOnline: motoristasOnline,
        motoristasAtivos: motoristasAtivos,
        motoristasEmViagem: motoristasEmViagem,
        taxaUtilizacao: utilizacao,
      );

    } catch (e) {
      print('❌ Erro ao coletar métricas de motoristas: $e');
      return MotoristasMetrics.empty();
    }
  }

  /// Coleta métricas de passageiros
  Future<PassageirosMetrics> _coletarMetricasPassageiros() async {
    try {
      final agora = DateTime.now();
      final umDiaAtras = agora.subtract(Duration(days: 1));

      final results = await Future.wait([
        // Passageiros ativos (viagem nas últimas 24h)
        SupaFlow.client
            .from('trips')
            .select('passenger_id')
            .gte('created_at', umDiaAtras.toIso8601String()),

        // Total de passageiros
        SupaFlow.client
            .from('passengers')
            .select('count'),

        // Novos passageiros (últimas 24h)
        SupaFlow.client
            .from('passengers')
            .select('count')
            .gte('created_at', umDiaAtras.toIso8601String()),
      ]);

      final passageirosAtivos = (results[0] as List).map((t) => t['passenger_id']).toSet().length;
      final totalPassageiros = results[1].length;
      final novosPassageiros = results[2].length;

      return PassageirosMetrics(
        totalPassageiros: totalPassageiros,
        passageirosAtivos24h: passageirosAtivos,
        novosPassageiros24h: novosPassageiros,
      );

    } catch (e) {
      print('❌ Erro ao coletar métricas de passageiros: $e');
      return PassageirosMetrics.empty();
    }
  }

  /// Coleta métricas financeiras
  Future<FinanceiroMetrics> _coletarMetricasFinanceiras() async {
    try {
      final agora = DateTime.now();
      final umDiaAtras = agora.subtract(Duration(days: 1));

      final viagensCompletadas = await SupaFlow.client
          .from('trips')
          .select('total_fare, driver_earnings, platform_commission')
          .eq('status', 'completed')
          .gte('trip_completed_at', umDiaAtras.toIso8601String());

      double receita24h = 0.0;
      double comissaoPlataforma24h = 0.0;
      double pagamentoMotoristas24h = 0.0;

      for (var viagem in viagensCompletadas) {
        receita24h += (viagem['total_fare'] as double?) ?? 0.0;
        comissaoPlataforma24h += (viagem['platform_commission'] as double?) ?? 0.0;
        pagamentoMotoristas24h += (viagem['driver_earnings'] as double?) ?? 0.0;
      }

      final ticketMedio = viagensCompletadas.isNotEmpty ? receita24h / viagensCompletadas.length : 0.0;

      return FinanceiroMetrics(
        receita24h: receita24h,
        comissaoPlataforma24h: comissaoPlataforma24h,
        pagamentoMotoristas24h: pagamentoMotoristas24h,
        ticketMedio: ticketMedio,
        viagensComReceita: viagensCompletadas.length,
      );

    } catch (e) {
      print('❌ Erro ao coletar métricas financeiras: $e');
      return FinanceiroMetrics.empty();
    }
  }

  /// Coleta métricas de desempenho técnico
  Future<DesempenhoMetrics> _coletarMetricasDesempenho() async {
    try {
      final agora = DateTime.now();
      final umaHoraAtras = agora.subtract(Duration(hours: 1));

      // Tempo médio de matching
      final solicitacoes = await SupaFlow.client
          .from('trip_requests')
          .select('created_at, accepted_at')
          .not('accepted_at', 'is', null)
          .gte('created_at', umaHoraAtras.toIso8601String());

      double tempoMedioMatching = 0.0;
      if (solicitacoes.isNotEmpty) {
        double totalSegundos = 0.0;
        for (var solicitacao in solicitacoes) {
          final criado = DateTime.parse(solicitacao['created_at']);
          final aceito = DateTime.parse(solicitacao['accepted_at']);
          totalSegundos += aceito.difference(criado).inSeconds;
        }
        tempoMedioMatching = totalSegundos / solicitacoes.length;
      }

      // Taxa de sucesso de matching
      final totalSolicitacoes = await SupaFlow.client
          .from('trip_requests')
          .select('count')
          .gte('created_at', umaHoraAtras.toIso8601String());

      final solicitacoesAceitas = solicitacoes.length;
      final taxaSucessoMatching = totalSolicitacoes.isNotEmpty
          ? (solicitacoesAceitas / totalSolicitacoes.length) * 100
          : 0.0;

      return DesempenhoMetrics(
        tempoMedioMatching: tempoMedioMatching,
        taxaSucessoMatching: taxaSucessoMatching,
        requestsUltimaHora: totalSolicitacoes.length,
        matchingsRealizados: solicitacoesAceitas,
      );

    } catch (e) {
      print('❌ Erro ao coletar métricas de desempenho: $e');
      return DesempenhoMetrics.empty();
    }
  }

  /// Coleta métricas de qualidade
  Future<QualidadeMetrics> _coletarMetricasQualidade() async {
    try {
      final agora = DateTime.now();
      final seteDiasAtras = agora.subtract(Duration(days: 7));

      // Ratings dos últimos 7 dias
      final ratings = await SupaFlow.client
          .from('ratings')
          .select('passenger_rating, driver_rating')
          .gte('created_at', seteDiasAtras.toIso8601String());

      double somaRatingPassageiros = 0.0;
      double somaRatingMotoristas = 0.0;
      int countPassageiros = 0;
      int countMotoristas = 0;

      for (var rating in ratings) {
        if (rating['passenger_rating'] != null) {
          somaRatingPassageiros += rating['passenger_rating'];
          countPassageiros++;
        }
        if (rating['driver_rating'] != null) {
          somaRatingMotoristas += rating['driver_rating'];
          countMotoristas++;
        }
      }

      final mediaRatingPassageiros = countPassageiros > 0 ? somaRatingPassageiros / countPassageiros : 0.0;
      final mediaRatingMotoristas = countMotoristas > 0 ? somaRatingMotoristas / countMotoristas : 0.0;

      return QualidadeMetrics(
        mediaRatingPassageiros: mediaRatingPassageiros,
        mediaRatingMotoristas: mediaRatingMotoristas,
        totalAvaliacoes7dias: ratings.length,
      );

    } catch (e) {
      print('❌ Erro ao coletar métricas de qualidade: $e');
      return QualidadeMetrics.empty();
    }
  }

  /// Calcula health score geral do sistema
  double _calcularHealthScore(PerformanceSnapshot snapshot) {
    double score = 100.0;

    // Penalizar por alta taxa de cancelamento
    if (snapshot.viagensMetrics.taxaCancelamento > 15) {
      score -= (snapshot.viagensMetrics.taxaCancelamento - 15) * 2;
    }

    // Penalizar por baixa disponibilidade de motoristas
    if (snapshot.motoristasMetrics.motoristasOnline < 10) {
      score -= (10 - snapshot.motoristasMetrics.motoristasOnline) * 3;
    }

    // Penalizar por tempo de matching alto
    if (snapshot.desempenhoMetrics.tempoMedioMatching > 60) {
      score -= (snapshot.desempenhoMetrics.tempoMedioMatching - 60) / 10;
    }

    // Bonificar por alta taxa de sucesso
    if (snapshot.desempenhoMetrics.taxaSucessoMatching > 90) {
      score += (snapshot.desempenhoMetrics.taxaSucessoMatching - 90) / 2;
    }

    // Bonificar por bons ratings
    final mediaRatings = (snapshot.qualidadeMetrics.mediaRatingPassageiros +
                         snapshot.qualidadeMetrics.mediaRatingMotoristas) / 2;
    if (mediaRatings > 4.5) {
      score += (mediaRatings - 4.5) * 10;
    } else if (mediaRatings < 4.0) {
      score -= (4.0 - mediaRatings) * 15;
    }

    return math.max(0.0, math.min(100.0, score));
  }

  /// Detecta anomalias no sistema
  Future<List<AnomaliaDetectada>> _detectarAnomalias(PerformanceSnapshot snapshot) async {
    final anomalias = <AnomaliaDetectada>[];

    // Anomalia: Muitas solicitações pendentes
    if (snapshot.viagensMetrics.solicitacoesPendentes > 20) {
      anomalias.add(AnomaliaDetectada(
        tipo: TipoAnomalia.altaDemanda,
        severidade: SeveridadeAnomalia.alta,
        descricao: 'Muitas solicitações pendentes: ${snapshot.viagensMetrics.solicitacoesPendentes}',
        valor: snapshot.viagensMetrics.solicitacoesPendentes.toDouble(),
        threshold: 20.0,
      ));
    }

    // Anomalia: Poucos motoristas online
    if (snapshot.motoristasMetrics.motoristasOnline < 5) {
      anomalias.add(AnomaliaDetectada(
        tipo: TipoAnomalia.baixaDisponibilidade,
        severidade: SeveridadeAnomalia.critica,
        descricao: 'Poucos motoristas online: ${snapshot.motoristasMetrics.motoristasOnline}',
        valor: snapshot.motoristasMetrics.motoristasOnline.toDouble(),
        threshold: 5.0,
      ));
    }

    // Anomalia: Taxa de cancelamento alta
    if (snapshot.viagensMetrics.taxaCancelamento > 25) {
      anomalias.add(AnomaliaDetectada(
        tipo: TipoAnomalia.altoCancelamento,
        severidade: SeveridadeAnomalia.media,
        descricao: 'Taxa de cancelamento alta: ${snapshot.viagensMetrics.taxaCancelamento.toStringAsFixed(1)}%',
        valor: snapshot.viagensMetrics.taxaCancelamento,
        threshold: 25.0,
      ));
    }

    // Anomalia: Tempo de matching muito alto
    if (snapshot.desempenhoMetrics.tempoMedioMatching > 120) {
      anomalias.add(AnomaliaDetectada(
        tipo: TipoAnomalia.tempoMatchingAlto,
        severidade: SeveridadeAnomalia.alta,
        descricao: 'Tempo médio de matching alto: ${snapshot.desempenhoMetrics.tempoMedioMatching.toStringAsFixed(0)}s',
        valor: snapshot.desempenhoMetrics.tempoMedioMatching,
        threshold: 120.0,
      ));
    }

    return anomalias;
  }

  /// Gera alertas baseados em métricas e anomalias
  Future<void> _gerarAlertas(
    double healthScore,
    List<AnomaliaDetectada> anomalias,
    PerformanceSnapshot snapshot,
  ) async {
    try {
      // Alerta de health score baixo
      if (healthScore < 70) {
        await _enviarAlertaAdmin(
          titulo: '🚨 Health Score Baixo',
          descricao: 'Health score do sistema: ${healthScore.toStringAsFixed(1)}%',
          severidade: healthScore < 50 ? 'critica' : 'alta',
          dados: snapshot.toJson(),
        );
      }

      // Alertas específicos por anomalia
      for (var anomalia in anomalias) {
        await _enviarAlertaAdmin(
          titulo: '⚠️ ${anomalia.tipo.name}',
          descricao: anomalia.descricao,
          severidade: anomalia.severidade.name,
          dados: anomalia.toJson(),
        );
      }

    } catch (e) {
      print('❌ Erro ao gerar alertas: $e');
    }
  }

  /// Envia alerta para administradores
  Future<void> _enviarAlertaAdmin({
    required String titulo,
    required String descricao,
    required String severidade,
    required Map<String, dynamic> dados,
  }) async {
    try {
      // Salvar alerta no banco
      await SupaFlow.client.from('system_alerts').insert({
        'title': titulo,
        'description': descricao,
        'severity': severidade,
        'data': dados,
        'created_at': DateTime.now().toIso8601String(),
        'is_resolved': false,
      });

      // TODO: Enviar notificação push para admins
      // TODO: Enviar email/slack se configurado

      print('🚨 Alerta gerado: $titulo - $descricao');

    } catch (e) {
      print('❌ Erro ao enviar alerta: $e');
    }
  }

  /// Salva métricas no histórico
  Future<void> _salvarMetricasHistorico(PerformanceSnapshot snapshot) async {
    try {
      await SupaFlow.client.from('performance_metrics').insert({
        'timestamp': snapshot.timestamp.toIso8601String(),
        'health_score': _calcularHealthScore(snapshot),
        'metrics_data': snapshot.toJson(),
        'created_at': DateTime.now().toIso8601String(),
      });

    } catch (e) {
      print('❌ Erro ao salvar métricas: $e');
    }
  }

  /// Métodos auxiliares de cálculo
  double _calcularTempoMedioViagem(List<dynamic> viagens) {
    if (viagens.isEmpty) return 0.0;

    double totalMinutos = 0.0;
    int count = 0;

    for (var viagem in viagens) {
      final criado = DateTime.tryParse(viagem['created_at'] ?? '');
      final completado = DateTime.tryParse(viagem['trip_completed_at'] ?? '');

      if (criado != null && completado != null) {
        totalMinutos += completado.difference(criado).inMinutes;
        count++;
      }
    }

    return count > 0 ? totalMinutos / count : 0.0;
  }

  double _calcularTaxaCancelamento(List<dynamic> viagensTotal, int cancelamentos) {
    final total = viagensTotal.length + cancelamentos;
    return total > 0 ? (cancelamentos / total) * 100 : 0.0;
  }

  double _calcularReceita24h(List<dynamic> viagens) {
    double receita = 0.0;
    for (var viagem in viagens) {
      receita += (viagem['total_fare'] as double?) ?? 0.0;
    }
    return receita;
  }

  /// Obtém relatório consolidado
  Future<RelatorioPerformance> gerarRelatorioConsolidado({
    DateTime? inicio,
    DateTime? fim,
  }) async {
    try {
      final agora = DateTime.now();
      final inicioRelatorio = inicio ?? agora.subtract(Duration(days: 7));
      final fimRelatorio = fim ?? agora;

      final metricas = await SupaFlow.client
          .from('performance_metrics')
          .select('*')
          .gte('timestamp', inicioRelatorio.toIso8601String())
          .lte('timestamp', fimRelatorio.toIso8601String())
          .order('timestamp', ascending: true);

      return RelatorioPerformance.fromMetricas(metricas, inicioRelatorio, fimRelatorio);

    } catch (e) {
      print('❌ Erro ao gerar relatório: $e');
      return RelatorioPerformance.empty();
    }
  }

  /// Obtém status atual do sistema
  Map<String, dynamic> get statusAtual {
    return {
      'monitoramento_ativo': _monitoringTimer?.isActive ?? false,
      'ultima_coleta': _realtimeMetrics.isNotEmpty
          ? _realtimeMetrics.last.timestamp.toIso8601String()
          : null,
      'metricas_cache': _kpiCache.length,
      'memoria_utilizada': _realtimeMetrics.length,
    };
  }
}

/// Classes de dados para métricas
class PerformanceSnapshot {
  final DateTime timestamp;
  final ViagensMetrics viagensMetrics;
  final MotoristasMetrics motoristasMetrics;
  final PassageirosMetrics passageirosMetrics;
  final FinanceiroMetrics financeiroMetrics;
  final DesempenhoMetrics desempenhoMetrics;
  final QualidadeMetrics qualidadeMetrics;

  PerformanceSnapshot({
    required this.timestamp,
    required this.viagensMetrics,
    required this.motoristasMetrics,
    required this.passageirosMetrics,
    required this.financeiroMetrics,
    required this.desempenhoMetrics,
    required this.qualidadeMetrics,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'viagens': viagensMetrics.toJson(),
      'motoristas': motoristasMetrics.toJson(),
      'passageiros': passageirosMetrics.toJson(),
      'financeiro': financeiroMetrics.toJson(),
      'desempenho': desempenhoMetrics.toJson(),
      'qualidade': qualidadeMetrics.toJson(),
    };
  }
}

class ViagensMetrics {
  final int viagensAtivas;
  final int solicitacoesPendentes;
  final int viagensCompletadasUltimaHora;
  final int viagensCompletadasUltimoDia;
  final int cancelamentosUltimaHora;
  final double tempoMedioViagem;
  final double taxaCancelamento;
  final double receita24h;

  ViagensMetrics({
    required this.viagensAtivas,
    required this.solicitacoesPendentes,
    required this.viagensCompletadasUltimaHora,
    required this.viagensCompletadasUltimoDia,
    required this.cancelamentosUltimaHora,
    required this.tempoMedioViagem,
    required this.taxaCancelamento,
    required this.receita24h,
  });

  factory ViagensMetrics.empty() {
    return ViagensMetrics(
      viagensAtivas: 0,
      solicitacoesPendentes: 0,
      viagensCompletadasUltimaHora: 0,
      viagensCompletadasUltimoDia: 0,
      cancelamentosUltimaHora: 0,
      tempoMedioViagem: 0.0,
      taxaCancelamento: 0.0,
      receita24h: 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'viagens_ativas': viagensAtivas,
      'solicitacoes_pendentes': solicitacoesPendentes,
      'viagens_completadas_ultima_hora': viagensCompletadasUltimaHora,
      'viagens_completadas_ultimo_dia': viagensCompletadasUltimoDia,
      'cancelamentos_ultima_hora': cancelamentosUltimaHora,
      'tempo_medio_viagem': tempoMedioViagem,
      'taxa_cancelamento': taxaCancelamento,
      'receita_24h': receita24h,
    };
  }
}

class MotoristasMetrics {
  final int totalMotoristas;
  final int motoristasOnline;
  final int motoristasAtivos;
  final int motoristasEmViagem;
  final double taxaUtilizacao;

  MotoristasMetrics({
    required this.totalMotoristas,
    required this.motoristasOnline,
    required this.motoristasAtivos,
    required this.motoristasEmViagem,
    required this.taxaUtilizacao,
  });

  factory MotoristasMetrics.empty() {
    return MotoristasMetrics(
      totalMotoristas: 0,
      motoristasOnline: 0,
      motoristasAtivos: 0,
      motoristasEmViagem: 0,
      taxaUtilizacao: 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_motoristas': totalMotoristas,
      'motoristas_online': motoristasOnline,
      'motoristas_ativos': motoristasAtivos,
      'motoristas_em_viagem': motoristasEmViagem,
      'taxa_utilizacao': taxaUtilizacao,
    };
  }
}

class PassageirosMetrics {
  final int totalPassageiros;
  final int passageirosAtivos24h;
  final int novosPassageiros24h;

  PassageirosMetrics({
    required this.totalPassageiros,
    required this.passageirosAtivos24h,
    required this.novosPassageiros24h,
  });

  factory PassageirosMetrics.empty() {
    return PassageirosMetrics(
      totalPassageiros: 0,
      passageirosAtivos24h: 0,
      novosPassageiros24h: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_passageiros': totalPassageiros,
      'passageiros_ativos_24h': passageirosAtivos24h,
      'novos_passageiros_24h': novosPassageiros24h,
    };
  }
}

class FinanceiroMetrics {
  final double receita24h;
  final double comissaoPlataforma24h;
  final double pagamentoMotoristas24h;
  final double ticketMedio;
  final int viagensComReceita;

  FinanceiroMetrics({
    required this.receita24h,
    required this.comissaoPlataforma24h,
    required this.pagamentoMotoristas24h,
    required this.ticketMedio,
    required this.viagensComReceita,
  });

  factory FinanceiroMetrics.empty() {
    return FinanceiroMetrics(
      receita24h: 0.0,
      comissaoPlataforma24h: 0.0,
      pagamentoMotoristas24h: 0.0,
      ticketMedio: 0.0,
      viagensComReceita: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'receita_24h': receita24h,
      'comissao_plataforma_24h': comissaoPlataforma24h,
      'pagamento_motoristas_24h': pagamentoMotoristas24h,
      'ticket_medio': ticketMedio,
      'viagens_com_receita': viagensComReceita,
    };
  }
}

class DesempenhoMetrics {
  final double tempoMedioMatching;
  final double taxaSucessoMatching;
  final int requestsUltimaHora;
  final int matchingsRealizados;

  DesempenhoMetrics({
    required this.tempoMedioMatching,
    required this.taxaSucessoMatching,
    required this.requestsUltimaHora,
    required this.matchingsRealizados,
  });

  factory DesempenhoMetrics.empty() {
    return DesempenhoMetrics(
      tempoMedioMatching: 0.0,
      taxaSucessoMatching: 0.0,
      requestsUltimaHora: 0,
      matchingsRealizados: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tempo_medio_matching': tempoMedioMatching,
      'taxa_sucesso_matching': taxaSucessoMatching,
      'requests_ultima_hora': requestsUltimaHora,
      'matchings_realizados': matchingsRealizados,
    };
  }
}

class QualidadeMetrics {
  final double mediaRatingPassageiros;
  final double mediaRatingMotoristas;
  final int totalAvaliacoes7dias;

  QualidadeMetrics({
    required this.mediaRatingPassageiros,
    required this.mediaRatingMotoristas,
    required this.totalAvaliacoes7dias,
  });

  factory QualidadeMetrics.empty() {
    return QualidadeMetrics(
      mediaRatingPassageiros: 0.0,
      mediaRatingMotoristas: 0.0,
      totalAvaliacoes7dias: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'media_rating_passageiros': mediaRatingPassageiros,
      'media_rating_motoristas': mediaRatingMotoristas,
      'total_avaliacoes_7dias': totalAvaliacoes7dias,
    };
  }
}

class PerformanceMetric {
  final DateTime timestamp;
  final String metricName;
  final double value;
  final Map<String, dynamic>? metadata;

  PerformanceMetric({
    required this.timestamp,
    required this.metricName,
    required this.value,
    this.metadata,
  });
}

class AnomaliaDetectada {
  final TipoAnomalia tipo;
  final SeveridadeAnomalia severidade;
  final String descricao;
  final double valor;
  final double threshold;

  AnomaliaDetectada({
    required this.tipo,
    required this.severidade,
    required this.descricao,
    required this.valor,
    required this.threshold,
  });

  Map<String, dynamic> toJson() {
    return {
      'tipo': tipo.name,
      'severidade': severidade.name,
      'descricao': descricao,
      'valor': valor,
      'threshold': threshold,
    };
  }
}

class RelatorioPerformance {
  final DateTime inicio;
  final DateTime fim;
  final Map<String, dynamic> resumo;
  final List<Map<String, dynamic>> tendencias;

  RelatorioPerformance({
    required this.inicio,
    required this.fim,
    required this.resumo,
    required this.tendencias,
  });

  factory RelatorioPerformance.fromMetricas(
    List<dynamic> metricas,
    DateTime inicio,
    DateTime fim,
  ) {
    // Implementar processamento das métricas
    return RelatorioPerformance(
      inicio: inicio,
      fim: fim,
      resumo: {},
      tendencias: [],
    );
  }

  factory RelatorioPerformance.empty() {
    final agora = DateTime.now();
    return RelatorioPerformance(
      inicio: agora,
      fim: agora,
      resumo: {},
      tendencias: [],
    );
  }
}

enum TipoAnomalia {
  altaDemanda,
  baixaDisponibilidade,
  altoCancelamento,
  tempoMatchingAlto,
  receitaBaixa,
  ratingBaixo,
}

enum SeveridadeAnomalia {
  baixa,
  media,
  alta,
  critica,
}