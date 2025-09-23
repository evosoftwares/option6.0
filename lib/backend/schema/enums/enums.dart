import 'package:collection/collection.dart';

enum Permissao {
  cliente,
  prestador,
  motorista,
  empresa,
  adminApp,
}

enum StatusServico {
  ativo,
  inativo,
  concluido,
  cancelado,
}

enum AreasAtuacao {
  TecnologiaeDigital,
  ComunicaoMarketingeMdia,
  ServiosEmpresariaiseProfissionais,
  ServiosJurdicos,
  EducaoeIdiomas,
  SadeeBemEstar,
  BelezaModaeCuidadosPessoais,
  ConstruoImveiseReformas,
  ServiosDomsticoseManutenoResidencial,
  Automotivo,
  TransporteeLogstica,
  EventosTurismoeAlimentao,
  ServiosparaPets,
  ArtesCulturaeEntretenimento,
  EsporteseFitness,
  Segurana,
  MeioAmbienteeSustentabilidade,
  CuidadosFamiliareseAssistncia,
}

enum StatusConversaPeloStatusServico {
  andamento,
  finalizada,
}

enum TipoFoto {
  Foto,
}

enum TipoMovimento {
  entrada,
  saida,
  indicacao,
}

enum TipoChavePix {
  CPF,
  CNPJ,
  EMAIL,
  PHONE,
  EVP,
}

enum StatuscontratosEmpresaPrestador {
  ativo,
  inativo,
  pendente_convite,
}

enum TipoMissoes {
  publica,
  privada_empresa,
}

enum StatusMissoes {
  missoesEmAgendamento,
  missoesCancelada,
  missoesConcluida,
  missoesIniciadaFundosDepositados,
  missoesFundosLiberadosFim,
  missoesSolicitacaoAceita,
  missoesSolicitacaoPendente,
  missoesSolicitacaoRecusada,
}

enum StatusCorridas {
  Solicitado,
  Aceito,
  Concluido,
  Cancelado,
  emAndamento,
  motoristaChegou,
}

enum Cor {
  Branco,
  Preto,
  Prata,
  Cinza,
  Azul,
  Vermelho,
  Verde,
  Marrom,
  Bege,
  Amarelo,
  Laranja,
  Dourado,
  Vinho,
  Roxo,
  Rosa,
  Grafite,
  Chumbo,
  Creme,
  Gelo,
  Cobre,
  Turquesa,
  Lilas,
  Salmao,
}

enum TipoVeiculoEnum {
  HATCH,
  SEDAN,
  SUV,
  PICAPE,
  MOTO,
  OUTRO,
}

enum Nivel {
  Ouro,
  Prata,
  Bronze,
}

enum StatusPromotor {
  ativo,
  inativo,
}

enum TipoProduto {
  geladeira,
  congelador,
  prateleira,
}

enum Corredor {
  nivel1,
  nivel2,
  nivel3,
  prateleira,
}

enum RepeticaoServico {
  semanalmente,
  duasSemanas,
  mensal,
}

enum StatusRelatorio {
  comecado,
  finalizado,
  entregue,
}

extension FFEnumExtensions<T extends Enum> on T {
  String serialize() => name;
}

extension FFEnumListExtensions<T extends Enum> on Iterable<T> {
  T? deserialize(String? value) =>
      firstWhereOrNull((e) => e.serialize() == value);
}

T? deserializeEnum<T>(String? value) {
  switch (T) {
    case (Permissao):
      return Permissao.values.deserialize(value) as T?;
    case (StatusServico):
      return StatusServico.values.deserialize(value) as T?;
    case (AreasAtuacao):
      return AreasAtuacao.values.deserialize(value) as T?;
    case (StatusConversaPeloStatusServico):
      return StatusConversaPeloStatusServico.values.deserialize(value) as T?;
    case (TipoFoto):
      return TipoFoto.values.deserialize(value) as T?;
    case (TipoMovimento):
      return TipoMovimento.values.deserialize(value) as T?;
    case (TipoChavePix):
      return TipoChavePix.values.deserialize(value) as T?;
    case (StatuscontratosEmpresaPrestador):
      return StatuscontratosEmpresaPrestador.values.deserialize(value) as T?;
    case (TipoMissoes):
      return TipoMissoes.values.deserialize(value) as T?;
    case (StatusMissoes):
      return StatusMissoes.values.deserialize(value) as T?;
    case (StatusCorridas):
      return StatusCorridas.values.deserialize(value) as T?;
    case (Cor):
      return Cor.values.deserialize(value) as T?;
    case (TipoVeiculoEnum):
      return TipoVeiculoEnum.values.deserialize(value) as T?;
    case (Nivel):
      return Nivel.values.deserialize(value) as T?;
    case (StatusPromotor):
      return StatusPromotor.values.deserialize(value) as T?;
    case (TipoProduto):
      return TipoProduto.values.deserialize(value) as T?;
    case (Corredor):
      return Corredor.values.deserialize(value) as T?;
    case (RepeticaoServico):
      return RepeticaoServico.values.deserialize(value) as T?;
    case (StatusRelatorio):
      return StatusRelatorio.values.deserialize(value) as T?;
    default:
      return null;
  }
}
