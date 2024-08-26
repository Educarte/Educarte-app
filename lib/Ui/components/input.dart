import 'package:educarte/core/base/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/enum/input_type.dart';
import '../../Interactor/masks/date_mask.dart';
import '../../Interactor/masks/hour_mask.dart';

class Input extends StatefulWidget {
  const Input({
    super.key,
    required this.name,
    this.obscureText = false,
    required this.onChange,
    this.isInputModal = false, 
    this.inputType = InputType.text,
    this.suffixIcon,
    this.enabled = true,
    this. readOnly = false
  });
  final String name;
  final bool obscureText;
  final TextEditingController onChange;
  final bool isInputModal;
  final bool enabled;
  final InputType inputType;
  final Widget? suffixIcon;
  final bool readOnly;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  ValueNotifier showPassword = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    Color fillColor = widget.readOnly ? colorScheme(context).outline.withOpacity(0.5) : Colors.transparent;
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
          color: Color(widget.isInputModal ? 0xff474C51 : 0xffA0A4A8)
      )
    );

    return ValueListenableBuilder(
      valueListenable: showPassword,
      builder: (_, __, ___) {
        bool isPassword = widget.inputType == InputType.password;

        return SizedBox(
          width: screenWidth(context),
          height: 55,
          child: TextFormField(
            readOnly: widget.readOnly,
            enabled: widget.readOnly ? false : widget.enabled,
            inputFormatters: [
              if(widget.inputType == InputType.date) DateMask(),
              if(widget.inputType == InputType.date) LengthLimitingTextInputFormatter(10),
        
              if(widget.inputType == InputType.hour) HourMask(),
              if(widget.inputType == InputType.hour) LengthLimitingTextInputFormatter(5)
            ],
            obscureText: isPassword ? showPassword.value : false,
            cursorColor: const Color(0xff547B9A),
            controller: widget.onChange,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: const Color(0xff474C51)
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: fillColor,
              suffixIcon: !isPassword ? widget.suffixIcon : IconButton(
                onPressed: () => showPassword.value = !showPassword.value,
                icon: Icon(
                  !showPassword.value ? Icons.remove_red_eye_outlined : Icons.remove_red_eye,
                  color: colorScheme(context).outline
                ),
              ),
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
    );
  }
}
