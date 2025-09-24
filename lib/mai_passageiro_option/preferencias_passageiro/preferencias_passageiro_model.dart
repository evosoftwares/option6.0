import '/flutter_flow/flutter_flow_model.dart'
    show FlutterFlowModel;
import 'package:flutter/material.dart';

class PreferenciasPassageiroModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  // State field(s) for vehicle category
  String vehicleCategory = '';
  // Lista dinâmica de categorias vindas de platform_settings
  List<String> platformCategories = [];

  // State field(s) for payment method
  String paymentMethod = 'dinheiro';

  // State field(s) for preferences switches
  bool needsPet = false;
  bool needsGrocerySpace = false;
  bool needsAc = false;
  bool needsCondoAccess = false;
  bool allowSmoking = false;
  bool preferQuietRide = false;
  bool needsChildSeat = false;
  bool needsWheelchairAccess = false;

  // State field(s) for additional preferences
  String musicPreference = 'sem_preferencia';
  String conversationPreference = 'sem_preferencia';

  // Loading state
  bool isLoading = false;
  bool isSaving = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }

  /// Action blocks.
  Future<void> loadPassengerPreferences() async {
    // TODO: Implementar carregamento das preferências do passageiro do Supabase
  }

  Future<void> savePassengerPreferences() async {
    // TODO: Implementar salvamento das preferências do passageiro no Supabase
  }
}