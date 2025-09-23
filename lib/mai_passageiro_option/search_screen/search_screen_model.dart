import '/flutter_flow/flutter_flow_util.dart';
import 'search_screen_widget.dart' show SearchScreenWidget;
import 'package:flutter/material.dart';

class SearchScreenModel extends FlutterFlowModel<SearchScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  // Autocomplete state
  List<dynamic> predictions = [];
  String? selectedPlaceId;

  // Location state
  bool isGettingLocation = false;

  // Loading states
  bool isLoadingPlaceDetails = false;
  String? loadingPlaceId;
  bool isLoadingAutocomplete = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
