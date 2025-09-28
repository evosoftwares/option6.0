// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/supabase_auth/auth_util.dart';
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:geolocator/geolocator.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:battery_plus/battery_plus.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';

// Configurações otimizadas
class TrackingConfig {
  static const int minIntervalSeconds = 15;
  static const int maxIntervalSeconds = 120;
  static const double minDistanceMeters = 10.0;
  static const double highSpeedThreshold = 50.0; // km/h
  static const int maxRetryAttempts = 3;
  static const int batchSize = 5;
  static const int lowBatteryThreshold = 20;
}

// Estado do rastreamento
class TrackingState {
  Position? lastPosition;
  DateTime? lastUpdateTime;
  double currentSpeed = 0.0;
  int consecutiveStationaryCount = 0;
  List<Map<String, dynamic>> pendingUpdates = [];
  int currentInterval = 30;
  LocationAccuracy currentAccuracy = LocationAccuracy.high;

  void updateMovementState(Position newPosition) {
    if (lastPosition != null) {
      final distance = Geolocator.distanceBetween(
        lastPosition!.latitude,
        lastPosition!.longitude,
        newPosition.latitude,
        newPosition.longitude,
      );

      if (distance < TrackingConfig.minDistanceMeters) {
        consecutiveStationaryCount++;
      } else {
        consecutiveStationaryCount = 0;
      }

      currentSpeed = newPosition.speed * 3.6; // m/s to km/h
    }

    lastPosition = newPosition;
    lastUpdateTime = DateTime.now();
  }

  LocationAccuracy getOptimalAccuracy() {
    // Alta precisão para velocidades altas ou início de viagem
    if (currentSpeed > TrackingConfig.highSpeedThreshold ||
        lastPosition == null) {
      return LocationAccuracy.high;
    }

    // Precisão média para movimento normal
    if (consecutiveStationaryCount < 3) {
      return LocationAccuracy.medium;
    }

    // Baixa precisão quando parado
    return LocationAccuracy.low;
  }

  int getOptimalInterval(int batteryLevel) {
    int baseInterval = 30;

    // Ajustar baseado na velocidade
    if (currentSpeed > TrackingConfig.highSpeedThreshold) {
      baseInterval = TrackingConfig.minIntervalSeconds;
    } else if (consecutiveStationaryCount > 5) {
      baseInterval = TrackingConfig.maxIntervalSeconds;
    }

    // Ajustar baseado na bateria
    if (batteryLevel < TrackingConfig.lowBatteryThreshold) {
      baseInterval =
          math.min(baseInterval * 2, TrackingConfig.maxIntervalSeconds);
    }

    return baseInterval;
  }
}

String? _supabaseUrl;
String? _supabaseAnonKey;
String? _motoristaFirebaseUid;
TrackingState _trackingState = TrackingState();

