import '/flutter_flow/flutter_flow_util.dart';
import 'logout_button_widget.dart' show LogoutButtonWidget;
import 'package:flutter/material.dart';

class LogoutButtonModel extends FlutterFlowModel<LogoutButtonWidget> {
  ///  State fields for stateful widgets in this component.

  // State field for logout process
  bool isLoggingOut = false;
  
  // State field for confirmation dialog
  bool showingConfirmDialog = false;
  
  // State field for logout result
  Map<String, dynamic>? logoutResult;

  @override
  void initState(BuildContext context) {
    // Initialize any required state
  }

  @override
  void dispose() {
    // Clean up any resources
  }

  /// Updates the logout state
  void updateLogoutState(bool isLoggingOut) {
    this.isLoggingOut = isLoggingOut;
  }

  /// Updates the confirmation dialog state
  void updateConfirmDialogState(bool showing) {
    this.showingConfirmDialog = showing;
  }

  /// Sets the logout result
  void setLogoutResult(Map<String, dynamic> result) {
    this.logoutResult = result;
  }

  /// Clears the logout result
  void clearLogoutResult() {
    this.logoutResult = null;
  }

  /// Checks if logout was successful
  bool get wasLogoutSuccessful => 
      logoutResult != null && logoutResult!['sucesso'] == true;

  /// Gets the logout error message if any
  String? get logoutErrorMessage => 
      logoutResult != null && logoutResult!['sucesso'] != true 
          ? logoutResult!['erro'] 
          : null;
}