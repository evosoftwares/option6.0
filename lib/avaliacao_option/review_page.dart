import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- Modelo de Dados para uma Avaliação ---
class Review {
  final String name;
  final String avatarUrl;
  final DateTime ratedAt;
  final int rating;
  final String? comment;

  Review({
    required this.name,
    required this.avatarUrl,
    required this.ratedAt,
    required this.rating,
    this.comment,
  });

  factory Review.fromMap(Map<String, dynamic> map, TipoAvaliacao quemFoiAvaliado) {
    bool eAvaliacaoDeMotorista = quemFoiAvaliado == TipoAvaliacao.motorista;
    
    final chaveDadosAvaliador = eAvaliacaoDeMotorista ? 'passenger_user_id' : 'driver_user_id';
    final avaliador = map[chaveDadosAvaliador] as Map<String, dynamic>?;
    
    return Review(
      name: avaliador?['full_name'] ?? 'Usuário Anônimo',
      avatarUrl: avaliador?['photo_url'] ?? 'https://i.pravatar.cc/150', // URL padrão
      ratedAt: DateTime.parse(eAvaliacaoDeMotorista ? map['driver_rated_at'] : map['passenger_rated_at']),
      rating: eAvaliacaoDeMotorista ? map['driver_rating'] : map['passenger_rating'],
      comment: eAvaliacaoDeMotorista ? map['driver_rating_comment'] : map['passenger_rating_comment'],
    );
  }
}

// Enum para saber de quem é avaliações
enum TipoAvaliacao { 
  motorista, 
  passageiro 
}


// --- EPRINCIPAL E LÓGICA ---

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({
    super.key,
    required this.userId,
    required this.userType,
  });
  
  final String userId;
  final TipoAvaliacao userType;

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  late Future<List<Review>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _reviewsFuture = _fetchReviews();
  }

  Future<List<Review>> _fetchReviews() async {
    final supabase = Supabase.instance.client;
    
    final colunaUsuarioAvaliado = widget.userType == TipoAvaliacao.motorista 
      ? 'driver_user_id' 
      : 'passenger_user_id';
      
    final colunaRating = widget.userType == TipoAvaliacao.motorista
      ? 'driver_rating'
      : 'passenger_rating';

    final colunaUsuarioAvaliador = widget.userType == TipoAvaliacao.motorista
      ? 'passenger_user_id'
      : 'driver_user_id';

    try {
      // Consulta para procurar as avaliações, incluindo dados de quem avaliou
      // através de um JOIN com a tabela app_users
      final response = await supabase
          .from('ratings')
          .select('*, $colunaUsuarioAvaliador:app_users!inner(*)')
          .eq(colunaUsuarioAvaliado, widget.userId)
          .not(colunaRating, 'is', null) 
          .order(
            widget.userType == TipoAvaliacao.motorista ? 'driver_rated_at' : 'passenger_rated_at',
            ascending: false
          );

      final reviews = response
          .map<Review>((item) => Review.fromMap(item, widget.userType))
          .toList();
          
      return reviews;
    } catch (e) {
      print('Erro ao procurar avaliações: $e');
      throw Exception('Não foi possível carregar as avaliações.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(PhosphorIcons.arrowLeft(PhosphorIconsStyle.regular)),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text('Avaliações'),
      ),
      body: FutureBuilder<List<Review>>(
        future: _reviewsFuture,
        builder: (context, snapshot) {
          // Estado de carregamento
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Estado de erro
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          // Dados carregados com sucesso
          final reviews = snapshot.data ?? [];

          // Se não houver avaliações
          if (reviews.isEmpty) {
            return const Center(child: Text('Nenhuma avaliação recebida ainda.'));
          }
          
          // Renderiza a lista de avaliações
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _RatingsSummaryCard(reviews: reviews),
              const SizedBox(height: 24),
              Text(
                'Avaliações Recentes',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...reviews.map((review) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _ReviewCard(review: review),
              )).toList(),
            ],
          );
        },
      ),
    );
  }
}

// --- WIDGETS DA UI  ---

class _RatingsSummaryCard extends StatelessWidget {
  final List<Review> reviews;
  const _RatingsSummaryCard({required this.reviews});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Calcula a média e a distribuição
    final totalReviews = reviews.length;
    final averageRating = totalReviews > 0 
        ? reviews.map((r) => r.rating).reduce((a, b) => a + b) / totalReviews
        : 0.0;
        
    final ratingCounts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (var review in reviews) {
      ratingCounts[review.rating] = (ratingCounts[review.rating] ?? 0) + 1;
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Wrap(
        spacing: 24.0,
        runSpacing: 24.0,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _OverallRating(averageRating: averageRating, totalReviews: totalReviews),
          SizedBox(
            width: 250,
            child: _RatingDistribution(ratingCounts: ratingCounts, totalReviews: totalReviews),
          ),
        ],
      ),
    );
  }
}

class _OverallRating extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  const _OverallRating({required this.averageRating, required this.totalReviews});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          averageRating.toStringAsFixed(1),
          style: theme.textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        StarRating(
          rating: averageRating,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          '$totalReviews avaliações',
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
        ),
      ],
    );
  }
}

class _RatingDistribution extends StatelessWidget {
  final Map<int, int> ratingCounts;
  final int totalReviews;
  const _RatingDistribution({required this.ratingCounts, required this.totalReviews});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final ratingValue = 5 - index;
        final count = ratingCounts[ratingValue] ?? 0;
        final percentage = totalReviews > 0 ? (count / totalReviews * 100) : 0;
        return RatingBar(label: '$ratingValue', percentage: percentage.toInt());
      }).toList(),
    );
  }
}

class RatingBar extends StatelessWidget {
  final String label;
  final int percentage;
  const RatingBar({super.key, required this.label, required this.percentage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage / 100,
                minHeight: 6,
                backgroundColor: theme.brightness == Brightness.dark 
                    ? const Color(0xFF3D3D3D) 
                    : Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.secondary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 35,
            child: Text(
              '$percentage%',
              textAlign: TextAlign.right,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;
  const _ReviewCard({required this.review});

  String _tempoAtras(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 365) {
      return 'há ${(difference.inDays / 365).floor()} anos';
    } else if (difference.inDays > 30) {
      return 'há ${(difference.inDays / 30).floor()} meses';
    } else if (difference.inDays > 0) {
      return 'há ${difference.inDays} dias';
    } else if (difference.inHours > 0) {
      return 'há ${difference.inHours} horas';
    } else {
      return 'Agora mesmo';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(review.avatarUrl),
            onBackgroundImageError: (_, __) {}, // Evita o crash se a imagem falhar
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.name,
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  _tempoAtras(review.ratedAt),
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
                ),
                const SizedBox(height: 8),
                StarRating(rating: review.rating.toDouble()),
                if (review.comment != null && review.comment!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    review.comment!,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          )
        ],
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final double rating;
  final double size;
  const StarRating({super.key, required this.rating, this.size = 18.0});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        IconData iconData;
        if (index < rating.round()) {
          iconData = PhosphorIcons.star(PhosphorIconsStyle.fill);
        } else {
          iconData = PhosphorIcons.star(PhosphorIconsStyle.regular);
        }
        return Icon(
          iconData,
          size: size,
          color: index < rating.round() ? color : Colors.grey.shade400,
        );
      }),
    );
  }
}

