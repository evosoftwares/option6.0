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

class LocalizacaoDisplayInfo {
  final DadosProdutoStruct localizacao;
  final List<String> nomesProdutos;

  LocalizacaoDisplayInfo(
      {required this.localizacao, required this.nomesProdutos});
}

class LocalizacaoProdutosAgrupados extends StatefulWidget {
  const LocalizacaoProdutosAgrupados({
    Key? key,
    this.width,
    this.height,
    // CORREÇÃO: Nome ajustado para camelCase 'relatorioId'
    this.relatorioId,
  }) : super(key: key);

  final double? width;
  final double? height;
  // CORREÇÃO: Nome ajustado para camelCase, mantendo nulo (String?)
  final String? relatorioId;

  @override
  _LocalizacaoProdutosAgrupadosState createState() =>
      _LocalizacaoProdutosAgrupadosState();
}

class _LocalizacaoProdutosAgrupadosState
    extends State<LocalizacaoProdutosAgrupados> {
  late Future<List<LocalizacaoDisplayInfo>> _groupedDataFuture;

  @override
  void initState() {
    super.initState();
    _groupedDataFuture = _processarDados();
  }

  Future<List<LocalizacaoDisplayInfo>> _processarDados() async {
    // CORREÇÃO: Verificação de segurança usando o nome correto 'relatorioId'
    if (widget.relatorioId == null || widget.relatorioId!.isEmpty) {
      return [];
    }
    final relatorioDoc = await FirebaseFirestore.instance
        .collection('relatorio')
        .doc(widget.relatorioId)
        .get();

    if (!relatorioDoc.exists) {
      return [];
    }

    final relatorioData = relatorioDoc.data()!;
    final itensRelatorioRaw =
        List<Map<String, dynamic>>.from(relatorioData['itensRelatorio'] ?? []);
    final List<DadosProdutoStruct> dadosProdutoList = itensRelatorioRaw
        .map((data) => DadosProdutoStruct.fromMap(data))
        .toList();

    if (dadosProdutoList.isEmpty) {
      return [];
    }

    final Map<String, List<DocumentReference>> groupedProductRefs = {};
    final Map<String, DadosProdutoStruct> locationDataMap = {};

    for (final dadosProduto in dadosProdutoList) {
      final loc = dadosProduto.localizacao;
      final locationKey =
          '${loc.setor}-${loc.corredor}-${loc.prateleira}-${loc.geladeira}';

      if (!groupedProductRefs.containsKey(locationKey)) {
        groupedProductRefs[locationKey] = [];
        locationDataMap[locationKey] = dadosProduto;
      }
      if (dadosProduto.produto != null) {
        groupedProductRefs[locationKey]!.add(dadosProduto.produto!);
      }
    }

    final allProductRefs =
        groupedProductRefs.values.expand((refs) => refs).toSet().toList();
    final Map<String, String> productNames = {};

    if (allProductRefs.isNotEmpty) {
      final productDocs = await FirebaseFirestore.instance
          .collection('produto')
          .where(FieldPath.documentId,
              whereIn: allProductRefs.map((ref) => ref.id).toList())
          .get();

      for (final doc in productDocs.docs) {
        productNames[doc.id] = (doc.data())['nome'] ?? 'Produto sem nome';
      }
    }

    final List<LocalizacaoDisplayInfo> itemsParaExibir = [];
    groupedProductRefs.forEach((locationKey, productRefs) {
      final locationInfo = locationDataMap[locationKey]!;
      final names = productRefs
          .map((ref) => productNames[ref.id] ?? 'Carregando...')
          .toList();

      if (names.isNotEmpty) {
        itemsParaExibir.add(LocalizacaoDisplayInfo(
          localizacao: locationInfo,
          nomesProdutos: names,
        ));
      }
    });

    return itemsParaExibir;
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Color.fromRGBO(57, 98, 239, 0.3);
    final Color foregroundColor = Color(0xFF299BE7);

    return FutureBuilder<List<LocalizacaoDisplayInfo>>(
      future: _groupedDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
              child: Text('Erro ao carregar dados: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text('Nenhuma localização de produto encontrada.'));
        }

        final items = snapshot.data!;

        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final local = item.localizacao;

            String prateleiraText = local.localizacao.prateleira.isNotEmpty
                ? 'Prateleiras ${local.localizacao.prateleira}'
                : '';
            if (local.localizacao.geladeira.isNotEmpty) {
              prateleiraText = 'Geladeira ${local.localizacao.geladeira}';
            }

            return Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_outlined,
                    color: foregroundColor,
                    size: 40,
                  ),
                  SizedBox(height: 12),
                  Text(
                    '${local.localizacao.setor} - ${local.localizacao.corredor}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: foregroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  if (prateleiraText.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        prateleiraText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: foregroundColor.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  SizedBox(height: 16),
                  Text(
                    item.nomesProdutos.join(', '),
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
