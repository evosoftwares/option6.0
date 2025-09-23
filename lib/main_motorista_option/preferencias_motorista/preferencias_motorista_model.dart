import '/backend/supabase/supabase.dart';
import '/backend/supabase/database/database.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'preferencias_motorista_widget.dart' show PreferenciasMotoristaWidget;
import 'package:flutter/material.dart';

class PreferenciasMotoristaModel
    extends FlutterFlowModel<PreferenciasMotoristaWidget> {
  /// State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();

  // State fields for switches
  bool? acceptsPetValue;
  bool? acceptsGroceryValue;
  bool? acceptsCondoValue;

  // State fields for fee text fields
  FocusNode? petFeeFocusNode;
  TextEditingController? petFeeTextController;
  String? Function(BuildContext, String?)? petFeeTextControllerValidator;

  FocusNode? groceryFeeFocusNode;
  TextEditingController? groceryFeeTextController;
  String? Function(BuildContext, String?)? groceryFeeTextControllerValidator;

  FocusNode? condoFeeFocusNode;
  TextEditingController? condoFeeTextController;
  String? Function(BuildContext, String?)? condoFeeTextControllerValidator;

  FocusNode? stopFeeFocusNode;
  TextEditingController? stopFeeTextController;
  String? Function(BuildContext, String?)? stopFeeTextControllerValidator;

  // Driver data
  DriversRow? driverData;

  @override
  void initState(BuildContext context) {
    petFeeTextControllerValidator = _validateCurrency;
    groceryFeeTextControllerValidator = _validateCurrency;
    condoFeeTextControllerValidator = _validateCurrency;
    stopFeeTextControllerValidator = _validateCurrency;
  }

  @override
  void dispose() {
    petFeeFocusNode?.dispose();
    petFeeTextController?.dispose();

    groceryFeeFocusNode?.dispose();
    groceryFeeTextController?.dispose();

    condoFeeFocusNode?.dispose();
    condoFeeTextController?.dispose();

    stopFeeFocusNode?.dispose();
    stopFeeTextController?.dispose();
  }

  // Helper method to format currency
  String formatCurrency(double? value) {
    if (value == null || value == 0.0) return '';
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  // Helper method to parse currency
  double parseCurrency(String value) {
    if (value.isEmpty) return 0.0;
    String cleanValue =
        value.replaceAll('R\$', '').replaceAll(' ', '').replaceAll(',', '.');
    return double.tryParse(cleanValue) ?? 0.0;
  }

  // Validation for currency fields
  String? _validateCurrency(BuildContext context, String? value) {
    if (value == null || value.isEmpty) return null;

    double? amount = double.tryParse(value.replaceAll(',', '.'));
    if (amount == null) {
      return 'Insira um valor válido';
    }
    if (amount < 0) {
      return 'O valor não pode ser negativo';
    }
    if (amount > 100) {
      return 'O valor não pode ser maior que R\$ 100,00';
    }
    return null;
  }

  // Initialize form with driver data
  void initializeWithDriverData(DriversRow driver) {
    driverData = driver;

    // Initialize switches
    acceptsPetValue = driver.acceptsPet ?? false;
    acceptsGroceryValue = driver.acceptsGrocery ?? false;
    acceptsCondoValue = driver.acceptsCondo ?? false;

    // Initialize text controllers
    petFeeTextController =
        TextEditingController(text: formatCurrency(driver.petFee));
    groceryFeeTextController =
        TextEditingController(text: formatCurrency(driver.groceryFee));
    condoFeeTextController =
        TextEditingController(text: formatCurrency(driver.condoFee));
    stopFeeTextController =
        TextEditingController(text: formatCurrency(driver.stopFee));

    // Initialize focus nodes
    petFeeFocusNode = FocusNode();
    groceryFeeFocusNode = FocusNode();
    condoFeeFocusNode = FocusNode();
    stopFeeFocusNode = FocusNode();
  }
}
