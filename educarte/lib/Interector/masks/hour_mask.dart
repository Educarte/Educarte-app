import 'package:flutter/services.dart';

class HourMask extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    int selectionIndex;

    String pText = oldValue.text;
    String cText = newValue.text;
    int cLen = cText.length;
    int pLen = pText.length;

    if (cLen == 1 && int.parse(cText) > 2) {
      cText = '';
    } else if (cLen == 2 && pLen <= 2) {
      int hour = int.parse(cText);
      if (hour > 23) {
        cText = cText.substring(0, 1);
      } else {
        cText += ':';
      }
    } else if (cLen == 3 && cText.substring(2) != ':') {
      cText = '${cText.substring(0, 2)}:${cText.substring(2)}';
    } else if (cLen == 4 && pLen <= 4) {
      int minute = int.parse(cText.substring(3));
      if (minute >= 6) {
        cText = cText.substring(0, 3);
      }
    }

    selectionIndex = cText.length;
    return TextEditingValue(
      text: cText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}