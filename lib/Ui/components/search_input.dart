import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../Interector/base/constants.dart';

class CustomSearchInput extends StatefulWidget {
  const CustomSearchInput({
    super.key,
    this.label = "Pesquise por nome",
    required this.controller, 
    required this.action
  });
  final String label;
  final TextEditingController controller;
  final Function action;

  @override
  State<CustomSearchInput> createState() => _CustomSearchInputState();
}

class _CustomSearchInputState extends State<CustomSearchInput> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.circular(4);
    OutlineInputBorder border ({Color borderColor = Colors.transparent}) => OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: borderColor
      )
    );

    return TextFormField(
      controller: widget.controller,
      onChanged: (String value) => widget.action(),
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        filled: true,
        suffixIcon: GestureDetector(
          onTap: () => context.push("/searchByVoice", extra: {"controller": widget.controller}),
          child: Icon(
            Symbols.keyboard_voice,
            size: 24,
            color: colorScheme(context).surface,
          ),
        ),
        enabledBorder: border(borderColor: colorScheme(context).outline),
        focusedBorder: border(borderColor: colorScheme(context).outline),
        border: border(borderColor: colorScheme(context).outline),
        label: Text(
          widget.label,
          style: textTheme(context).bodyLarge!.copyWith(
            color: colorScheme(context).surface,
            fontWeight: FontWeight.w400
          ),
        ),
      ),
    );
  }
}