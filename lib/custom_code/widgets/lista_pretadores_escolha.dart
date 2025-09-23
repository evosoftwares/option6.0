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

// typedef RetornoAction = ...; // REMOVIDO

// --- Modelos de Dados ---
class PromotorInfo {
  final String idPromotor;
  final String nome;
  final String? fotoUrl;
  final bool isLider;

  PromotorInfo({
    required this.idPromotor,
    required this.nome,
    this.fotoUrl,
    required this.isLider,
  });
}

/// --- Widget Principal ---
class ListaPretadoresEscolha extends StatefulWidget {
  const ListaPretadoresEscolha({
    Key? key,
    this.width,
    this.height,
    required this.idEmpresa,
    this.retorno,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String idEmpresa;
  // CORREÇÃO: Tipo da ação declarado diretamente, com o nome do argumento
  final Future<dynamic> Function(String idPromotorAction)? retorno;

  @override
  _ListaPretadoresEscolhaState createState() => _ListaPretadoresEscolhaState();
}

class _ListaPretadoresEscolhaState extends State<ListaPretadoresEscolha> {
  PromotorInfo? _promotorSelecionado;

  @override
  void initState() {
    super.initState();
    // Se precisar carregar um promotor inicial, a lógica iria aqui.
    // Por exemplo, buscando o primeiro da lista.
  }

  Widget _buildEstadoInicial() {
    return GestureDetector(
      onTap: () => _mostrarFolhaDeSelecao(context),
      child: Container(
        width: double.infinity,
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
              'Escolha o promotor',
              style: FlutterFlowTheme.of(context).bodyLarge,
            ),
            Icon(Icons.arrow_drop_down,
                color: FlutterFlowTheme.of(context).secondaryText),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadoSelecionado(PromotorInfo promotor) {
    return GestureDetector(
      onTap: () => _mostrarFolhaDeSelecao(context),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: FlutterFlowTheme.of(context).secondaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: FlutterFlowTheme.of(context).primary,
            backgroundImage:
                (promotor.fotoUrl != null && promotor.fotoUrl!.isNotEmpty)
                    ? NetworkImage(promotor.fotoUrl!)
                    : null,
            child: (promotor.fotoUrl == null || promotor.fotoUrl!.isEmpty)
                ? Icon(Icons.person,
                    color: FlutterFlowTheme.of(context).secondary)
                : null,
          ),
          title: Text(promotor.nome,
              style: FlutterFlowTheme.of(context).titleLarge),
          subtitle: promotor.isLider
              ? Text('Líder',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme.of(context).primary,
                        fontWeight: FontWeight.bold,
                      ))
              : null,
          trailing: Icon(Icons.edit,
              color: FlutterFlowTheme.of(context).primary, size: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _promotorSelecionado == null
        ? _buildEstadoInicial()
        : _buildEstadoSelecionado(_promotorSelecionado!);
  }

  Future<void> _mostrarFolhaDeSelecao(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          Center(child: CircularProgressIndicator()),
    );
    final List<PromotorInfo> promotores = await _getPromotores();
    Navigator.of(context).pop();

    final resultado = await showModalBottomSheet<PromotorInfo>(
      context: context,
      isScrollControlled: true,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      builder: (BuildContext context) {
        return _buildListaDePromotores(promotores);
      },
    );

    if (resultado != null) {
      setState(() {
        _promotorSelecionado = resultado;
      });

      if (widget.retorno != null) {
        widget.retorno!(resultado.idPromotor);
      }
    }
  }

  Widget _buildListaDePromotores(List<PromotorInfo> promotores) {
    if (promotores.isEmpty) {
      return Container(
          height: 150,
          child: Center(child: Text('Nenhum promotor encontrado.')));
    }
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
      child: SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: promotores.length,
          itemBuilder: (context, index) {
            final promotor = promotores[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    (promotor.fotoUrl != null && promotor.fotoUrl!.isNotEmpty)
                        ? NetworkImage(promotor.fotoUrl!)
                        : null,
                child: (promotor.fotoUrl == null || promotor.fotoUrl!.isEmpty)
                    ? Icon(Icons.person)
                    : null,
              ),
              title: Text(promotor.nome),
              onTap: () {
                Navigator.pop(context, promotor);
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<PromotorInfo>> _getPromotores() async {
    final List<PromotorInfo> promotoresCombinados = [];
    final promotorQuery = await FirebaseFirestore.instance
        .collection('perfilPromotor')
        .where('empresaId', isEqualTo: widget.idEmpresa)
        .get();

    if (promotorQuery.docs.isEmpty) return [];

    for (final promotorDoc in promotorQuery.docs) {
      final promotorData = promotorDoc.data();
      if (promotorData == null) continue;

      final idUser = promotorData['idUser'] as String?;

      if (idUser != null && idUser.isNotEmpty) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(idUser)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data()!;
          promotoresCombinados.add(PromotorInfo(
            idPromotor: promotorData['idPromotor'] as String? ?? '',
            nome: userData['display_name'] as String? ?? 'Nome não encontrado',
            fotoUrl: userData['photo_url'] as String?,
            isLider: promotorData['lider'] as bool? ?? false,
          ));
        }
      }
    }
    return promotoresCombinados;
  }
}
