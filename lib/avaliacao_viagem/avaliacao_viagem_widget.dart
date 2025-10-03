import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class AvaliacaoViagemWidget extends StatefulWidget {
  const AvaliacaoViagemWidget({
    Key? key,
    required this.tripId,
    required this.userType,
  }) : super(key: key);

  final String tripId;
  final String userType; // 'motorista' ou 'passageiro'

  @override
  _AvaliacaoViagemWidgetState createState() => _AvaliacaoViagemWidgetState();
}

class _AvaliacaoViagemWidgetState extends State<AvaliacaoViagemWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  double _rating = 3.0;
  final _commentController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitRating() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;

      final tripRes = await supabase
          .from('trips')
          .select('driver_id, passenger_id')
          .eq('id', widget.tripId)
          .single();

      final driverId = tripRes['driver_id']; // Este é o ID da tabela 'drivers'
      final passengerId =
          tripRes['passenger_id']; // Este é o ID da tabela 'passengers'

      // Busca os user_id (FK para app_users) de motorista e passageiro
      final driverRes = await supabase
          .from('drivers')
          .select('user_id')
          .eq('id', driverId)
          .single();
      final passengerRes = await supabase
          .from('passengers')
          .select('user_id')
          .eq('id', passengerId)
          .single();
      final driverUserId = driverRes['user_id'];
      final passengerUserId = passengerRes['user_id'];

      final existingRatingRes = await supabase
          .from('ratings')
          .select('id')
          .eq('trip_id', widget.tripId)
          .maybeSingle();

      final ratingData = {
        'trip_id': widget.tripId,
        'driver_user_id': driverUserId,
        'passenger_user_id': passengerUserId,
        if (widget.userType == 'passageiro') ...{
          'driver_rating': _rating.toInt(),
          'driver_rating_comment': _commentController.text,
          'driver_rated_at': DateTime.now().toIso8601String(),
        } else ...{
          'passenger_rating': _rating.toInt(),
          'passenger_rating_comment': _commentController.text,
          'passenger_rated_at': DateTime.now().toIso8601String(),
        }
      };

      if (existingRatingRes == null) {
        await supabase.from('ratings').insert(ratingData);
      } else {
        final existingRatingId = existingRatingRes['id'];
        await supabase
            .from('ratings')
            .update(ratingData)
            .eq('id', existingRatingId);
      }

      await _updateAverageRating(
        ratedUserId:
            widget.userType == 'passageiro' ? driverUserId : passengerUserId,
        ratedUserTable:
            widget.userType == 'passageiro' ? 'drivers' : 'passengers',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Avaliação enviada com sucesso!'),
              backgroundColor: Colors.green),
        );
        final destination = widget.userType == 'passageiro'
            ? 'mainPassageiro'
            : 'mainMotorista';
        context.goNamed(destination, extra: {'refresh': true});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erro ao enviar avaliação: ${e.toString()}'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateAverageRating({
    required String ratedUserId,
    required String ratedUserTable, // 'drivers' ou 'passengers'
  }) async {
    final supabase = Supabase.instance.client;
    final ratingColumn =
        ratedUserTable == 'drivers' ? 'driver_rating' : 'passenger_rating';
    final userIdColumn =
        ratedUserTable == 'drivers' ? 'driver_user_id' : 'passenger_user_id';

    final ratingsRes = await supabase
        .from('ratings')
        .select(ratingColumn)
        .eq(userIdColumn, ratedUserId)
        .not(ratingColumn, 'is', null);

    if (ratingsRes.isNotEmpty) {
      final totalRating =
          ratingsRes.map((r) => r[ratingColumn] as int).reduce((a, b) => a + b);
      final averageRating = totalRating / ratingsRes.length;
      await supabase
          .from(ratedUserTable)
          .update({'average_rating': averageRating}).eq('user_id', ratedUserId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        automaticallyImplyLeading: false,
        title: Text(
          'Avaliar Viagem',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                color: Colors.white,
                fontSize: 22,
              ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                'Como foi sua experiência?',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).headlineSmall,
              ),
              const SizedBox(height: 24),
              Center(
                child: RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  unratedColor: FlutterFlowTheme.of(context).alternate,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Deixe um comentário (opcional)',
                  hintText: 'Sua opinião nos ajuda a melhorar...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 32),
              FFButtonWidget(
                onPressed: _isLoading ? null : _submitRating,
                text: _isLoading ? '' : 'Enviar Avaliação',
                icon: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : null,
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 50,
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                      ),
                  elevation: 3,
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
