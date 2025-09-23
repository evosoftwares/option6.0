import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/location_service.dart';
import '/flutter_flow/trip_suggestions_service.dart';
import '/flutter_flow/adaptive_debouncer.dart';
import '/flutter_flow/advanced_autocomplete.dart';
import '/flutter_flow/premium_contextual_features.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'search_screen_model.dart';
export 'search_screen_model.dart';

class SearchScreenWidget extends StatefulWidget {
  const SearchScreenWidget({
    super.key,
    String? origemDestinoParada,
  }) : this.origemDestinoParada = origemDestinoParada ?? 'origem';

  final String origemDestinoParada;

  static String routeName = 'searchScreen';
  static String routePath = '/searchScreen';

  @override
  State<SearchScreenWidget> createState() => _SearchScreenWidgetState();
}

class _SearchScreenWidgetState extends State<SearchScreenWidget> {
  late SearchScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  AdaptiveDebouncer? _debouncer;
  AdvancedAutocomplete? _advancedAutocomplete;
  PremiumContextualFeatures? _premiumFeatures;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchScreenModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    // Inicializar serviços de forma segura
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _debouncer = AdaptiveDebouncer.instance;
        _advancedAutocomplete = AdvancedAutocomplete.instance;
        _premiumFeatures = PremiumContextualFeatures.instance;
        _premiumFeatures?.initialize();
      }
    });
  }

  @override
  void dispose() {
    _debouncer?.cancel();
    _model.dispose();

    super.dispose();
  }

  /// Mostra dialog para configurar permissões de localização
  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.location_off,
                color: FlutterFlowTheme.of(context).error,
                size: 24.0,
              ),
              SizedBox(width: 8.0),
              Text(
                'Localização Indisponível',
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.0,
                ),
              ),
            ],
          ),
          content: Text(
            'Para usar sua localização atual, é necessário permitir acesso à localização nas configurações do dispositivo.',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              letterSpacing: 0.0,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await LocationService.instance.openLocationSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Configurações',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  color: Colors.white,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Constrói um item de sugestão
  Widget _buildSuggestionItem(SuggestionItem suggestion) {
    return InkWell(
      onTap: () async {
        setState(() {
          _model.selectedPlaceId = null;
          _model.isLoadingPlaceDetails = true;
          _model.loadingPlaceId = 'suggestion_${suggestion.place.latLng.latitude}';
          _model.textController?.text = suggestion.place.name;
        });

        FocusScope.of(context).unfocus();

        try {
          // Simular um pequeno delay para UX
          await Future.delayed(Duration(milliseconds: 300));

          if (!mounted) return;

          setState(() {
            _model.isLoadingPlaceDetails = false;
            _model.loadingPlaceId = null;
            _model.predictions = [];
          });

          // Retornar com o place da sugestão
          Navigator.of(context).pop(suggestion.place);
        } catch (e) {
          if (!mounted) return;

          setState(() {
            _model.isLoadingPlaceDetails = false;
            _model.loadingPlaceId = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao selecionar sugestão: ${e.toString()}'),
              backgroundColor: FlutterFlowTheme.of(context).error,
              duration: Duration(seconds: 2),
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
                borderRadius: BorderRadius.circular(99.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: _model.loadingPlaceId == 'suggestion_${suggestion.place.latLng.latitude}'
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
                    : Icon(
                        suggestion.icon,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 24.0,
                      ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion.place.name,
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                      ),
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (suggestion.subtitle.isNotEmpty)
                    Text(
                      suggestion.subtitle,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.inter(),
                        color: FlutterFlowTheme.of(context).primary,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (suggestion.place.address.isNotEmpty)
                    Text(
                      suggestion.place.address,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ].divide(SizedBox(height: 4.0)),
              ),
            ),
          ].divide(SizedBox(width: 12.0)),
        ),
      ),
    );
  }

  /// Constrói skeleton de loading sofisticado
  Widget _buildLoadingSkeleton() {
    return AnimatedBuilder(
      animation: _createPulseAnimation(),
      builder: (context, child) {
        return Column(
          children: [
            // Header com indicador de progresso animado
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 18.0,
                    height: 18.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Buscando endereços...',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            color: FlutterFlowTheme.of(context).primary,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          'Aguarde alguns segundos',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            fontSize: 11.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Indicador de qualidade da conexão
                  _buildConnectionIndicator(),
                ],
              ),
            ),

            // Skeleton items simulando resultados com animação
            ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 4,
              separatorBuilder: (_, __) => Divider(
                height: 1.0,
                thickness: 0.5,
                color: FlutterFlowTheme.of(context).alternate,
              ),
              itemBuilder: (context, index) {
                return _buildAnimatedSkeletonItem(index);
              },
            ),
          ],
        );
      },
    );
  }

  /// Cria animação de pulse para o skeleton
  Animation<double> _createPulseAnimation() {
    // Usa uma animação simples baseada no tempo
    return AlwaysStoppedAnimation<double>(
      (DateTime.now().millisecondsSinceEpoch % 2000) / 2000.0,
    );
  }

  /// Constrói indicador de qualidade da conexão
  Widget _buildConnectionIndicator() {
    return FutureBuilder<bool>(
      future: _premiumFeatures?.isOnline() ?? Future.value(true),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
            width: 12.0,
            height: 12.0,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
          );
        }

        final isOnline = snapshot.data!;
        return Container(
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: isOnline ? Colors.green : Colors.orange,
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  /// Constrói skeleton item com animação
  Widget _buildAnimatedSkeletonItem(int index) {
    // Delay escalonado para cada item
    final delay = index * 150;
    final animationValue = ((DateTime.now().millisecondsSinceEpoch + delay) % 2000) / 2000.0;
    final opacity = 0.3 + (0.4 * (0.5 + 0.5 * (animationValue > 0.5 ? 1 - animationValue : animationValue)));

    // Variação nos tamanhos para simular resultados reais
    final titleWidths = [200.0, 180.0, 220.0, 160.0];
    final subtitleWidths = [150.0, 130.0, 170.0, 140.0];

    return Padding(
      padding: EdgeInsets.all(14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skeleton do ícone com animação
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).alternate.withValues(alpha: opacity),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Center(
              child: Container(
                width: 24.0,
                height: 24.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).alternate.withValues(alpha: opacity + 0.2),
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ),

          SizedBox(width: 12.0),

          // Skeleton do texto com animação
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título principal
                Container(
                  width: titleWidths[index % titleWidths.length],
                  height: 16.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate.withValues(alpha: opacity),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),

                SizedBox(height: 8.0),

                // Subtítulo
                Container(
                  width: subtitleWidths[index % subtitleWidths.length],
                  height: 12.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate.withValues(alpha: opacity - 0.1),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),

                SizedBox(height: 6.0),

                // Badge pequeno
                Container(
                  width: 60.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate.withValues(alpha: opacity - 0.2),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ],
            ),
          ),

          // Skeleton da distância com animação
          Container(
            width: 40.0,
            height: 12.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).alternate.withValues(alpha: opacity - 0.1),
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
        ],
      ),
    );
  }


  /// Constrói a lista de resultados com estados inteligentes
  Widget _buildResultsList() {
    // Loading do autocomplete
    if (_model.isLoadingAutocomplete) {
      return _buildLoadingSkeleton();
    }

    // Lista vazia - mostrar sugestões ou dicas
    if (_model.predictions.isEmpty) {
      final currentText = _model.textController?.text.trim() ?? '';

      if (currentText.isEmpty) {
        // Mostrar sugestões inteligentes
        return FutureBuilder<List<SuggestionItem>>(
          future: TripSuggestionsService.instance.getSuggestions(
            context: widget.origemDestinoParada,
            currentTime: DateTime.now(),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    Text(
                      'Carregando sugestões...',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ],
                ),
              );
            }

            final suggestions = snapshot.data ?? [];

            if (suggestions.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
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
                    SizedBox(height: 8.0),
                    Text(
                      'Ex: Rua Augusta, Shopping Morumbi',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            // Mostrar sugestões
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Text(
                    '💡 Sugestões para você',
                    style: FlutterFlowTheme.of(context).labelMedium.override(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: suggestions.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1.0,
                    thickness: 0.5,
                    color: FlutterFlowTheme.of(context).alternate,
                  ),
                  itemBuilder: (context, index) {
                    final suggestion = suggestions[index];
                    return _buildSuggestionItem(suggestion);
                  },
                ),
              ],
            );
          },
        );
      } else if (currentText.length >= 2) {
        return Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
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
              SizedBox(height: 8.0),
              Text(
                'Tente uma busca mais específica ou verifique a ortografia',
                style: FlutterFlowTheme.of(context).bodySmall.override(
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

    // Lista com resultados enriquecidos
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: _model.predictions.length,
      separatorBuilder: (_, __) => Divider(
        height: 2.0,
        thickness: 0.5,
        color: FlutterFlowTheme.of(context).alternate,
      ),
      itemBuilder: (context, index) {
        final p = _model.predictions[index] as Map;
        final enhancedResult = p['_enhanced'] as EnhancedResult?;

        final mainText = p['structured_formatting']?['main_text'] ??
            p['description'] ??
            '';
        final secondaryText = p['structured_formatting']?['secondary_text'] ?? '';
        final placeId = p['place_id'] as String;

        return InkWell(
          onTap: () async {
            setState(() {
              _model.selectedPlaceId = placeId;
              _model.isLoadingPlaceDetails = true;
              _model.loadingPlaceId = placeId;
              _model.textController?.text = p['description'] ?? mainText;
            });

            FocusScope.of(context).unfocus();

            try {
              final ffPlace = await functions.googlePlaceDetails(placeId);

              if (!mounted) return;

              setState(() {
                _model.isLoadingPlaceDetails = false;
                _model.loadingPlaceId = null;
                _model.predictions = [];
              });

              if (ffPlace != null) {
                Navigator.of(context).pop(ffPlace);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao obter detalhes do local'),
                    backgroundColor: FlutterFlowTheme.of(context).error,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            } catch (e) {
              if (!mounted) return;

              setState(() {
                _model.isLoadingPlaceDetails = false;
                _model.loadingPlaceId = null;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erro de conexão: ${e.toString()}'),
                  backgroundColor: FlutterFlowTheme.of(context).error,
                  duration: Duration(seconds: 3),
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
                    child: _model.loadingPlaceId == placeId
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
                        : Icon(
                            enhancedResult?.icon ?? Icons.place_outlined,
                            color: _getCategoryColor(enhancedResult?.category),
                            size: 24.0,
                          ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '$mainText',
                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (enhancedResult?.distanceText != null)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).accent4,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text(
                                enhancedResult!.distanceText!,
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 11.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4.0),
                      if ('$secondaryText'.isNotEmpty)
                        Text(
                          '$secondaryText',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                        ),
                      // Badge da categoria
                      if (enhancedResult?.category != null && _getCategoryLabel(enhancedResult!.category) != null)
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(enhancedResult.category).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: _getCategoryColor(enhancedResult.category).withValues(alpha: 0.3),
                                    width: 1.0,
                                  ),
                                ),
                                child: Text(
                                  _getCategoryLabel(enhancedResult.category)!,
                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                    color: _getCategoryColor(enhancedResult.category),
                                    fontSize: 10.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (enhancedResult.isRecent)
                                Padding(
                                  padding: EdgeInsets.only(left: 6.0),
                                  child: Icon(
                                    Icons.history,
                                    size: 14.0,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              if (enhancedResult.isFavorite)
                                Padding(
                                  padding: EdgeInsets.only(left: 6.0),
                                  child: Icon(
                                    Icons.favorite,
                                    size: 14.0,
                                    color: FlutterFlowTheme.of(context).error,
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ].divide(SizedBox(height: 4.0)),
                  ),
                ),
              ].divide(SizedBox(width: 12.0)),
            ),
          ),
        );
      },
    );
  }

  /// Verifica cache de autocomplete (desabilitado)
  Future<List<dynamic>?> _checkCache(String query) async {
    // Cache desabilitado - sempre retorna null para buscar na API
    return null;
  }

  /// Executa busca na API com retry automático e tratamento de erros
  Future<void> _performSearch(String query) async {
    await _performSearchWithRetry(query);
  }

  /// Executa busca com sistema de retry inteligente
  Future<void> _performSearchWithRetry(String query, {int attempt = 1, int maxAttempts = 3}) async {
    try {
      List<EnhancedResult> enhancedResults = [];

      // 1. Verificar se está online
      final isOnline = await (_premiumFeatures?.isOnline() ?? Future.value(true));

      if (isOnline) {
        // Online: buscar na API com timeout
        final rawResults = await functions.googlePlacesAutocomplete(query)
            .timeout(
              Duration(seconds: 5), // Timeout de 5 segundos
              onTimeout: () {
                throw Exception('Timeout na busca de endereços');
              },
            );

        if (!mounted) return;

        // 2. Processar com sistema avançado
        final userLocation = await _getCurrentUserLocation();
        enhancedResults = await (_advancedAutocomplete?.processResults(
          rawResults: rawResults,
          query: query,
          userLocation: userLocation,
          context: widget.origemDestinoParada,
        ) ?? Future.value(<EnhancedResult>[]));

        // 3. Salvar no cache offline para futuro uso
        _premiumFeatures?.saveToOfflineCache(enhancedResults, query);

        debugPrint('🌐 Busca online para "$query": ${enhancedResults.length} resultados (tentativa $attempt)');
      } else {
        // Offline: buscar no cache
        enhancedResults = await (_premiumFeatures?.searchOfflineCache(query) ?? Future.value(<EnhancedResult>[]));
        debugPrint('📱 Busca offline para "$query": ${enhancedResults.length} resultados');
      }

      if (!mounted) return;

      // 4. Converter resultados enriquecidos para formato compatível
      final compatibleResults = enhancedResults.map((result) => {
        'place_id': result.placeId,
        'description': result.description,
        'structured_formatting': {
          'main_text': result.mainText,
          'secondary_text': result.secondaryText,
        },
        '_enhanced': result, // Dados enriquecidos para uso avançado
        '_isOffline': !isOnline, // Indicador de resultado offline
      }).toList();

      setState(() {
        _model.predictions = compatibleResults;
        _model.isLoadingAutocomplete = false;
      });

      final mode = isOnline ? 'online' : 'offline';
      debugPrint('🚀 Busca $mode para "$query": ${enhancedResults.length} resultados processados');

    } catch (e) {
      debugPrint('❌ Erro na busca (tentativa $attempt): $e');

      if (!mounted) return;

      // Se ainda há tentativas restantes e foi um erro de rede, tentar novamente
      if (attempt < maxAttempts && _isNetworkError(e)) {
        debugPrint('🔄 Tentando novamente em ${attempt * 500}ms...');

        // Delay progressivo: 500ms, 1000ms, 1500ms
        await Future.delayed(Duration(milliseconds: attempt * 500));

        if (!mounted) return;

        return _performSearchWithRetry(query, attempt: attempt + 1, maxAttempts: maxAttempts);
      }

      // Se esgotaram as tentativas ou não é erro de rede, tentar fallback offline
      try {
        final offlineResults = await (_premiumFeatures?.searchOfflineCache(query) ?? Future.value(<EnhancedResult>[]));

        if (offlineResults.isNotEmpty) {
          final compatibleResults = offlineResults.map((result) => {
            'place_id': result.placeId,
            'description': result.description,
            'structured_formatting': {
              'main_text': result.mainText,
              'secondary_text': result.secondaryText,
            },
            '_enhanced': result,
            '_isOffline': true,
          }).toList();

          setState(() {
            _model.predictions = compatibleResults;
            _model.isLoadingAutocomplete = false;
          });

          debugPrint('🔄 Fallback offline: ${offlineResults.length} resultados');

          // Mostrar snackbar informando que está usando dados offline
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Resultados offline - verifique sua conexão'),
                ],
              ),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
      } catch (offlineError) {
        debugPrint('❌ Erro no fallback offline: $offlineError');
      }

      // Se nada funcionou, mostrar estado de erro
      setState(() {
        _model.predictions = [];
        _model.isLoadingAutocomplete = false;
      });

      // Mostrar mensagem de erro específica
      _showSearchError(attempt, e);
    }
  }

  /// Verifica se é um erro de rede que justifica retry
  bool _isNetworkError(dynamic error) {
    final errorMessage = error.toString().toLowerCase();
    return errorMessage.contains('timeout') ||
           errorMessage.contains('connection') ||
           errorMessage.contains('network') ||
           errorMessage.contains('socket') ||
           errorMessage.contains('failed host lookup');
  }

  /// Mostra erro específico baseado no tipo de falha
  void _showSearchError(int attempts, dynamic error) {
    String message;
    IconData icon;
    Color color;

    if (_isNetworkError(error)) {
      message = 'Problema de conexão. Verifique sua internet.';
      icon = Icons.wifi_off;
      color = Colors.orange;
    } else if (error.toString().contains('timeout')) {
      message = 'Busca demorou muito. Tente novamente.';
      icon = Icons.timer_off;
      color = Colors.red;
    } else {
      message = 'Erro inesperado. Tente novamente em alguns segundos.';
      icon = Icons.error_outline;
      color = Colors.red;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: color,
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Tentar novamente',
            textColor: Colors.white,
            onPressed: () {
              final currentQuery = _model.textController?.text.trim() ?? '';
              if (currentQuery.length >= 2) {
                setState(() => _model.isLoadingAutocomplete = true);
                _performSearch(currentQuery);
              }
            },
          ),
        ),
      );
    }
  }

  /// Obtém localização atual do usuário (opcional)
  Future<LatLng?> _getCurrentUserLocation() async {
    try {
      return await LocationService.instance.getCurrentLocation();
    } catch (e) {
      debugPrint('⚠️ Não foi possível obter localização para ranking: $e');
      return null;
    }
  }

  /// Cor baseada na categoria do resultado
  Color _getCategoryColor(ResultCategory? category) {
    if (category == null) return FlutterFlowTheme.of(context).secondaryText;

    switch (category) {
      case ResultCategory.residential:
        return FlutterFlowTheme.of(context).tertiary;
      case ResultCategory.business:
        return FlutterFlowTheme.of(context).secondary;
      case ResultCategory.landmark:
        return FlutterFlowTheme.of(context).warning;
      case ResultCategory.transport:
        return FlutterFlowTheme.of(context).info;
      case ResultCategory.recent:
        return FlutterFlowTheme.of(context).primary;
      case ResultCategory.address:
        return FlutterFlowTheme.of(context).secondaryText;
    }
  }

  /// Texto da categoria para exibição
  String? _getCategoryLabel(ResultCategory? category) {
    if (category == null) return null;

    switch (category) {
      case ResultCategory.residential:
        return 'Residencial';
      case ResultCategory.business:
        return 'Comércio';
      case ResultCategory.landmark:
        return 'Ponto Turístico';
      case ResultCategory.transport:
        return 'Transporte';
      case ResultCategory.recent:
        return 'Recente';
      case ResultCategory.address:
        return 'Endereço';
    }
  }

  /// Retorna o título apropriado baseado no contexto (origem/destino/parada)
  String _getTitleForContext() {
    switch (widget.origemDestinoParada) {
      case 'origem':
        return 'Definir origem';
      case 'destino':
        return 'Definir destino';
      case 'parada':
        return 'Adicionar parada';
      default:
        return 'Para onde vamos';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
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
            _getTitleForContext(),
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: [

          ],
          centerTitle: false,
          elevation: 1.0,
        ),
        body: SafeArea(
          top: true,
          child: Container(
            decoration: BoxDecoration(),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 20.0,
                                ),
                                Expanded(
                                  child: Container(
                                    width: 200.0,
                                    child: TextFormField(
                                      controller: _model.textController,
                                      focusNode: _model.textFieldFocusNode,
                                      autofocus: false,
                                      obscureText: false,
                                      onChanged: (val) async {
                                        final query = val.trim();

                                        if (query.isEmpty || query.length < 2) {
                                          _debouncer?.cancel();
                                          if (!mounted) return;
                                          setState(() {
                                            _model.predictions = [];
                                            _model.isLoadingAutocomplete = false;
                                          });
                                          return;
                                        }

                                        // Verificar cache primeiro para resposta imediata
                                        final cachedResults = await _checkCache(query);
                                        if (cachedResults != null) {
                                          _debouncer?.debounce(
                                            query: query,
                                            immediate: true,
                                            onExecute: () {
                                              if (!mounted) return;
                                              setState(() {
                                                _model.predictions = cachedResults;
                                                _model.isLoadingAutocomplete = false;
                                              });
                                            },
                                          );
                                          return;
                                        }

                                        // Mostrar loading imediatamente
                                        setState(() {
                                          _model.isLoadingAutocomplete = true;
                                        });

                                        // Usar debounce adaptativo para busca na API
                                        _debouncer?.debounce(
                                          query: query,
                                          onExecute: () async {
                                            await _performSearch(query);
                                          },
                                        );
                                      },
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                        hintText: 'Digite o endereço aqui ...',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                      cursorColor: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      enableInteractiveSelection: true,
                                      validator: _model.textControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                ),
                              ].divide(SizedBox(width: 0.0)),
                            ),
                          ),
                        ),
                      ),
                      if (widget.origemDestinoParada == 'origem')
                        FlutterFlowIconButton(
                          borderRadius: 8.0,
                          buttonSize: 40.0,
                          icon: _model.isGettingLocation
                              ? SizedBox(
                                  width: 20.0,
                                  height: 20.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                )
                              : Icon(
                                  Icons.my_location,
                                  color: _model.isGettingLocation
                                      ? FlutterFlowTheme.of(context).primary
                                      : FlutterFlowTheme.of(context).secondaryText,
                                  size: 24.0,
                                ),
                          onPressed: () async {
                            // 🌍 GEOLOCALIZAÇÃO INTELIGENTE
                            if (widget.origemDestinoParada == 'origem') {
                              setState(() {
                                _model.isGettingLocation = true;
                              });

                              try {
                                final locationService = LocationService.instance;
                                final currentPlace = await locationService.getCurrentPlace();

                                if (!mounted) return;

                                if (currentPlace != null) {
                                  setState(() {
                                    _model.textController?.text = currentPlace.name;
                                    _model.predictions = [];
                                    _model.selectedPlaceId = null;
                                    _model.isGettingLocation = false;
                                  });

                                  // Retornar automaticamente com a localização atual
                                  Navigator.of(context).pop(currentPlace);
                                } else {
                                  setState(() {
                                    _model.isGettingLocation = false;
                                  });

                                  // Mostrar dialog para permissões
                                  _showLocationPermissionDialog();
                                }
                              } catch (e) {
                                if (!mounted) return;
                                setState(() {
                                  _model.isGettingLocation = false;
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Erro ao obter localização: ${e.toString()}'),
                                    backgroundColor: FlutterFlowTheme.of(context).error,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 22.0, 0.0, 0.0),
                    child: _buildResultsList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
