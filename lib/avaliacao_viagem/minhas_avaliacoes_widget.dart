import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MinhasAvaliacoesWidget extends StatefulWidget {
  const MinhasAvaliacoesWidget({
    Key? key,
    required this.userType,
    required this.userId,
  }) : super(key: key);

  final String userType; // 'motorista' ou 'passageiro'
  final String userId;

  static const routeName = 'minhasAvaliacoes';

  @override
  _MinhasAvaliacoesWidgetState createState() => _MinhasAvaliacoesWidgetState();
}

class _MinhasAvaliacoesWidgetState extends State<MinhasAvaliacoesWidget> {
  late final Future<List<Map<String, dynamic>>> _ratingsFuture;

  @override
  void initState() {
    super.initState();
    _ratingsFuture = _fetchRatings();
  }

  /// Busca o histórico de avaliações recebidas pelo usuário a partir da VIEW 'detailed_ratings'.
  Future<List<Map<String, dynamic>>> _fetchRatings() async {
    final supabase = Supabase.instance.client;
    // Define a coluna a ser filtrada com base no tipo de usuário (quem está sendo avaliado).
    final userIdColumn =
        widget.userType == 'motorista' ? 'driver_user_id' : 'passenger_user_id';

    try {
      final response = await supabase
          .from('detailed_ratings')
          .select()
          .eq(userIdColumn, widget.userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print('Erro ao buscar avaliações: $e');
      throw Exception('Não foi possível carregar as avaliações.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        automaticallyImplyLeading: true, // Adicionado botão de voltar
        iconTheme: IconThemeData(color: Colors.white), // Cor do botão de voltar
        title: Text(
          'Minhas Avaliações',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                color: Colors.white,
                fontSize: 22,
              ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _ratingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar: ${snapshot.error}'),
            );
          }

          final ratings = snapshot.data;

          if (ratings == null || ratings.isEmpty) {
            return const Center(
              child: Text(
                'Você ainda não recebeu nenhuma avaliação.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: ratings.length,
            itemBuilder: (context, index) {
              final rating = ratings[index];
              final isDriverViewing = widget.userType == 'motorista';

              // Determina quais campos da VIEW 'detailed_ratings' devem ser exibidos.
              final ratingValue = (isDriverViewing
                          ? rating['driver_rating']
                          : rating['passenger_rating'])
                      ?.toDouble() ??
                  0.0;

              final raterName = isDriverViewing
                  ? rating['passenger_name']
                  : rating['driver_name'];

              final comment = isDriverViewing
                  ? rating['driver_rating_comment']
                  : rating['passenger_rating_comment'];

              final ratedAtRaw = isDriverViewing
                  ? rating['driver_rated_at']
                  : rating['passenger_rated_at'];
              final ratedAt = DateTime.tryParse(ratedAtRaw ?? '');

              // Oculta o card se a avaliação correspondente ainda não foi feita.
              if (ratingValue == 0.0) {
                return const SizedBox.shrink();
              }

              return Card(
                elevation: 2,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Avaliação de: ${raterName ?? 'Usuário'}',
                              style: FlutterFlowTheme.of(context).titleMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (ratedAt != null)
                            Text(
                              DateFormat('dd/MM/yyyy').format(ratedAt),
                              style: FlutterFlowTheme.of(context).bodySmall,
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      RatingBar.builder(
                        initialRating: ratingValue,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 24.0,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        ignoreGestures: true, // Apenas para exibição
                        onRatingUpdate: (rating) {},
                      ),
                      if (comment != null && comment.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            '"$comment"',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .copyWith(fontStyle: FontStyle.italic),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
