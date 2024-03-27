import 'package:educarte/Interector/base/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Input extends StatefulWidget {
  const Input({
    super.key,
    required this.name,
    required this.obscureText,
    required this.onChange,
  });
  final String name;
  final bool obscureText;
  final TextEditingController onChange;


  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth(context),
      height: 55,
      child: TextFormField(
        obscureText: widget.obscureText,
        cursorColor: const Color(0xff547B9A),
        controller: widget.onChange,
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: const Color(0xff474C51)
        ),
        onTap: (){

        },
        decoration: InputDecoration(
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
