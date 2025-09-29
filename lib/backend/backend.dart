import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../auth/firebase_auth/auth_util.dart';

import '../../flutter_flow/flutter_flow_util.dart';
import 'schema/util/firestore_util.dart';

import 'schema/users_record.dart';
import 'schema/categoria_record.dart';
import 'schema/conversas_record.dart';
import 'schema/mensagens_record.dart';
import 'schema/movimento_creditos_record.dart';
import 'schema/bot_whatsapp_record.dart';
import 'schema/saques_record.dart';
import 'schema/transacoes_asaas_record.dart';
import 'schema/perfis_prestador_record.dart';
import 'schema/perfis_empresa_record.dart';
import 'schema/perfis_motorista_record.dart';
import 'schema/contratos_empresa_prestador_record.dart';
import 'schema/missoes_record.dart';
import 'schema/corridas_record.dart';
import 'schema/carteiras_record.dart';
import 'schema/avaliacoes_record.dart';
import 'schema/categorias_mobilidade_record.dart';
import 'schema/avaliacoes_servico_record.dart';
import 'schema/veiculo_record.dart';
import 'schema/requerimento_record.dart';
import 'schema/configuracao_adm_record.dart';
import 'schema/perfil_promotor_record.dart';
import 'schema/responsavel_agencia_record.dart';
import 'schema/marca_record.dart';
import 'schema/produto_record.dart';
import 'schema/agencia_record.dart';
import 'schema/relatorio_record.dart';
import 'schema/ordem_de_servico_empresa_record.dart';
import 'schema/endereamento_record.dart';

export 'dart:async' show StreamSubscription;
export 'package:cloud_firestore/cloud_firestore.dart' hide Order;
export 'package:firebase_core/firebase_core.dart';
export 'schema/index.dart';
export 'schema/util/firestore_util.dart';
export 'schema/util/schema_util.dart';

export 'schema/users_record.dart';
export 'schema/categoria_record.dart';
export 'schema/conversas_record.dart';
export 'schema/mensagens_record.dart';
export 'schema/movimento_creditos_record.dart';
export 'schema/bot_whatsapp_record.dart';
export 'schema/saques_record.dart';
export 'schema/transacoes_asaas_record.dart';
export 'schema/perfis_prestador_record.dart';
export 'schema/perfis_empresa_record.dart';
export 'schema/perfis_motorista_record.dart';
export 'schema/contratos_empresa_prestador_record.dart';
export 'schema/missoes_record.dart';
export 'schema/corridas_record.dart';
export 'schema/carteiras_record.dart';
export 'schema/avaliacoes_record.dart';
export 'schema/categorias_mobilidade_record.dart';
export 'schema/avaliacoes_servico_record.dart';
export 'schema/veiculo_record.dart';
export 'schema/requerimento_record.dart';
export 'schema/configuracao_adm_record.dart';
export 'schema/perfil_promotor_record.dart';
export 'schema/responsavel_agencia_record.dart';
export 'schema/marca_record.dart';
export 'schema/produto_record.dart';
export 'schema/agencia_record.dart';
export 'schema/relatorio_record.dart';
export 'schema/ordem_de_servico_empresa_record.dart';
export 'schema/endereamento_record.dart';

/// Functions to query UsersRecords (as a Stream and as a Future).
Future<int> queryUsersRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      UsersRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<UsersRecord>> queryUsersRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      UsersRecord.collection,
      UsersRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<UsersRecord>> queryUsersRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      UsersRecord.collection,
      UsersRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query CategoriaRecords (as a Stream and as a Future).
Future<int> queryCategoriaRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      CategoriaRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<CategoriaRecord>> queryCategoriaRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      CategoriaRecord.collection,
      CategoriaRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<CategoriaRecord>> queryCategoriaRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      CategoriaRecord.collection,
      CategoriaRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query ConversasRecords (as a Stream and as a Future).
Future<int> queryConversasRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      ConversasRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<ConversasRecord>> queryConversasRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      ConversasRecord.collection,
      ConversasRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<ConversasRecord>> queryConversasRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      ConversasRecord.collection,
      ConversasRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query MensagensRecords (as a Stream and as a Future).
Future<int> queryMensagensRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      MensagensRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<MensagensRecord>> queryMensagensRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      MensagensRecord.collection,
      MensagensRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<MensagensRecord>> queryMensagensRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      MensagensRecord.collection,
      MensagensRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query MovimentoCreditosRecords (as a Stream and as a Future).
Future<int> queryMovimentoCreditosRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      MovimentoCreditosRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<MovimentoCreditosRecord>> queryMovimentoCreditosRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      MovimentoCreditosRecord.collection,
      MovimentoCreditosRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<MovimentoCreditosRecord>> queryMovimentoCreditosRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      MovimentoCreditosRecord.collection,
      MovimentoCreditosRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query BotWhatsappRecords (as a Stream and as a Future).
