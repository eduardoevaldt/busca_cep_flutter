import 'package:flutter/services.dart';

class TextInputFormatterCep extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String numeroCep = newValue.text.replaceAll(RegExp(r'\D'), "");

    if (numeroCep.length > 5) {
      String start = numeroCep.substring(0, 5);
      String end = numeroCep.substring(
        5,
        numeroCep.length <= 8 ? numeroCep.length : 8,
      );

      return newValue.copyWith(
        text: "$start-$end",
        selection: TextSelection.collapsed(
          offset: numeroCep.length <= 8 ? numeroCep.length + 1 : 9,
        ),
      );
    }

    return newValue;
  }
}
