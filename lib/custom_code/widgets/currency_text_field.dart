// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:currency_textfield/currency_textfield.dart';

class CurrencyTextField extends StatefulWidget {
  const CurrencyTextField({
    Key? key,
    this.width,
    this.height,
    this.currencySymbol = "R\$",
    this.initValue,
    this.hintText,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String currencySymbol;
  final double? initValue;
  final String? hintText;

  @override
  _CurrencyTextFieldState createState() => _CurrencyTextFieldState();
}

class _CurrencyTextFieldState extends State<CurrencyTextField> {
  late CurrencyTextFieldController _controller;

  @override
  void initState() {
    super.initState();

    _controller = CurrencyTextFieldController(
      currencySymbol: widget.currencySymbol,
      decimalSymbol: ",",
      thousandSymbol: ".",
      initDoubleValue: widget.initValue ?? 0.0,
      currencyOnLeft: true,
      enableNegative: false,
    );

    // Atualizar App State em tempo real
    _controller.addListener(() {
      FFAppState().update(() {
        FFAppState().currencyValue = _controller.doubleValue;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: TextField(
        controller: _controller,
        style: FlutterFlowTheme.of(context).bodyMedium,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          hintText: widget.hintText,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).alternate,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).alternate,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primary,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