@pragma('vm:entry-point')
Future<bool> onStartOptimized(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
    service.setForegroundNotificationInfo(
      title: "Rastreamento Inteligente",
      content: "Otimizando localização para economia de bateria",
    );
  }

  service.on('stopService').listen((event) {
    print("🛑 Serviço de rastreamento otimizado parado");
    service.stopSelf();
  });

  service.on('startParams').listen((data) async {
    if (data == null) {
      print("❌ Nenhum parâmetro recebido");
      service.stopSelf();
      return;
    }

    _supabaseUrl = data['supabaseUrl'];
    _supabaseAnonKey = data['supabaseAnonKey'];
    _motoristaFirebaseUid = data['userId'];
    final String? tripId = data['tripId'];

    if (_supabaseUrl == null ||
        _supabaseAnonKey == null ||
        _motoristaFirebaseUid == null) {
      print("❌ Parâmetros inválidos");
      service.stopSelf();
      return;
    }

    try {
      await Supabase.initialize(url: _supabaseUrl!, anonKey: _supabaseAnonKey!);
      final SupabaseClient client = Supabase.instance.client;
      final Battery battery = Battery();

      // Função otimizada para envio de atualizações
      Future<bool> enviarAtualizacaoOtimizada(Position position,
          {bool forceSend = false}) async {
        try {
          // Calcular distância usando a última posição ANTES de atualizar o estado
          final prev = _trackingState.lastPosition;
          double? distance;
          if (prev != null) {
            distance = Geolocator.distanceBetween(
              prev.latitude,
              prev.longitude,
              position.latitude,
              position.longitude,
            );
          }

          // Filtrar por distância (exceto se forçado)
          if (!forceSend &&
              distance != null &&
              distance < TrackingConfig.minDistanceMeters) {
            print(
                "📍 Movimento insignificante (${distance.toStringAsFixed(1)}m), pulando update");
            // Ainda assim atualiza estado de movimento (para contagem de paradas e velocidade)
            _trackingState.updateMovementState(position);
            return false;
          }

          final nowIso = DateTime.now().toIso8601String();
          final locationData = {
            'trip_id': tripId,
            'latitude': position.latitude,
            'longitude': position.longitude,
            'speed_kmh':
                position.speed.isFinite ? (position.speed * 3.6) : null,
            'heading': position.heading.isFinite ? position.heading : null,
            'accuracy_meters':
                position.accuracy.isFinite ? position.accuracy : null,
            'recorded_at': nowIso,
          };

          if (tripId != null && tripId.isNotEmpty) {
            // Adicionar à fila de batch
            _trackingState.pendingUpdates.add(locationData);

            // Enviar em batch quando atingir o limite ou forçado
            if (_trackingState.pendingUpdates.length >=
                    TrackingConfig.batchSize ||
                forceSend) {
              await _enviarBatchUpdates(client);
            }
          } else {
            // Comportamento legado compatível com schema atual
            await client.from('drivers').update({
              'current_latitude': position.latitude,
              'current_longitude': position.longitude,
              'last_location_update': nowIso,
            }).eq('user_id', _motoristaFirebaseUid!);

            await client.from('location_updates').insert({
              'sharing_id': _motoristaFirebaseUid!,
              'latitude': position.latitude,
              'longitude': position.longitude,
              'timestamp': nowIso,
            });
          }

          // Atualiza estado de movimento APÓS processar envio
          _trackingState.updateMovementState(position);

          return true;
        } catch (e) {
          print('❌ Erro ao processar localização: $e');
          return false;
        }
      }

      // Primeira atualização com alta precisão
      try {
        final hasPermission = await Geolocator.checkPermission();
        if (hasPermission == LocationPermission.denied ||
            hasPermission == LocationPermission.deniedForever) {
          print("❌ Permissão negada");
          service.stopSelf();
          return;
        }

        Position firstPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10),
        );

        await enviarAtualizacaoOtimizada(firstPosition, forceSend: true);
        print("✅ Primeira localização enviada");
      } catch (e) {
        print('⚠️ Erro na primeira localização: $e');
      }

      // Timer adaptativo
      Timer? adaptiveTimer;

      void scheduleNextUpdate() {
        adaptiveTimer?.cancel();

        battery.batteryLevel.then((batteryLevel) {
          final optimalInterval =
              _trackingState.getOptimalInterval(batteryLevel);
          final optimalAccuracy = _trackingState.getOptimalAccuracy();

          print(
              "🔄 Próximo update em ${optimalInterval}s (precisão: $optimalAccuracy, bateria: $batteryLevel%)");

          adaptiveTimer = Timer(Duration(seconds: optimalInterval), () async {
            try {
              final hasPermission = await Geolocator.checkPermission();
              if (hasPermission == LocationPermission.denied ||
                  hasPermission == LocationPermission.deniedForever) {
                print("❌ Permissão perdida");
                service.stopSelf();
                return;
              }

              Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: optimalAccuracy,
                timeLimit: Duration(
                    seconds: optimalAccuracy == LocationAccuracy.high ? 10 : 5),
              );

              final sent = await enviarAtualizacaoOtimizada(position);
              if (sent) {
                print(
                    "📡 Localização enviada: ${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)} (${_trackingState.currentSpeed.toStringAsFixed(1)} km/h)");
              }

              // Agendar próxima atualização
              scheduleNextUpdate();
            } catch (e) {
              print('❌ Erro no timer adaptativo: $e');
              // Reagendar mesmo com erro
              scheduleNextUpdate();
            }
          });
        });
      }

      // Iniciar ciclo adaptativo
      scheduleNextUpdate();

      // Cleanup ao parar
      service.on('stopService').listen((event) async {
        adaptiveTimer?.cancel();
        // Enviar updates pendentes antes de parar
        if (_trackingState.pendingUpdates.isNotEmpty) {
          await _enviarBatchUpdates(client);
        }
        print("🛑 Serviço parado, updates pendentes enviados");
      });
    } catch (e) {
      print('❌ Erro na inicialização otimizada: $e');
      service.stopSelf();
    }
  });

  return true;
}

