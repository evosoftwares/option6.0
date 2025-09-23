// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

/// Executa a lógica de negócio para um motorista aceitar uma corrida.
///
/// Esta ação realiza um conjunto de operações atómicas no Firestore para garantir
/// a consistência dos dados. As operações incluem:
/// 1. Validar os dados de entrada.
/// 2. Ler os documentos necessários (corrida, perfil, veículo, usuário).
/// 3. Criar uma nova conversa e a primeira mensagem entre motorista e passageiro.
/// 4. Atualizar o status da corrida para 'Aceito'.
/// 5. Vincular o motorista, os dados do veículo e a conversa à corrida.
/// 6. Atribuir o ID da viagem ao documento do motorista.
///
/// @param userMotoristaRef Referência para o documento 'users' do motorista.
/// @param perfilMotoristaRef Referência para o documento 'perfisMotorista' do motorista.
/// @param corridaRef Referência para o documento 'corridas' que está sendo aceite.
Future<void> aceitarCorrida(
  DocumentReference? userMotoristaRef,
  DocumentReference? perfilMotoristaRef,
  DocumentReference? corridaRef,
) async {
  // Valida a integridade dos parâmetros para prevenir operações com referências nulas.
  if (userMotoristaRef == null ||
      perfilMotoristaRef == null ||
      corridaRef == null) {
    // Em produção, este log deve ser substituído por um serviço de monitoramento de erros.
    print(
        'Erro Crítico: Referências nulas foram passadas para a ação aceitarCorrida.');
    return;
  }

  final firestore = FirebaseFirestore.instance;

  try {
    // --- ETAPA 1: Leitura e Validação de Dados ---
    // Realiza a leitura de todos os documentos necessários antes de iniciar a escrita.
    // Esta abordagem "read-first" garante que todos os dados existem e são válidos
    // antes de comprometer a transação no banco de dados.

    // Obtém a referência do passageiro a partir do documento da corrida.
    final corridaDoc = await corridaRef.get();
    if (!corridaDoc.exists) {
      print(
          'Erro de consistência: Documento da corrida ${corridaRef.id} não encontrado.');
      return;
    }
    final corridaData = corridaDoc.data() as Map<String, dynamic>;
    final DocumentReference? userPassageiroRef = corridaData['idPassageiro'];

    if (userPassageiroRef == null) {
      print(
          'Erro de dados: A corrida ${corridaRef.id} não tem um passageiro definido.');
      return;
    }

    // Obtém a referência do veículo atual a partir do perfil do motorista.
    final perfilDoc = await perfilMotoristaRef.get();
    if (!perfilDoc.exists) {
      print(
          'Erro de consistência: Perfil do motorista ${perfilMotoristaRef.id} não encontrado.');
      return;
    }
    final perfilData = perfilDoc.data() as Map<String, dynamic>;
    final DocumentReference? veiculoRef = perfilData['veiculoAtual'];

    if (veiculoRef == null) {
      print(
          'Erro de negócio: Motorista ${perfilMotoristaRef.id} não tem um veículo atual selecionado.');
      return;
    }

    // Desnormaliza os dados do veículo para a corrida. Isso garante a imutabilidade
    // dos dados históricos, mesmo que o motorista troque de veículo no futuro.
    final veiculoDoc = await veiculoRef.get();
    if (!veiculoDoc.exists) {
      print(
          'Erro de consistência: Documento do veículo ${veiculoRef.id} não encontrado.');
      return;
    }
    final veiculoData = veiculoDoc.data() as Map<String, dynamic>;
    final String marca = veiculoData['marca'] ?? 'N/A';
    final String modelo = veiculoData['modelo'] ?? 'N/A';
    final String cor = veiculoData['cor'] ?? 'N/A';
    final String placa = veiculoData['placa'] ?? 'N/A';

    // Obtém o nome de exibição do motorista para fácil acesso na UI do passageiro.
    final userDoc = await userMotoristaRef.get();
    if (!userDoc.exists) {
      print(
          'Erro de consistência: Documento do usuário motorista ${userMotoristaRef.id} não encontrado.');
      return;
    }
    final userData = userDoc.data() as Map<String, dynamic>;
    final String nomeMotorista = userData['display_name'] ?? 'Motorista';

    // --- ETAPA 2: Transação Atómica com Batch Write ---
    // Todas as modificações no Firestore são agrupadas em um único batch.
    // Isso garante a atomicidade da operação: ou todas as escritas são bem-sucedidas,
    // ou nenhuma é, mantendo a consistência dos dados em caso de falha.
    final batch = firestore.batch();

    // --- LÓGICA DE CRIAÇÃO DA CONVERSA ---

    // 1. Cria uma nova referência para o documento de Conversa.
    final novaConversaRef = firestore.collection('Conversas').doc();

    // 2. Adiciona a criação da Conversa ao batch.
    batch.set(novaConversaRef, {
      'participantes': [userMotoristaRef, userPassageiroRef],
      // O array 'quemLeu' é inicializado apenas com o motorista, assegurando
      // que a conversa apareça como "não lida" para o passageiro.
      'quemLeu': [userMotoristaRef],
      'ultimaMensagemTempo': DateTime.now(),
      'conversaId': novaConversaRef.id,
      // Define o status inicial da conversa usando o Enum para garantir consistência.
      'statusConversa': StatusConversaPeloStatusServico.andamento.name,
    });

    // 3. Cria uma nova referência para a primeira Mensagem.
    final novaMensagemRef = firestore.collection('Mensagens').doc();

    // 4. Adiciona a criação da primeira Mensagem (padrão) ao batch.
    batch.set(novaMensagemRef, {
      'enviadoPor': userMotoristaRef,
      'conversaID': novaConversaRef,
      'mensagem': 'Olá! Estou a caminho para te buscar.',
      'createdAt': DateTime.now(),
      'mensagensId': novaMensagemRef.id,
      'ehMensagem': true, // Confirma que este registro é uma mensagem de texto.
    });

    // 5. Atualiza a Conversa recém-criada com a referência da última mensagem para ordenação.
    batch.update(novaConversaRef, {
      'ultimaMensagem': novaMensagemRef,
      'ultimaMensagemEnviadaPor': userMotoristaRef,
    });

    // --- LÓGICA DE ATUALIZAÇÃO DA CORRIDA ---

    // 6. Atualiza o documento da corrida com os dados consolidados.
    batch.update(corridaRef, {
      'motoristasDisponiveis':
          [], // Limpa a lista de motoristas que poderiam aceitar.
      'idMotorista': userMotoristaRef, // Atribui o motorista que aceitou.
      'status': StatusCorridas.Aceito.name, // Muda o status da corrida.
      'marca': marca, // Salva os dados do veículo como string para histórico.
      'modelo': modelo,
      'cor': cor,
      'placa': placa,
      'nomeMotorista':
          nomeMotorista, // Salva o nome do motorista para fácil acesso.
      'conversa': novaConversaRef, // Associa a conversa à corrida.
    });

    // 7. Atualiza o documento do usuário (motorista) para indicar que ele está em viagem.
    batch.update(userMotoristaRef, {
      'idViagem': corridaRef,
    });

    // Confirma e executa todas as operações no batch de forma atómica.
    await batch.commit();

    print(
        'Corrida ${corridaRef.id} aceita com sucesso pelo motorista ${userMotoristaRef.id}. Conversa ${novaConversaRef.id} iniciada.');
  } catch (e) {
    // Em produção, logar este erro em um serviço de monitoramento (ex: Sentry, Firebase Crashlytics).
    print('ERRO FATAL ao executar a ação aceitarCorrida: $e');
  }
}
