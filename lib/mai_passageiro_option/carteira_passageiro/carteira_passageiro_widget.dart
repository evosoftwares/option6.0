import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'carteira_passageiro_model.dart';
export 'carteira_passageiro_model.dart';

class CarteiraPassageiroWidget extends StatefulWidget {
  const CarteiraPassageiroWidget({super.key});

  static String routeName = 'carteiraPassageiro';
  static String routePath = '/carteiraPassageiro';

  @override
  State<CarteiraPassageiroWidget> createState() => _CarteiraPassageiroWidgetState();
}

class _CarteiraPassageiroWidgetState extends State<CarteiraPassageiroWidget> {
  late CarteiraPassageiroModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Cache para otimização de performance
  Future<PassengerWalletsRow?>? _walletFuture;
  Future<List<PassengerWalletTransactionsRow>>? _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CarteiraPassageiroModel());

    // Inicializar dados da carteira
    _initializeWalletData();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: Text(
          'Carteira do Passageiro',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                font: GoogleFonts.roboto(
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).primaryText,
                letterSpacing: 0.0,
              ),
        ),
        centerTitle: false,
        elevation: 1.0,
      ),
      body: SafeArea(
        top: true,
        child: _walletFuture == null || _transactionsFuture == null
          ? Center(
              child: CircularProgressIndicator(
                color: FlutterFlowTheme.of(context).primary,
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await _initializeWalletData();
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Saldo da carteira
                  FutureBuilder<PassengerWalletsRow?>(
                    future: _walletFuture,
                    builder: (context, walletSnapshot) {
                      if (walletSnapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                        );
                      }

                      final wallet = walletSnapshot.data;

                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Saldo disponível',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                color: Colors.white.withValues(alpha: 0.8),
                                letterSpacing: 0.0,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'R\$ ${(wallet?.availableBalance ?? 0.0).toStringAsFixed(2)}',
                              style: FlutterFlowTheme.of(context).headlineLarge.override(
                                color: Colors.white,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (wallet?.pendingBalance != null && wallet!.pendingBalance! > 0) ...[
                              SizedBox(height: 8.0),
                              Text(
                                'Saldo pendente: R\$ ${wallet.pendingBalance!.toStringAsFixed(2)}',
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 24.0),

                  // Título das transações
                  Text(
                    'Transações Recentes',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 16.0),

                  // Lista de transações
                  FutureBuilder<List<PassengerWalletTransactionsRow>>(
                    future: _transactionsFuture,
                    builder: (context, transactionsSnapshot) {
                      if (transactionsSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        );
                      }

                      if (transactionsSnapshot.hasError) {
                        // Mostra empty state ao invés de erro para melhor UX
                        return Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 64.0,
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                'Suas transações aparecerão aqui',
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                  letterSpacing: 0.0,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Puxe para baixo para atualizar',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  letterSpacing: 0.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }

                      final transactions = transactionsSnapshot.data ?? [];

                      if (transactions.isEmpty) {
                        return Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 64.0,
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                'Nenhuma transação encontrada',
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                  letterSpacing: 0.0,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Suas transações aparecerão aqui',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  letterSpacing: 0.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: transactions.length,
                        separatorBuilder: (context, index) => SizedBox(height: 12.0),
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          return Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: _getTransactionColor(transaction.type),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _getTransactionIcon(transaction.type),
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                ),
                                SizedBox(width: 12.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getTransactionTitle(transaction.type),
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (transaction.description != null) ...[
                                        SizedBox(height: 4.0),
                                        Text(
                                          transaction.description!,
                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                            letterSpacing: 0.0,
                                          ),
                                        ),
                                      ],
                                      SizedBox(height: 4.0),
                                      Text(
                                        _formatTransactionDate(transaction.createdAt),
                                        style: FlutterFlowTheme.of(context).bodySmall.override(
                                          color: FlutterFlowTheme.of(context).secondaryText,
                                          letterSpacing: 0.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${transaction.amount! >= 0 ? '+' : ''}R\$ ${transaction.amount!.toStringAsFixed(2)}',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    color: transaction.amount! >= 0
                                      ? FlutterFlowTheme.of(context).success
                                      : FlutterFlowTheme.of(context).error,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
                ),
              ),
            ),
      ),
    );
  }

  /// Inicializa os dados da carteira de forma otimizada
  Future<void> _initializeWalletData() async {
    try {
      final passengerId = await _getPassengerIdForCurrentUser();
      if (passengerId != null) {
        setState(() {
          // Cache da carteira com timeout
          _walletFuture = PassengerWalletsTable().queryRows(
            queryFn: (q) => q.eq('passenger_id', passengerId).limit(1),
          ).then((wallets) => wallets.isNotEmpty ? wallets.first : null)
          .timeout(
            Duration(seconds: 8),
            onTimeout: () {
              print('⏰ [CARTEIRA_PASSAGEIRO] Timeout na consulta da carteira');
              return null; // Retorna null em caso de timeout
            },
          );

          // Cache das transações com timeout
          _transactionsFuture = PassengerWalletTransactionsTable().queryRows(
            queryFn: (q) => q
                .eq('passenger_id', passengerId)
                .order('created_at', ascending: false)
                .limit(20),
          ).timeout(
            Duration(seconds: 10),
            onTimeout: () {
              print('⏰ [CARTEIRA_PASSAGEIRO] Timeout na consulta de transações');
              return <PassengerWalletTransactionsRow>[]; // Retorna lista vazia
            },
          );
        });
      }
    } catch (e) {
      print('💥 [CARTEIRA_PASSAGEIRO] Erro ao inicializar dados: $e');
    }
  }

  /// Busca o passenger_id do usuário atual
  Future<String?> _getPassengerIdForCurrentUser() async {
    try {
      // Primeiro tenta buscar o app_user pelo e-mail do Firebase Auth
      final String? email = currentUserEmail;
      final String? fcm = currentUserUid;

      List<AppUsersRow> appUsers = [];

      // Tentativa 1: Buscar por email
      if (email != null && email.isNotEmpty) {
        appUsers = await AppUsersTable().queryRows(
          queryFn: (q) => q.eq('email', email).limit(1),
        );
        print('🔍 [CARTEIRA_PASSAGEIRO] Buscando por email: $email - Encontrados: ${appUsers.length}');
      }

      // Tentativa 2: Fallback para FCM token se não encontrou por email
      if (appUsers.isEmpty && fcm != null && fcm.isNotEmpty) {
        appUsers = await AppUsersTable().queryRows(
          queryFn: (q) => q.eq('fcm_token', fcm).limit(1),
        );
        print('🔍 [CARTEIRA_PASSAGEIRO] Fallback FCM: $fcm - Encontrados: ${appUsers.length}');
      }

      if (appUsers.isEmpty) {
        print('❌ [CARTEIRA_PASSAGEIRO] App user não encontrado. Email: $email, FCM: $fcm');
        return null;
      }

      final appUserId = appUsers.first.id;
      print('✅ [CARTEIRA_PASSAGEIRO] App user encontrado: $appUserId');

      // Agora busca o passenger pelo app_user_id
      final passengers = await PassengersTable().queryRows(
        queryFn: (q) => q.eq('user_id', appUserId),
      );

      if (passengers.isEmpty) {
        print('❌ [CARTEIRA_PASSAGEIRO] Passenger não encontrado para user_id: $appUserId');
        return null;
      }

      final passengerId = passengers.first.id;
      print('✅ [CARTEIRA_PASSAGEIRO] Passenger encontrado: $passengerId');
      return passengerId;

    } catch (e) {
      print('💥 [CARTEIRA_PASSAGEIRO] Erro ao buscar passenger: $e');
      return null;
    }
  }

  /// Formata a data da transação
  String _formatTransactionDate(DateTime? date) {
    if (date == null) return '';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoje, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      final weekdays = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
      return '${weekdays[date.weekday % 7]}';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
    }
  }

  /// Retorna a cor do tipo de transação
  Color _getTransactionColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'payment':
      case 'trip_payment':
        return FlutterFlowTheme.of(context).error;
      case 'refund':
      case 'cashback':
      case 'credit':
        return FlutterFlowTheme.of(context).success;
      case 'top_up':
      case 'deposit':
        return FlutterFlowTheme.of(context).primary;
      default:
        return FlutterFlowTheme.of(context).secondaryText;
    }
  }

  /// Retorna o ícone do tipo de transação
  IconData _getTransactionIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'payment':
      case 'trip_payment':
        return Icons.payment;
      case 'refund':
        return Icons.keyboard_return;
      case 'cashback':
        return Icons.card_giftcard;
      case 'credit':
        return Icons.add_circle;
      case 'top_up':
      case 'deposit':
        return Icons.account_balance_wallet;
      default:
        return Icons.help_outline;
    }
  }

  /// Retorna o título do tipo de transação
  String _getTransactionTitle(String? type) {
    switch (type?.toLowerCase()) {
      case 'payment':
      case 'trip_payment':
        return 'Pagamento de Viagem';
      case 'refund':
        return 'Reembolso';
      case 'cashback':
        return 'Cashback';
      case 'credit':
        return 'Crédito';
      case 'top_up':
        return 'Recarga';
      case 'deposit':
        return 'Depósito';
      default:
        return type ?? 'Transação';
    }
  }
}