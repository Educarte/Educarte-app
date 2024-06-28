import 'package:educarte/Interector/base/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Interector/enum/input_type.dart';
import '../../Interector/masks/date_mask.dart';
import '../../Interector/masks/hour_mask.dart';

class Input extends StatefulWidget {
  const Input({
    super.key,
    required this.name,
    required this.obscureText,
    required this.onChange,
    this.isInputModal = false, 
    this.inputType = InputType.text,
    this.enabled = true
  });
  final String name;
  final bool obscureText;
  final TextEditingController onChange;
  final bool isInputModal;
  final bool enabled;
  final InputType inputType;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
          color: Color(widget.isInputModal ? 0xff474C51 : 0xffA0A4A8)
      )
    );

    return SizedBox(
      width: screenWidth(context),
      height: 55,
      child: TextFormField(
        enabled: widget.enabled,
        inputFormatters: [
          if(widget.inputType == InputType.date) DateMask(),
          if(widget.inputType == InputType.date) LengthLimitingTextInputFormatter(10),

          if(widget.inputType == InputType.hour) HourMask(),
          if(widget.inputType == InputType.hour) LengthLimitingTextInputFormatter(5)
        ],
        obscureText: widget.obscureText,
        cursorColor: const Color(0xff547B9A),
        controller: widget.onChange,
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: const Color(0xff474C51)
        ),
        decoration: InputDecoration(
            labelText: widget.name,
            labelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: const Color(0xff474C51)
            ),
            border: const OutlineInputBorder(),
            focusedBorder: border,
            disabledBorder: border,
            enabledBorder: border
        ),
      ),
    );
  }
}
