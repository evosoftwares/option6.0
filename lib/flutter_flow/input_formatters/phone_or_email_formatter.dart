import 'package:flutter/services.dart';

/// Formata números digitados como telefone brasileiro enquanto permite e-mails.
/// - Para 10 dígitos: (XX) XXXX-XXXX
/// - Para 11 dígitos: (XX) XXXXX-XXXX
class PhoneOrEmailFormatter extends TextInputFormatter {
  String _applyMask(String digits) {
    if (digits.length <= 10) {
      final padded = digits.padRight(10);
      final d = digits.length;
      final area = d >= 2 ? '(${digits.substring(0, 2)}) ' : '(${padded.substring(0, 2)}) ';
      final midEnd = d > 6 ? 6 : d;
      final mid = d > 2 ? digits.substring(2, midEnd) : '';
      final end = d > 6 ? digits.substring(6, d) : '';
      return '$area$mid${mid.isNotEmpty && end.isNotEmpty ? '-' : ''}$end';
    } else {
      final d = digits.length > 11 ? digits.substring(0, 11) : digits;
      final area = '(${d.substring(0, 2)}) ';
      final mid = d.substring(2, 7);
      final end = d.substring(7, d.length);
      return '$area$mid-$end';
    }
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final digitsOnly = text.replaceAll(RegExp(r'[^0-9]'), '');

    // Se contém caracteres não numéricos além de máscara, não formata (provável e-mail)
    final looksLikeEmail = RegExp(r'[^0-9() \-]').hasMatch(text);
    if (looksLikeEmail || digitsOnly.isEmpty) {
      return newValue;
    }

    final masked = _applyMask(digitsOnly);
    return TextEditingValue(
      text: masked,
      selection: TextSelection.collapsed(offset: masked.length),
      composing: TextRange.empty,
    );
  }
}