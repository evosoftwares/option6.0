// DEPRECATED: Legacy Firebase reports system widget
// This file has been commented out during Firebase to Supabase migration
// Replaced by Supabase-based reports and validation system

/*
// Automatic FlutterFlow imports
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nomeProduto,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF4C00),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Validade: ${item.validade}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFFFF4C00),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'VENCIDO',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // widget para construir o item Próximo ao Vencimento
  Widget _buildProximoVencimentoItem(ItemDisplayInfo item) {
    Color statusColor;
    Color backgroundColor;
    Color borderColor;

    if (item.diasRestantes <= 3) {
      statusColor = Color(0xFFFF4C00);
      backgroundColor = Color(0xFFFFE6E6);
      borderColor = Color(0xFFFF4C00);
    } else if (item.diasRestantes <= 7) {
      statusColor = Color(0xFFFF8C00);
      backgroundColor = Color(0xFFFFF4E6);
      borderColor = Color(0xFFFF8C00);
    } else {
      statusColor = Color(0xFFFFC107);
      backgroundColor = Color(0xFFFFFBE6);
      borderColor = Color(0xFFFFC107);
    }

    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: borderColor, width: 1.5),
      ),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nomeProduto,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Validade: ${item.validade}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item.status.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: FutureBuilder<List<ItemDisplayInfo>>(
        future: _processedItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar dados: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return Center(
              child: Text(
                'Nenhum item próximo ao vencimento encontrado.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF666666),
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return item.isVencido
                  ? _buildVencidoItem(item)
                  : _buildProximoVencimentoItem(item);
            },
          );
        },
      ),
    );
  }
}
*/

// Placeholder widget to maintain compatibility
class VisorValidadeRelatorio extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Center(
        child: Text(
          'VisorValidadeRelatorio: Widget deprecated - migrated to Supabase',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
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
