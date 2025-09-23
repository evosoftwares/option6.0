import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/location_service.dart';
import 'package:flutter/material.dart';

class SimpleSearchScreenWidget extends StatefulWidget {
  const SimpleSearchScreenWidget({
    super.key,
    String? origemDestinoParada,
  }) : this.origemDestinoParada = origemDestinoParada ?? 'origem';

  final String origemDestinoParada;

  @override
  State<SimpleSearchScreenWidget> createState() => _SimpleSearchScreenWidgetState();
}

class _SimpleSearchScreenWidgetState extends State<SimpleSearchScreenWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController? textController;
  FocusNode? textFieldFocusNode;

  List<dynamic> predictions = [];
  bool isLoadingAutocomplete = false;
  bool isGettingLocation = false;
  String? selectedPlaceId;
  bool isLoadingPlaceDetails = false;
  String? loadingPlaceId;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    textFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    textController?.dispose();
    textFieldFocusNode?.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty || query.length < 2) {
      setState(() {
        predictions = [];
        isLoadingAutocomplete = false;
      });
      return;
    }

    setState(() {
      isLoadingAutocomplete = true;
    });

    try {
      final results = await functions.googlePlacesAutocomplete(query);

      if (!mounted) return;

      setState(() {
        predictions = results;
        isLoadingAutocomplete = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        predictions = [];
        isLoadingAutocomplete = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro na busca: ${e.toString()}'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            buttonSize: 40.0,
            icon: Icon(
              Icons.arrow_back,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            onPressed: () async {
              context.safePop();
            },
          ),
          title: Text(
            widget.origemDestinoParada == 'origem'
                ? 'Definir origem'
                : widget.origemDestinoParada == 'destino'
                ? 'Definir destino'
                : 'Adicionar parada',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.0,
            ),
          ),
          centerTitle: false,
          elevation: 1.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search,
                                color: FlutterFlowTheme.of(context).secondaryText,
                                size: 20.0,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: textController,
                                  focusNode: textFieldFocusNode,
                                  autofocus: true,
                                  obscureText: false,
                                  onChanged: (val) async {
                                    final query = val.trim();
                                    if (query.length >= 2) {
                                      await _performSearch(query);
                                    } else {
                                      setState(() {
                                        predictions = [];
                                        isLoadingAutocomplete = false;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'Digite o endereço aqui...',
                                    hintStyle: FlutterFlowTheme.of(context).labelMedium,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (widget.origemDestinoParada == 'origem')
                      FlutterFlowIconButton(
                        borderRadius: 8.0,
                        buttonSize: 40.0,
                        icon: Icon(
                          isGettingLocation ? Icons.hourglass_empty : Icons.my_location,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          setState(() {
                            isGettingLocation = true;
                          });

                          try {
                            final locationService = LocationService.instance;
                            final currentPlace = await locationService.getCurrentPlace();

                            if (!mounted) return;

                            if (currentPlace != null) {
                              setState(() {
                                textController?.text = currentPlace.name;
                                predictions = [];
                                isGettingLocation = false;
                              });

                              Navigator.of(context).pop(currentPlace);
                            } else {
                              setState(() {
                                isGettingLocation = false;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Não foi possível obter localização'),
                                  backgroundColor: FlutterFlowTheme.of(context).error,
                                ),
                              );
                            }
                          } catch (e) {
                            if (!mounted) return;
                            setState(() {
                              isGettingLocation = false;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erro ao obter localização: ${e.toString()}'),
                                backgroundColor: FlutterFlowTheme.of(context).error,
                              ),
                            );
                          }
                        },
                      ),
                  ],
                ),
                Expanded(
                  child: _buildResultsList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    if (isLoadingAutocomplete) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            FlutterFlowTheme.of(context).primary,
          ),
        ),
      );
    }

    if (predictions.isEmpty) {
      final currentText = textController?.text.trim() ?? '';

      if (currentText.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                size: 48.0,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
              SizedBox(height: 16.0),
              Text(
                'Digite pelo menos 2 caracteres para buscar',
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      } else if (currentText.length >= 2) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off,
                size: 48.0,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
              SizedBox(height: 16.0),
              Text(
                'Nenhum local encontrado',
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: predictions.length,
      separatorBuilder: (_, __) => Divider(
        height: 1.0,
        thickness: 0.5,
        color: FlutterFlowTheme.of(context).alternate,
      ),
      itemBuilder: (context, index) {
        final prediction = predictions[index] as Map;
        final mainText = prediction['structured_formatting']?['main_text'] ??
            prediction['description'] ??
            '';
        final secondaryText = prediction['structured_formatting']?['secondary_text'] ?? '';
        final placeId = prediction['place_id'] as String;

        return InkWell(
          onTap: () async {
            setState(() {
              selectedPlaceId = placeId;
              isLoadingPlaceDetails = true;
              loadingPlaceId = placeId;
              textController?.text = prediction['description'] ?? mainText;
            });

            FocusScope.of(context).unfocus();

            try {
              final ffPlace = await functions.googlePlaceDetails(placeId);

              if (!mounted) return;

              setState(() {
                isLoadingPlaceDetails = false;
                loadingPlaceId = null;
                predictions = [];
              });

              if (ffPlace != null) {
                Navigator.of(context).pop(ffPlace);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao obter detalhes do local'),
                    backgroundColor: FlutterFlowTheme.of(context).error,
                  ),
                );
              }
            } catch (e) {
              if (!mounted) return;

              setState(() {
                isLoadingPlaceDetails = false;
                loadingPlaceId = null;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erro de conexão: ${e.toString()}'),
                  backgroundColor: FlutterFlowTheme.of(context).error,
                ),
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.all(14.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: loadingPlaceId == placeId
                        ? SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                          )
                        : SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: Icon(
                              Icons.place_outlined,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 24.0,
                            ),
                          ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mainText,
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.0,
                        ),
                      ),
                      if (secondaryText.isNotEmpty)
                        Text(
                          secondaryText,
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}