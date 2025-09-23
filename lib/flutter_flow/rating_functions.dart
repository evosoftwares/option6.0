import '/custom_code/actions/integrar_avaliacao_viagem.dart' as integration;
import '/custom_code/actions/notificar_avaliacao_pendente.dart' as notifications;
import 'package:flutter/material.dart';

/// Funções utilitárias para o sistema de avaliações
/// Facilita a integração com telas existentes

/// Exemplo de uso após finalizar uma viagem
/// Chame esta função quando o status da viagem mudar para 'completed'
Future<void> exemploFinalizarViagemComAvaliacao(
  BuildContext context,
  String tripId,
) async {
  // Finalizar viagem e programar avaliações
  final resultado = await integration.finalizarViagemComAvaliacao(
    tripId,
    context,
  );

  if (resultado['sucesso'] == true) {
    print('✅ Viagem finalizada com sucesso!');
    print('📧 Notificações de avaliação programadas');
  } else {
    print('❌ Erro ao finalizar viagem: ${resultado['erro']}');
  }
}

/// Exemplo de como navegar para avaliação a partir de uma notificação
Future<void> exemploAbrirAvaliacaoDeNotificacao(
  BuildContext context,
  String tripId,
  String tipoAvaliacao,
  String currentUserId,
  String tipoUsuario,
) async {
  // Verificar se o usuário pode avaliar
  final permissao = await integration.verificarPermissaoAvaliacao(
    tripId,
    currentUserId,
    tipoUsuario,
  );

  if (permissao['pode_avaliar'] == true) {
    // Navegar para tela de avaliação
    await integration.navegarParaTelaAvaliacao(
      context,
      tripId,
      tipoAvaliacao,
    );
  } else {
    // Mostrar motivo pelo qual não pode avaliar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(permissao['motivo'] ?? 'Não é possível avaliar esta viagem'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

/// Exemplo de como mostrar rating na tela do usuário
Widget exemploWidgetRatingUsuario(
  double averageRating,
  int totalTrips,
  {double tamanho = 20.0}
) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Exibir estrelas baseado no rating
      ...List.generate(5, (index) {
        return Icon(
          index < averageRating.floor()
              ? Icons.star
              : (index < averageRating)
                  ? Icons.star_half
                  : Icons.star_border,
          color: Colors.amber,
          size: tamanho,
        );
      }),
      SizedBox(width: 8.0),
      Text(
        '${averageRating.toStringAsFixed(1)} (${totalTrips} viagens)',
        style: TextStyle(
          fontSize: tamanho * 0.8,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

/// Exemplo de como buscar e exibir notificações de avaliação
Future<List<String>> exemploObterNotificacoesAvaliacao(String userId) async {
  final notificacoes = await notifications.buscarNotificacoesNaoLidas(userId);

  return notificacoes
      .where((n) => n.type == 'avaliacao_pendente' || n.type == 'lembrete_avaliacao')
      .map((n) => n.title ?? 'Nova notificação')
      .toList();
}

/// Instruções de uso para desenvolvedores:
///
/// 1. FINALIZAR VIAGEM COM AVALIAÇÃO:
/// ```dart
/// await exemploFinalizarViagemComAvaliacao(context, tripId);
/// ```
///
/// 2. ABRIR TELA DE AVALIAÇÃO:
/// ```dart
/// context.pushNamed(
///   'avaliarMotorista',
///   queryParameters: {'tripId': tripId},
/// );
/// ```
///
/// 3. VERIFICAR SE PODE AVALIAR:
/// ```dart
/// final pode = await integration.verificarPermissaoAvaliacao(
///   tripId, userId, 'driver'
/// );
/// ```
///
/// 4. MOSTRAR RATING DO USUÁRIO:
/// ```dart
/// final stats = await integration.obterEstatisticasAvaliacao(
///   userId, 'driver'
/// );
/// exemploWidgetRatingUsuario(
///   stats['rating_medio'],
///   stats['total_viagens']
/// );
/// ```
///