Future<int> queryBotWhatsappRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      BotWhatsappRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<BotWhatsappRecord>> queryBotWhatsappRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      BotWhatsappRecord.collection,
      BotWhatsappRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<BotWhatsappRecord>> queryBotWhatsappRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      BotWhatsappRecord.collection,
      BotWhatsappRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query SaquesRecords (as a Stream and as a Future).
Future<int> querySaquesRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      SaquesRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<SaquesRecord>> querySaquesRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      SaquesRecord.collection,
      SaquesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<SaquesRecord>> querySaquesRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      SaquesRecord.collection,
      SaquesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query TransacoesAsaasRecords (as a Stream and as a Future).
Future<int> queryTransacoesAsaasRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      TransacoesAsaasRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<TransacoesAsaasRecord>> queryTransacoesAsaasRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      TransacoesAsaasRecord.collection,
      TransacoesAsaasRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<TransacoesAsaasRecord>> queryTransacoesAsaasRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      TransacoesAsaasRecord.collection,
      TransacoesAsaasRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query PerfisPrestadorRecords (as a Stream and as a Future).
Future<int> queryPerfisPrestadorRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      PerfisPrestadorRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<PerfisPrestadorRecord>> queryPerfisPrestadorRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      PerfisPrestadorRecord.collection,
      PerfisPrestadorRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<PerfisPrestadorRecord>> queryPerfisPrestadorRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      PerfisPrestadorRecord.collection,
      PerfisPrestadorRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query PerfisEmpresaRecords (as a Stream and as a Future).
Future<int> queryPerfisEmpresaRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      PerfisEmpresaRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<PerfisEmpresaRecord>> queryPerfisEmpresaRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      PerfisEmpresaRecord.collection,
      PerfisEmpresaRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<PerfisEmpresaRecord>> queryPerfisEmpresaRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      PerfisEmpresaRecord.collection,
      PerfisEmpresaRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query PerfisMotoristaRecords (as a Stream and as a Future).
Future<int> queryPerfisMotoristaRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      PerfisMotoristaRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<PerfisMotoristaRecord>> queryPerfisMotoristaRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      PerfisMotoristaRecord.collection,
      PerfisMotoristaRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<PerfisMotoristaRecord>> queryPerfisMotoristaRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      PerfisMotoristaRecord.collection,
      PerfisMotoristaRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query ContratosEmpresaPrestadorRecords (as a Stream and as a Future).
Future<int> queryContratosEmpresaPrestadorRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      ContratosEmpresaPrestadorRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<ContratosEmpresaPrestadorRecord>>
    queryContratosEmpresaPrestadorRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
        queryCollection(
          ContratosEmpresaPrestadorRecord.collection,
          ContratosEmpresaPrestadorRecord.fromSnapshot,
          queryBuilder: queryBuilder,
          limit: limit,
          singleRecord: singleRecord,
        );

Future<List<ContratosEmpresaPrestadorRecord>>
    queryContratosEmpresaPrestadorRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
        queryCollectionOnce(
          ContratosEmpresaPrestadorRecord.collection,
          ContratosEmpresaPrestadorRecord.fromSnapshot,
          queryBuilder: queryBuilder,
          limit: limit,
          singleRecord: singleRecord,
        );

/// Functions to query MissoesRecords (as a Stream and as a Future).
Future<int> queryMissoesRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      MissoesRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<MissoesRecord>> queryMissoesRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      MissoesRecord.collection,
      MissoesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<MissoesRecord>> queryMissoesRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      MissoesRecord.collection,
      MissoesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query CorridasRecords (as a Stream and as a Future).
Future<int> queryCorridasRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      CorridasRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<CorridasRecord>> queryCorridasRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      CorridasRecord.collection,
      CorridasRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<CorridasRecord>> queryCorridasRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      CorridasRecord.collection,
      CorridasRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query CarteirasRecords (as a Stream and as a Future).
Future<int> queryCarteirasRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      CarteirasRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<CarteirasRecord>> queryCarteirasRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      CarteirasRecord.collection,
      CarteirasRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<CarteirasRecord>> queryCarteirasRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      CarteirasRecord.collection,
      CarteirasRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query AvaliacoesRecords (as a Stream and as a Future).
Future<int> queryAvaliacoesRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      AvaliacoesRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<AvaliacoesRecord>> queryAvaliacoesRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      AvaliacoesRecord.collection,
      AvaliacoesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<AvaliacoesRecord>> queryAvaliacoesRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      AvaliacoesRecord.collection,
      AvaliacoesRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query CategoriasMobilidadeRecords (as a Stream and as a Future).
Future<int> queryCategoriasMobilidadeRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      CategoriasMobilidadeRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<CategoriasMobilidadeRecord>> queryCategoriasMobilidadeRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      CategoriasMobilidadeRecord.collection,
      CategoriasMobilidadeRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<CategoriasMobilidadeRecord>> queryCategoriasMobilidadeRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      CategoriasMobilidadeRecord.collection,
      CategoriasMobilidadeRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query AvaliacoesServicoRecords (as a Stream and as a Future).
Future<int> queryAvaliacoesServicoRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      AvaliacoesServicoRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<AvaliacoesServicoRecord>> queryAvaliacoesServicoRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      AvaliacoesServicoRecord.collection,
      AvaliacoesServicoRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<AvaliacoesServicoRecord>> queryAvaliacoesServicoRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      AvaliacoesServicoRecord.collection,
      AvaliacoesServicoRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query VeiculoRecords (as a Stream and as a Future).
Future<int> queryVeiculoRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      VeiculoRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<VeiculoRecord>> queryVeiculoRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      VeiculoRecord.collection,
      VeiculoRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<VeiculoRecord>> queryVeiculoRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      VeiculoRecord.collection,
      VeiculoRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query RequerimentoRecords (as a Stream and as a Future).
Future<int> queryRequerimentoRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      RequerimentoRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<RequerimentoRecord>> queryRequerimentoRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      RequerimentoRecord.collection,
      RequerimentoRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<RequerimentoRecord>> queryRequerimentoRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      RequerimentoRecord.collection,
      RequerimentoRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query ConfiguracaoAdmRecords (as a Stream and as a Future).
Future<int> queryConfiguracaoAdmRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      ConfiguracaoAdmRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<ConfiguracaoAdmRecord>> queryConfiguracaoAdmRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      ConfiguracaoAdmRecord.collection,
      ConfiguracaoAdmRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<ConfiguracaoAdmRecord>> queryConfiguracaoAdmRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      ConfiguracaoAdmRecord.collection,
      ConfiguracaoAdmRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query PerfilPromotorRecords (as a Stream and as a Future).
Future<int> queryPerfilPromotorRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      PerfilPromotorRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<PerfilPromotorRecord>> queryPerfilPromotorRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      PerfilPromotorRecord.collection,
      PerfilPromotorRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<PerfilPromotorRecord>> queryPerfilPromotorRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      PerfilPromotorRecord.collection,
      PerfilPromotorRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query ResponsavelAgenciaRecords (as a Stream and as a Future).
Future<int> queryResponsavelAgenciaRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      ResponsavelAgenciaRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<ResponsavelAgenciaRecord>> queryResponsavelAgenciaRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      ResponsavelAgenciaRecord.collection,
      ResponsavelAgenciaRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<ResponsavelAgenciaRecord>> queryResponsavelAgenciaRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      ResponsavelAgenciaRecord.collection,
      ResponsavelAgenciaRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query MarcaRecords (as a Stream and as a Future).
Future<int> queryMarcaRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      MarcaRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<MarcaRecord>> queryMarcaRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      MarcaRecord.collection,
      MarcaRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<MarcaRecord>> queryMarcaRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      MarcaRecord.collection,
      MarcaRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query ProdutoRecords (as a Stream and as a Future).
Future<int> queryProdutoRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      ProdutoRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<ProdutoRecord>> queryProdutoRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      ProdutoRecord.collection,
      ProdutoRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<ProdutoRecord>> queryProdutoRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      ProdutoRecord.collection,
      ProdutoRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query AgenciaRecords (as a Stream and as a Future).
Future<int> queryAgenciaRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      AgenciaRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<AgenciaRecord>> queryAgenciaRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      AgenciaRecord.collection,
      AgenciaRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<AgenciaRecord>> queryAgenciaRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      AgenciaRecord.collection,
      AgenciaRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query RelatorioRecords (as a Stream and as a Future).
Future<int> queryRelatorioRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      RelatorioRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<RelatorioRecord>> queryRelatorioRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      RelatorioRecord.collection,
      RelatorioRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<RelatorioRecord>> queryRelatorioRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      RelatorioRecord.collection,
      RelatorioRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query OrdemDeServicoEmpresaRecords (as a Stream and as a Future).
Future<int> queryOrdemDeServicoEmpresaRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      OrdemDeServicoEmpresaRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<OrdemDeServicoEmpresaRecord>> queryOrdemDeServicoEmpresaRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      OrdemDeServicoEmpresaRecord.collection,
      OrdemDeServicoEmpresaRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<OrdemDeServicoEmpresaRecord>> queryOrdemDeServicoEmpresaRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      OrdemDeServicoEmpresaRecord.collection,
      OrdemDeServicoEmpresaRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

