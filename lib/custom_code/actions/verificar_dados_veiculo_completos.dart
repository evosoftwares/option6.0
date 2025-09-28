import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/backend/supabase/database/database.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import '../../flutter_flow/user_id_converter.dart';

/// Verifica se todos os dados obrigatórios do veículo foram preenchidos
/// Retorna true se completo, false caso contrário
Future<bool> verificarDadosVeiculoCompletos() async {
  // Convert Firebase UID to app_users.id for database queries
  final appUserId = await UserIdConverter.getAppUserIdFromSupabaseUid(currentUserUid);
  
  if (appUserId == null) {
    return false; // User not found
  }

  try {
    final driver = await DriversTable().queryRows(
      queryFn: (q) => q.eq('user_id', appUserId),
    );

    if (driver.isEmpty) {
      return false;
    }

    final driverData = driver.first;

    // Verificar se todos os campos obrigatórios estão preenchidos
    return driverData.vehicleCategory != null &&
           driverData.vehicleCategory!.isNotEmpty &&
           driverData.vehicleBrand != null &&
           driverData.vehicleBrand!.isNotEmpty &&
           driverData.vehicleModel != null &&
           driverData.vehicleModel!.isNotEmpty &&
           driverData.vehicleYear != null &&
           driverData.vehicleColor != null &&
           driverData.vehicleColor!.isNotEmpty &&
           driverData.vehiclePlate != null &&
           driverData.vehiclePlate!.isNotEmpty;
  } catch (e) {
    debugPrint('❌ Erro ao verificar dados do veículo: $e');
    return false;
  }
}

/// Redireciona o motorista para a tela de veículo se os dados não estiverem completos
/// Mostra snackbar explicativo
Future<void> redirecionarParaVeiculoSeIncompleto(BuildContext context) async {
  final isComplete = await verificarDadosVeiculoCompletos();

  if (!isComplete) {
    // Convert Firebase UID to app_users.id for database queries
    final appUserId = await UserIdConverter.getAppUserIdFromSupabaseUid(currentUserUid);
    
    if (appUserId == null) {
      return; // User not found
    }
    
    // Obter dados do driver para passar para a tela
    final driver = await DriversTable().queryRows(
      queryFn: (q) => q.eq('user_id', appUserId),
    );

    if (driver.isNotEmpty) {
      // Mostrar snackbar informativo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Complete os dados do seu veículo para receber corridas',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          duration: Duration(milliseconds: 4000),
          backgroundColor: FlutterFlowTheme.of(context).warning,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          action: SnackBarAction(
            label: 'COMPLETAR',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );

      // Redirecionar para a tela de veículo
      context.pushNamedAuth(
        'meuVeiculo',
        context.mounted,
        queryParameters: {
          'driver': serializeParam(
            driver.first,
            ParamType.SupabaseRow,
          ) ?? '',
        },
      );
    }
  }
}

/// Verifica dados do veículo e retorna o status
/// Usado para validações em tempo real
Future<VehicleCompletionStatus> obterStatusVeiculo() async {
  // Convert Firebase UID to app_users.id for database queries
  final appUserId = await UserIdConverter.getAppUserIdFromSupabaseUid(currentUserUid);
  
  if (appUserId == null) {
    return VehicleCompletionStatus(
      isComplete: false,
      missingFields: ['Usuário não encontrado'],
      completedFields: [],
    );
  }
  
  try {
    final driver = await DriversTable().queryRows(
      queryFn: (q) => q.eq('user_id', appUserId),
    );

    if (driver.isEmpty) {
      return VehicleCompletionStatus(
        isComplete: false,
        missingFields: ['Dados do motorista não encontrados'],
        completedFields: [],
      );
    }

    final driverData = driver.first;
    final missingFields = <String>[];
    final completedFields = <String>[];

    // Verificar cada campo
    if (driverData.vehicleCategory == null || driverData.vehicleCategory!.isEmpty) {
      missingFields.add('Tipo de Veículo');
    } else {
      completedFields.add('Tipo de Veículo');
    }

    if (driverData.vehicleBrand == null || driverData.vehicleBrand!.isEmpty) {
      missingFields.add('Marca');
    } else {
      completedFields.add('Marca');
    }

    if (driverData.vehicleModel == null || driverData.vehicleModel!.isEmpty) {
      missingFields.add('Modelo');
    } else {
      completedFields.add('Modelo');
    }

    if (driverData.vehicleYear == null) {
      missingFields.add('Ano');
    } else {
      completedFields.add('Ano');
    }

    if (driverData.vehicleColor == null || driverData.vehicleColor!.isEmpty) {
      missingFields.add('Cor');
    } else {
      completedFields.add('Cor');
    }

    if (driverData.vehiclePlate == null || driverData.vehiclePlate!.isEmpty) {
      missingFields.add('Placa');
    } else {
      completedFields.add('Placa');
    }

    return VehicleCompletionStatus(
      isComplete: missingFields.isEmpty,
      missingFields: missingFields,
      completedFields: completedFields,
    );
  } catch (e) {
    debugPrint('❌ Erro ao obter status do veículo: $e');
    return VehicleCompletionStatus(
      isComplete: false,
      missingFields: ['Erro ao verificar dados'],
      completedFields: [],
    );
  }
}

/// Classe para retornar o status completo da validação do veículo
class VehicleCompletionStatus {
  final bool isComplete;
  final List<String> missingFields;
  final List<String> completedFields;

  VehicleCompletionStatus({
    required this.isComplete,
    required this.missingFields,
    required this.completedFields,
  });

  double get completionPercentage {
    final total = missingFields.length + completedFields.length;
    if (total == 0) return 0.0;
    return completedFields.length / total;
  }

  String get statusMessage {
    if (isComplete) {
      return 'Dados do veículo completos!';
    } else {
      return 'Faltam ${missingFields.length} campo(s): ${missingFields.join(', ')}';
    }
  }
}