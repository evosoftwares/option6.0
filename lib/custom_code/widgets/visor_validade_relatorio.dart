// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Adicione esta linha para importar o pacote de data
import 'package:intl/intl.dart';

// Classe auxiliar para unificar os dados de exibição
class ItemDisplayInfo {
  final String nomeProduto;
  final String validade;
  final String status;
  final int diasRestantes;
  final bool isVencido;

  ItemDisplayInfo({
    required this.nomeProduto,
    required this.validade,
    required this.status,
    required this.diasRestantes,
    required this.isVencido,
  });
}

class VisorValidadeRelatorio extends StatefulWidget {
  const VisorValidadeRelatorio({
    Key? key,
    this.width,
    this.height,
    required this.relatorioId,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String relatorioId;

  @override
  _VisorValidadeRelatorioState createState() => _VisorValidadeRelatorioState();
}

class _VisorValidadeRelatorioState extends State<VisorValidadeRelatorio> {
  late Future<List<ItemDisplayInfo>> _processedItemsFuture;

  @override
  void initState() {
    super.initState();
    _processedItemsFuture = _fetchAndProcessData();
  }

  // Função para converter data String "DD/MM/YYYY" para DateTime
  DateTime? _parseDate(String dateStr) {
    try {
      final format = DateFormat('dd/MM/yyyy');
      return format.parseStrict(dateStr);
    } catch (e) {
      print('Erro ao converter data: $dateStr');
      return null;
    }
  }

  Future<List<ItemDisplayInfo>> _fetchAndProcessData() async {
    final relatorioDoc = await FirebaseFirestore.instance
        .collection('relatorio')
        .doc(widget.relatorioId)
        .get();

    if (!relatorioDoc.exists) {
      return [];
    }

    final relatorioData = relatorioDoc.data()!;
    final List<ItemDisplayInfo> itemsParaExibir = [];

    // puxa a data de entrega e as listas de itens
    final dataEntrega = (relatorioData['dataEntrega'] as Timestamp).toDate();
    final itensVencidosRaw = List<Map<String, dynamic>>.from(
        relatorioData['itensProdutosVencidos'] ?? []);
    final itensRelatorioRaw =
        List<Map<String, dynamic>>.from(relatorioData['itensRelatorio'] ?? []);

    // Função auxiliar para buscar nome do produto
    Future<String> getProductName(DocumentReference prodRef) async {
      final doc = await prodRef.get();
      return doc.exists
          ? (doc.data() as Map<String, dynamic>)['nome'] ?? 'Produto sem nome'
          : 'Produto não encontrado';
    }

    //itens já vencidos
    for (var itemData in itensVencidosRaw) {
      final vencido = VencidoStruct.fromMap(itemData);
      itemsParaExibir.add(ItemDisplayInfo(
        nomeProduto: await getProductName(vencido.produto!),
        validade: vencido.data,
        status: 'Vencido',
        isVencido: true,
        diasRestantes: -1, // vencidos vêm primeiro na ordenação
      ));
    }

    // checa validade
    for (var itemData in itensRelatorioRaw) {
      final dadosProduto = DadosProdutoStruct.fromMap(itemData);
      final validadeStr = dadosProduto.validade;
      final validadeDate = _parseDate(validadeStr);

      if (validadeDate != null) {
        final diasDeDiferenca = validadeDate.difference(dataEntrega).inDays;

        if (diasDeDiferenca >= 0 && diasDeDiferenca <= 10) {
          itemsParaExibir.add(ItemDisplayInfo(
            nomeProduto: await getProductName(dadosProduto.produto!),
            validade: validadeStr,
            status: '${diasDeDiferenca} dias',
            isVencido: false,
            diasRestantes: diasDeDiferenca,
          ));
        }
      }
    }

    // ordena a lista final
    itemsParaExibir.sort((a, b) => a.diasRestantes.compareTo(b.diasRestantes));

    return itemsParaExibir;
  }

  // widget para construir o item Vencido
  Widget _buildVencidoItem(ItemDisplayInfo item) {
    return Card(
      color: Color(0xFFFFE6E6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Color(0xFFFF4C00), width: 1.5),
      ),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                item.nomeProduto,
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.validade,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: Color(0xFFFF4C00),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  item.status,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Readex Pro',
                        color: Color(0xFFFF4C00),
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // widget para construir o item Próximo do Vencimento
  Widget _buildProximoVencimentoItem(ItemDisplayInfo item) {
    return Card(
      color: Color(0xFFFFF0E6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Color(0xFFFF8C00), width: 1.5),
      ),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                item.nomeProduto,
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.validade,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: Color(0xFFFF8C00),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  item.status,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Readex Pro',
                        color: Color(0xFFFF8C00),
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ItemDisplayInfo>>(
      future: _processedItemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Ocorreu um erro ao processar o relatório: ${snapshot.error}',
              textAlign: TextAlign.center,
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Nenhum item vencido ou próximo do vencimento encontrado.',
              style: FlutterFlowTheme.of(context).bodySmall,
            ),
          );
        }

        final items = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            if (item.isVencido) {
              return _buildVencidoItem(item);
            } else {
              return _buildProximoVencimentoItem(item);
            }
          },
        );
      },
    );
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
