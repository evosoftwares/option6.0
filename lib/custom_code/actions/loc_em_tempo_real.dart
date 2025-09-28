// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:geolocator/geolocator.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/auth/supabase_auth/auth_util.dart';
import 'package:permission_handler/permission_handler.dart';

String? _supabaseUrl;
String? _supabaseAnonKey;
String? _motoristaFirebaseUid;

@pragma('vm:entry-point')
Future<bool> onStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
    service.setForegroundNotificationInfo(
      title: "Rastreamento ativo",
      content: "Sua localização está sendo atualizada em tempo real",
    );
  }

  service.on('stopService').listen((event) {
    print("Serviço de rastreamento parado manualmente.");
    service.stopSelf();
  });

  service.on('startParams').listen((data) async {
    if (data == null) {
      print("Nenhum parâmetro recebido, encerrando serviço.");
      service.stopSelf();
      return;
    }

    _supabaseUrl = data['supabaseUrl'];
    _supabaseAnonKey = data['supabaseAnonKey'];
    _motoristaFirebaseUid = data['userId'];
    final String? tripId = data['tripId'];
    final int intervalSeconds =
        (data['intervalSeconds'] is int && data['intervalSeconds'] > 0)
            ? data['intervalSeconds'] as int
            : 10; // padrão legado

    if (_supabaseUrl == null ||
        _supabaseAnonKey == null ||
        _motoristaFirebaseUid == null) {
      print("Parâmetros inválidos para o serviço de localização.");
      service.stopSelf();
      return;
    }

    // Atualiza mensagem da notificação se houver uma viagem ativa
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title:
            tripId != null ? "Rastreando viagem ativa" : "Rastreamento ativo",
        content: tripId != null
            ? "Registrando localização da viagem a cada ${intervalSeconds}s"
            : "Sua localização está sendo atualizada em tempo real",
      );
    }

    try {
      await Supabase.initialize(
        url: _supabaseUrl!,
        anonKey: _supabaseAnonKey!,
      );

      final SupabaseClient client = Supabase.instance.client;
      final Duration updateInterval = Duration(seconds: intervalSeconds);

      Future<void> enviarAtualizacao(Position position) async {
        try {
          final nowIso = DateTime.now().toIso8601String();
          final double? speedKmh = (position.speed.isFinite)
              ? (position.speed * 3.6)
              : null; // m/s -> km/h
          final double? heading =
              position.heading.isFinite ? position.heading : null; // graus
          final double? accuracy =
              position.accuracy.isFinite ? position.accuracy : null; // metros

          if (tripId != null && tripId.isNotEmpty) {
            // Registrar no histórico de localização da viagem
            await client.from('trip_location_history').insert({
              'trip_id': tripId,
              'latitude': position.latitude,
              'longitude': position.longitude,
              'speed_kmh': speedKmh,
              'heading': heading,
              'accuracy_meters': accuracy,
              'recorded_at': nowIso,
            });
          } else {
            // Comportamento legado: atualizar tabela geral (compatível com schema atual)
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
        } catch (e) {
          print('ERRO ao enviar atualização de localização: $e');
        }
      }

      // Primeira atualização imediata
      try {
        final hasPermission = await Geolocator.checkPermission();
        if (hasPermission == LocationPermission.denied ||
            hasPermission == LocationPermission.deniedForever) {
          print("Permissão de localização negada. Encerrando rastreamento.");
          service.stopSelf();
          return;
        }
        Position first = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 5),
        );
        await enviarAtualizacao(first);
      } catch (e) {
        print('Não foi possível obter a primeira localização: $e');
      }

      // Loop periódico
      Timer.periodic(updateInterval, (timer) async {
        try {
          final hasPermission = await Geolocator.checkPermission();
          if (hasPermission == LocationPermission.denied ||
              hasPermission == LocationPermission.deniedForever) {
            print("Permissão de localização negada. Encerrando rastreamento.");
            timer.cancel();
            service.stopSelf();
            return;
          }

          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            timeLimit: const Duration(seconds: 5),
          );

          print(
              "Enviando localização: lat=${position.latitude}, lng=${position.longitude} (tripId: ${tripId ?? '-'}).");

          await enviarAtualizacao(position);
        } catch (e) {
          print('ERRO no loop do serviço de localização: $e');
        }
      });
    } catch (e) {
      print('ERRO na inicialização do serviço de localização: $e');
      service.stopSelf();
    }
  });

  return true;
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onStart,
    ),
    androidConfiguration: AndroidConfiguration(
      isForegroundMode: true,
      autoStart: true,
      onStart: onStart,
      foregroundServiceTypes: [
        AndroidForegroundType.location,
      ],
    ),
  );
}

Future<bool> locEmTempoReal(BuildContext context) async {
  // Encaminha para o fluxo otimizado sem trip (usa branch de atualização geral)
  return await iniciarRastreamentoViagemOtimizado(context, '');
}

// NOVO: Iniciar rastreamento específico de uma viagem, enviando updates para trip_location_history a cada 30s
Future<bool> iniciarRastreamentoViagem(
    BuildContext context, String tripId) async {
  // Encaminhar para o fluxo otimizado que já contempla consentimento explícito e guards Android
  return await iniciarRastreamentoViagemOtimizado(context, tripId);
}

Future<void> stopBackgroundLocationService() async {
  // Encaminha para o stop otimizado
  await pararRastreamentoOtimizado();
}
