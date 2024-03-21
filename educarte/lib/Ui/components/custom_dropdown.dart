import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key, 
    required this.list, 
    this.callback, 
    required this.selected
  });
  final List<String> list;
  final String selected;
  final Function(String result)? callback;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selected,
      icon: const Icon(Symbols.expand_more),
      elevation: 16,
      style: GoogleFonts.poppins(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: const Color(0xff474C51),
        height: 1.3
      ),
      decoration: InputDecoration(
          // labelText: selected,
          // labelStyle: GoogleFonts.poppins(
          //     fontWeight: FontWeight.w400,
          //     fontSize: 16,
          //     color: const Color(0xff474C51),
          //     height: 1.3
          // ),
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
      onChanged: (String? value) => callback!(value!),
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}