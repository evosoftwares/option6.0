import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- ENUM DECLARADO ---
enum TipoAvaliacao { 
  motorista, 
  passageiro 
}


// --- COMPONENTE DE AVALIAÇÃO ---

class TelaDeAvaliacaoWidget extends StatefulWidget {
  const TelaDeAvaliacaoWidget({
    super.key,
    required this.tipo,
    required this.tripId,
    required this.driverUserId,
    required this.passengerUserId,
    this.nomePrincipal,
    this.infoSecundaria,
  });

  final TipoAvaliacao tipo;
  final String tripId; 
  final String driverUserId; 
  final String passengerUserId; 
  final String? nomePrincipal;
  final String? infoSecundaria;

  @override
  State<TelaDeAvaliacaoWidget> createState() => _TelaDeAvaliacaoWidgetState();
}

class _TelaDeAvaliacaoWidgetState extends State<TelaDeAvaliacaoWidget> {
  // Estado da tela
  int _rating = 0;
  List<String> _tagsSelecionadas = [];
  late final TextEditingController _comentarioController;
  bool _isLoading = false;

  // Variáveis da UI que mudam com base no TipoAvaliacao
  late String _tituloDaPagina;
  late String _tituloDaSecao;

  @override
  void initState() {
    super.initState();
    _comentarioController = TextEditingController();

    switch (widget.tipo) {
      case TipoAvaliacao.motorista:
        _tituloDaPagina = 'Avaliar Motorista';
        _tituloDaSecao = 'Como foi sua experiência?';
        break;
      case TipoAvaliacao.passageiro:
        _tituloDaPagina = 'Avaliar Passageiro';
        _tituloDaSecao = 'Como foi o passageiro?';
        break;
    }
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _handleEnviarAvaliacao() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    Map<String, dynamic> resultado;
    try {
      final supabase = Supabase.instance.client;

      Map<String, dynamic> dadosParaSalvar = {
        'trip_id': widget.tripId, 
        'driver_user_id': widget.driverUserId,
        'passenger_user_id': widget.passengerUserId,
      };

      final now = DateTime.now().toIso8601String();
      final comment = _comentarioController.text.trim();

      if (widget.tipo == TipoAvaliacao.motorista) {
        // Passageiro está avaliando o motorista
        dadosParaSalvar['driver_rating'] = _rating;
        dadosParaSalvar['driver_rating_tags'] = _tagsSelecionadas;
        dadosParaSalvar['driver_rating_comment'] = comment.isNotEmpty ? comment : null;
        dadosParaSalvar['driver_rated_at'] = now;
      } else {
        // Motorista está avaliando o passageiro
        dadosParaSalvar['passenger_rating'] = _rating;
        dadosParaSalvar['passenger_rating_tags'] = _tagsSelecionadas;
        dadosParaSalvar['passenger_rating_comment'] = comment.isNotEmpty ? comment : null;
        dadosParaSalvar['passenger_rated_at'] = now;
      }
      
      // Insere ou atualiza a linha na tabela 'ratings'
      await supabase
          .from('ratings')
          .upsert(dadosParaSalvar, onConflict: 'trip_id');
      
      resultado = {'sucesso': true};
    } catch (e) {
      print('Ocorreu um erro ao salvar no Supabase: $e');
      resultado = {'sucesso': false, 'erro': 'Não foi possível enviar sua avaliação.'};
    }

    if (mounted) {
      setState(() => _isLoading = false);
      if (resultado['sucesso'] == true) {
        snackSalvo(context);
        Navigator.pop(context); 
      } else {
        alertaNegativo(context, mensagem: resultado['erro'] ?? 'Erro desconhecido.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // O Widget agora retorna o conteúdo do painel, sem Scaffold ou AppBar
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_tituloDaPagina, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),

          Text(widget.nomePrincipal ?? '', style: textTheme.titleLarge),
          if (widget.infoSecundaria != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(widget.infoSecundaria!, style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
            ),
          const SizedBox(height: 32),

          Text(_tituloDaSecao, style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Center(
            child: RatingEstrelasWidget(
              ratingAtual: _rating,
              onChanged: (newRating) => setState(() => _rating = newRating),
            ),
          ),
          const SizedBox(height: 32),

          if (_rating > 0) ...[
            Text('O que você gostou?', style: textTheme.titleMedium),
            const SizedBox(height: 16),
            TagsAvaliacaoWidget(
              tipo: widget.tipo,
              tagsSelecionadas: _tagsSelecionadas,
              onChanged: (tags) => setState(() => _tagsSelecionadas = tags),
            ),
            const SizedBox(height: 32),

            Text('Comentário (opcional)', style: textTheme.titleMedium),
            const SizedBox(height: 16),
            TextFormField(
              controller: _comentarioController,
              decoration: InputDecoration(
                hintText: 'Compartilhe mais detalhes...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
              maxLines: 4,
              maxLength: 300,
            ),
            const SizedBox(height: 40),
          ],

          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _rating == 0 ? null : _handleEnviarAvaliacao,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    ),
                    child: const Text('Enviar Avaliação'),
                  ),
                ),
        ],
      ),
    );
  }
}

// --- WIDGETS E FUNÇÕES DE APOIO ---

class RatingEstrelasWidget extends StatelessWidget {
  final int ratingAtual;
  final Function(int) onChanged;
  const RatingEstrelasWidget({required this.ratingAtual, required this.onChanged, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) => IconButton(
        onPressed: () => onChanged(index + 1),
        icon: Icon(
          (index + 1) <= ratingAtual ? Icons.star_rounded : Icons.star_border_rounded,
          color: Colors.amber,
          size: 40,
        ),
      )),
    );
  }
}

class TagsAvaliacaoWidget extends StatefulWidget {
  final TipoAvaliacao tipo;
  final List<String> tagsSelecionadas;
  final Function(List<String>) onChanged;
  const TagsAvaliacaoWidget({required this.tipo, required this.tagsSelecionadas, required this.onChanged, Key? key}) : super(key: key);

  @override
  State<TagsAvaliacaoWidget> createState() => _TagsAvaliacaoWidgetState();
}

class _TagsAvaliacaoWidgetState extends State<TagsAvaliacaoWidget> {
  late final List<String> _todasAsTags;

  @override
  void initState() {
    super.initState();
    _todasAsTags = widget.tipo == TipoAvaliacao.motorista
      ? ['Simpático', 'Pontual', 'Boa Direção', 'Carro Limpo', 'Boa Conversa']
      : ['Pontual', 'Local Exato', 'Respeitoso', 'Viagem Agradável'];
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: _todasAsTags.map((tag) {
        final isSelected = widget.tagsSelecionadas.contains(tag);
        return ChoiceChip(
          label: Text(tag),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                widget.tagsSelecionadas.add(tag);
              } else {
                widget.tagsSelecionadas.remove(tag);
              }
              widget.onChanged(widget.tagsSelecionadas);
            });
          },
        );
      }).toList(),
    );
  }
}

void snackSalvo(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(backgroundColor: Colors.green, content: Text('Avaliação enviada com sucesso!')),
  );
}

void alertaNegativo(BuildContext context, {required String mensagem}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Ocorreu um Erro'),
      content: Text(mensagem),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
    ),
  );
}