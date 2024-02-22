import 'package:educarte/Interector/base/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class InputPassword extends StatefulWidget {
  InputPassword({super.key,required this.onChange,required this.name});
  TextEditingController onChange;
  String name;

  @override
  State<InputPassword> createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  bool verSenha = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth(context),
      height: 55,
      child: TextFormField(
        obscureText: verSenha,
        cursorColor: const Color(0xff547B9A),
        controller: widget.onChange,
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: const Color(0xff474C51)
        ),
        decoration: InputDecoration(
            suffixIcon: IconButton(onPressed: (){
              setState(() {
                verSenha = !verSenha;
              });
            } ,
                icon: verSenha ? const Icon(Symbols.visibility, color: Color(0xff474C51)) : const Icon(Symbols.visibility_off, color: Color(0xff474C51))),
            labelText: widget.name,
            labelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: const Color(0xff474C51)
            ),
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(
                    color: Color(0xffA0A4A8)
                )
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(
                    color: Color(0xffA0A4A8)
                )
            )
        ),
      ),
    );
  }
}
