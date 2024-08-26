import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    super.key, 
    required this.list, 
    this.callback, 
    required this.selected
  });
  final List<dynamic> list;
  final dynamic selected;
  final Function(dynamic result)? callback;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  void initState() {
    if(widget.list.isNotEmpty && widget.list.first.id != widget.selected.id){
      int deleteIndex = widget.list.indexWhere((element) => element.id == widget.selected.id);

      widget.list.removeAt(deleteIndex);
      widget.list.insert(0, widget.selected);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(
          color: Color(0xffA0A4A8)
      )
    );

    return widget.list.isEmpty ? const SizedBox() : DropdownButtonFormField<dynamic>(
      value: widget.list.first,
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
          focusedBorder: border,
          enabledBorder: border
      ),
      onChanged: (dynamic value) => widget.callback!(value!),
      items: widget.list.map<DropdownMenuItem<dynamic>>((dynamic value) {
        return DropdownMenuItem<dynamic>(
          value: value,
          child: Text(
            value.name ?? "Selecione uma Sala"
          ),
        );
      }).toList(),
    );
  }
}