/// Functions to query EndereamentoRecords (as a Stream and as a Future).
Future<int> queryEndereamentoRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      EndereamentoRecord.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<EndereamentoRecord>> queryEndereamentoRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      EndereamentoRecord.collection,
      EndereamentoRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<EndereamentoRecord>> queryEndereamentoRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      EndereamentoRecord.collection,
      EndereamentoRecord.fromSnapshot,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<int> queryCollectionCount(
  Query collection, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0) {
    query = query.limit(limit);
  }

  // Ensure the error handler returns an int, not AggregateQuerySnapshot
  return query
      .count()
      .get()
      .then((value) => value.count!)
      .catchError((err) {
    print('Error querying $collection: $err');
    return 0;
  });
}

Stream<List<T>> queryCollection<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0 || singleRecord) {
    query = query.limit(singleRecord ? 1 : limit);
  }
  return query.snapshots().handleError((err) {
    print('Error querying $collection: $err');
  }).map((s) => s.docs
      .map(
        (d) => safeGet(
          () => recordBuilder(d),
          (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
        ),
      )
      .where((d) => d != null)
      .map((d) => d!)
      .toList());
}

Future<List<T>> queryCollectionOnce<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0 || singleRecord) {
    query = query.limit(singleRecord ? 1 : limit);
  }
  return query.get().then((s) => s.docs
      .map(
        (d) => safeGet(
          () => recordBuilder(d),
          (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
        ),
      )
      .where((d) => d != null)
      .map((d) => d!)
      .toList());
}

Filter filterIn(String field, List? list) => (list?.isEmpty ?? true)
    ? Filter(field, whereIn: null)
    : Filter(field, whereIn: list);

Filter filterArrayContainsAny(String field, List? list) =>
    (list?.isEmpty ?? true)
        ? Filter(field, arrayContainsAny: null)
        : Filter(field, arrayContainsAny: list);

extension QueryExtension on Query {
  Query whereIn(String field, List? list) => (list?.isEmpty ?? true)
      ? where(field, whereIn: null)
      : where(field, whereIn: list);

  Query whereNotIn(String field, List? list) => (list?.isEmpty ?? true)
      ? where(field, whereNotIn: null)
      : where(field, whereNotIn: list);

  Query whereArrayContainsAny(String field, List? list) =>
      (list?.isEmpty ?? true)
          ? where(field, arrayContainsAny: null)
          : where(field, arrayContainsAny: list);
}

class FFFirestorePage<T> {
  final List<T> data;
  final Stream<List<T>>? dataStream;
  final QueryDocumentSnapshot? nextPageMarker;

  FFFirestorePage(this.data, this.dataStream, this.nextPageMarker);
}

Future<FFFirestorePage<T>> queryCollectionPage<T>(
  Query collection,
  RecordBuilder<T> recordBuilder, {
  Query Function(Query)? queryBuilder,
  DocumentSnapshot? nextPageMarker,
  required int pageSize,
  required bool isStream,
}) async {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection).limit(pageSize);
  if (nextPageMarker != null) {
    query = query.startAfterDocument(nextPageMarker);
  }
  Stream<QuerySnapshot>? docSnapshotStream;
  QuerySnapshot docSnapshot;
  if (isStream) {
    docSnapshotStream = query.snapshots();
    docSnapshot = await docSnapshotStream.first;
  } else {
    docSnapshot = await query.get();
  }
  final getDocs = (QuerySnapshot s) => s.docs
      .map(
        (d) => safeGet(
          () => recordBuilder(d),
          (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
        ),
      )
      .where((d) => d != null)
      .map((d) => d!)
      .toList();
  final data = getDocs(docSnapshot);
  final dataStream = docSnapshotStream?.map(getDocs);
  final nextPageToken = docSnapshot.docs.isEmpty ? null : docSnapshot.docs.last;
  return FFFirestorePage(data, dataStream, nextPageToken);
}

// Creates a Firestore document representing the logged in user if it doesn't yet exist
Future maybeCreateUser(User user) async {
  final userRecord = UsersRecord.collection.doc(user.uid);
  final userExists = await userRecord.get().then((u) => u.exists);
  if (userExists) {
    currentUserDocument = await UsersRecord.getDocumentOnce(userRecord);
    return;
  }

  final userData = createUsersRecordData(
    email: user.email ??
        FirebaseAuth.instance.currentUser?.email ??
        user.providerData.firstOrNull?.email,
    displayName:
        user.displayName ?? FirebaseAuth.instance.currentUser?.displayName,
    photoUrl: user.photoURL,
    uid: user.uid,
    phoneNumber: user.phoneNumber,
    createdTime: getCurrentTimestamp,
  );

  await userRecord.set(userData);
  currentUserDocument = UsersRecord.getDocumentFromData(userData, userRecord);
}

Future updateUserDocument({String? email}) async {
  await currentUserDocument?.reference
      .update(createUsersRecordData(email: email));
}
// Compatibilidade: variável do documento de usuário atual (Firestore)
UsersRecord? currentUserDocument;
