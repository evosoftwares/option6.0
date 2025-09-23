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

// typedef removido

class Produto {
  final String idProduto;
  final String nome;
  final String? fotoProduto;

  Produto({required this.idProduto, required this.nome, this.fotoProduto});
}

class MarcaComProdutos {
  final String idMarca;
  final String nome;
  final String? fotoMarca;
  final List<Produto> produtos;

  MarcaComProdutos({
    required this.idMarca,
    required this.nome,
    this.fotoMarca,
    required this.produtos,
  });
}

/// ========================================================== ============
/// WIDGET PRINCIPAL (O BOTÃO) ==================
/// ==========================================================
class SeletorDeProdutos extends StatefulWidget {
  const SeletorDeProdutos({
    Key? key,
    this.width,
    this.height,
    required this.idEmpresa,
    this.listaProdutosIniciais,
    this.onChange,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String idEmpresa;
  final List<String>? listaProdutosIniciais;
  // CORREÇÃO FINAL: Nome do parâmetro da função foi adicionado
  final Future<dynamic> Function(List<String> novaListaProdutos)? onChange;

  @override
  _SeletorDeProdutosState createState() => _SeletorDeProdutosState();
}

class _SeletorDeProdutosState extends State<SeletorDeProdutos> {
  Set<String> _idsProdutosSelecionados = {};

  @override
  void initState() {
    super.initState();
    _idsProdutosSelecionados = widget.listaProdutosIniciais?.toSet() ?? {};
  }

  Future<void> _abrirModalDeSelecao() async {
    final novaSelecao = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ModalSelecaoProdutos(
        idEmpresa: widget.idEmpresa,
        selecaoInicial: _idsProdutosSelecionados,
      ),
    );

    if (novaSelecao != null) {
      setState(() {
        _idsProdutosSelecionados = novaSelecao;
      });
      widget.onChange?.call(novaSelecao.toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _abrirModalDeSelecao,
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: FlutterFlowTheme.of(context).alternate),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _idsProdutosSelecionados.isEmpty
                  ? 'Selecionar Produtos'
                  : '${_idsProdutosSelecionados.length} produtos selecionados',
              style: FlutterFlowTheme.of(context).bodyLarge,
            ),
            Icon(Icons.arrow_drop_down_rounded,
                color: FlutterFlowTheme.of(context).secondaryText),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// ========= JANELA MODAL DE SELEÇÃO (A LISTA) ==============
// ==========================================================
class _ModalSelecaoProdutos extends StatefulWidget {
  const _ModalSelecaoProdutos({
    required this.idEmpresa,
    required this.selecaoInicial,
  });

  final String idEmpresa;
  final Set<String> selecaoInicial;

  @override
  __ModalSelecaoProdutosState createState() => __ModalSelecaoProdutosState();
}

class __ModalSelecaoProdutosState extends State<_ModalSelecaoProdutos> {
  late Future<List<MarcaComProdutos>> _dadosFuturos;
  late Set<String> _selecaoTemporaria;

  @override
  void initState() {
    super.initState();
    _selecaoTemporaria = Set.from(widget.selecaoInicial);
    _dadosFuturos = _buscarDados();
  }

  Future<List<MarcaComProdutos>> _buscarDados() async {
    final queryMarcas = await FirebaseFirestore.instance
        .collection('marca')
        .where('idEmpresa', isEqualTo: widget.idEmpresa)
        .get();

    if (queryMarcas.docs.isEmpty) return [];

    final List<MarcaComProdutos> listaFinal = [];

    for (final docMarca in queryMarcas.docs) {
      final dadosMarca = docMarca.data();
      if (dadosMarca == null) continue;

      final idDaMarcaAtual = dadosMarca['idMarca']?.toString() ?? '';
      if (idDaMarcaAtual.isEmpty) continue;

      final queryProdutos = await FirebaseFirestore.instance
          .collection('produto')
          .where('pertenceMarca', isEqualTo: idDaMarcaAtual)
          .get();

      final List<Produto> produtosDaMarca = [];
      for (final docProduto in queryProdutos.docs) {
        final dadosProduto = docProduto.data();
        if (dadosProduto == null) continue;
        produtosDaMarca.add(Produto(
          idProduto: dadosProduto['idProduto']?.toString() ?? '',
          nome: dadosProduto['nome']?.toString() ?? 'Produto sem nome',
          fotoProduto: dadosProduto['fotoProduto']?.toString(),
        ));
      }

      listaFinal.add(MarcaComProdutos(
        idMarca: idDaMarcaAtual,
        nome: dadosMarca['nome']?.toString() ?? 'Marca sem nome',
        fotoMarca: dadosMarca['fotoMarca']?.toString(),
        produtos: produtosDaMarca,
      ));
    }
    return listaFinal;
  }

  void _aoSelecionarProduto(bool? foiSelecionado, String idDoProduto) {
    setState(() {
      if (foiSelecionado == true) {
        _selecaoTemporaria.add(idDoProduto);
      } else {
        _selecaoTemporaria.remove(idDoProduto);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Selecione os Produtos',
                    style: FlutterFlowTheme.of(context).headlineSmall),
                IconButton(
                  icon: Icon(Icons.check_circle,
                      color: FlutterFlowTheme.of(context).primary, size: 30),
                  onPressed: () {
                    Navigator.of(context).pop(_selecaoTemporaria);
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<MarcaComProdutos>>(
              future: _dadosFuturos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('Nenhuma marca ou produto encontrado.'));
                }
                final marcas = snapshot.data!;
                return ListView.builder(
                  itemCount: marcas.length,
                  itemBuilder: (context, index) {
                    final marca = marcas[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: ExpansionTile(
                        title: Text(marca.nome,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        children: marca.produtos.map((produto) {
                          return CheckboxListTile(
                            title: Text(produto.nome),
                            value:
                                _selecaoTemporaria.contains(produto.idProduto),
                            onChanged: (val) =>
                                _aoSelecionarProduto(val, produto.idProduto),
                          );
                        }).toList(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