// Função para enviar updates em batch com retry
Future<void> _enviarBatchUpdates(SupabaseClient client) async {
  if (_trackingState.pendingUpdates.isEmpty) return;

  final updates =
      List<Map<String, dynamic>>.from(_trackingState.pendingUpdates);
  _trackingState.pendingUpdates.clear();

  for (int attempt = 1; attempt <= TrackingConfig.maxRetryAttempts; attempt++) {
    try {
      await client.from('trip_location_history').insert(updates);
      print(
          "✅ Batch de ${updates.length} updates enviado (tentativa $attempt)");
      return;
    } catch (e) {
      print("❌ Erro no batch (tentativa $attempt): $e");
      if (attempt == TrackingConfig.maxRetryAttempts) {
        print("💾 Salvando ${updates.length} updates para próxima tentativa");
        _trackingState.pendingUpdates.addAll(updates);
      } else {
        await Future.delayed(
            Duration(seconds: attempt * 2)); // Backoff exponencial
      }
    }
  }
}

Future<void> initializeOptimizedService() async {
  // Bloquear inicialização em plataformas não Android
  if (!isAndroid) {
    debugPrint('ℹ️ Rastreamento otimizado restrito ao Android. Ignorando inicialização do serviço.');
    return;
  }

  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStartOptimized,
      onBackground: onStartOptimized,
    ),
    androidConfiguration: AndroidConfiguration(
      isForegroundMode: true,
      autoStart: true,
      onStart: onStartOptimized,
      foregroundServiceTypes: [AndroidForegroundType.location],
    ),
  );
}

// Função principal otimizada para rastreamento de viagem
Future<bool> iniciarRastreamentoViagemOtimizado(
    BuildContext context, String tripId) async {
  // Android-only: bloquear iOS/Web
  if (!isAndroid) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rastreamento de fundo disponível apenas no Android por enquanto.'),
        duration: Duration(seconds: 5),
      ),
    );
    return false;
  }

  // Consentimento explícito do usuário para rastreamento em segundo plano
  const consentKey = 'driver_bg_location_consent';
  final prefs = await SharedPreferences.getInstance();
  final hasConsent = prefs.getBool(consentKey) ?? false;
  if (!hasConsent) {
    final accepted = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Permitir rastreamento em segundo plano?'),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                        'Enquanto você estiver ONLINE como motorista, sua localização será coletada continuamente em segundo plano e enviada para melhorar a disponibilidade, segurança e o matching de corridas.'),
                    SizedBox(height: 12),
                    Text(
                        'Dados enviados: latitude, longitude e horário da coleta. Você pode ficar OFFLINE a qualquer momento para parar o envio.'),
                    SizedBox(height: 12),
                    Text(
                        'Ao continuar, você concorda com o uso descrito acima e com nossa Política de Privacidade.'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Não permitir'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text('Concordo'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!accepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Consentimento obrigatório para ficar online como motorista.'),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    await prefs.setBool(consentKey, true);
  }

  // Verificações de permissão (reutilizando lógica existente)
  var locationStatus = await Permission.location.request();
  if (locationStatus.isDenied || locationStatus.isPermanentlyDenied) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text(
              'Permissão de localização necessária para rastreamento otimizado')),
    );
    if (locationStatus.isPermanentlyDenied) await openAppSettings();
    return false;
  }

  var backgroundStatus = await Permission.locationAlways.request();
  if (!backgroundStatus.isGranted) {
    // Mostrar diálogo informativo antes de abrir configurações
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Configurar Localização'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Para funcionar como motorista, você precisa habilitar:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12),
                Text('• Localização: "Permitir o tempo todo"'),
                Text('• Atividade em segundo plano'),
                SizedBox(height: 12),
                Text(
                  'Isso é necessário para receber corridas e garantir a segurança.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: Text('Abrir Configurações'),
            ),
          ],
        );
      },
    );
    return false;
  }

  // Parar serviço anterior se existir
  final service = FlutterBackgroundService();
  if (await service.isRunning()) {
    service.invoke('stopService');
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Inicializar serviço otimizado (Android-only)
  await initializeOptimizedService();

  final currentUserId = currentUserUid;
  if (currentUserId == null || currentUserId.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuário não autenticado')),
    );
    return false;
  }

  // Iniciar com parâmetros otimizados
  service.invoke('startParams', {
    'supabaseUrl': FFAppState().supabaseUrl,
    'supabaseAnonKey': FFAppState().supabaseAnnonkey,
    'userId': currentUserId,
    'tripId': tripId,
    'intervalSeconds': 30, // Base, será adaptado dinamicamente
  });

  await Future.delayed(const Duration(milliseconds: 300));

  if (await service.isRunning()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🚀 Rastreamento inteligente iniciado')),
    );
    return true;
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Falha ao iniciar rastreamento otimizado')),
    );
    return false;
  }
}

Future<void> pararRastreamentoOtimizado() async {
  final service = FlutterBackgroundService();
  service.invoke('stopService');
  print("🛑 Comando de parada enviado para serviço otimizado");
}
