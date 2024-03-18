import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../Interector/base/constants.dart';

class CustomSearchInput extends StatefulWidget {
  const CustomSearchInput({
    super.key,
    this.label = "Pesquise por palavras",
    required this.controller, 
    required this.action
  });
  final String label;
  final TextEditingController controller;
  final VoidCallback action;

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
    BorderRadius borderRadius = BorderRadius.circular(8);
    OutlineInputBorder border ({Color borderColor = Colors.transparent}) => OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: borderColor
      )
    );

    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius
      ),
      child: Container(
        decoration: BoxDecoration(
          boxShadow:  [
            BoxShadow(
              color: themeProvider.shadow(context),
              blurRadius: 13
            )
          ]
        ),
        child: TextField(
          controller: widget.controller,
          onSubmitted: (String value) => widget.action(),
          onChanged: (String value) => widget.action(),
          decoration: InputDecoration(
            fillColor: colorScheme(context).background,
            filled: true,
            prefixIcon: InkWell(
              splashFactory: NoSplash.splashFactory,
              onTap: () => context.push("/match/searchByVoicePage", extra: {
                "controller": widget.controller, 
                "context": context,
                "searchVoiceInputType": widget.searchVoiceInputType
              }),
              child: InkWell(
                child: Icon(
                  Symbols.keyboard_voice,
                  size: 24,
                  color: colorScheme(context).outline,
                ),
              ),
            ),
            suffixIcon: GestureDetector(
              onTap: () => widget.action(),
              child: Icon(
                Symbols.search,
                size: 24,
                color: colorScheme(context).outline,
              ),
            ),
            suffixIconColor: colorScheme(context).outline,
            enabledBorder: border(),
            focusedBorder: border(),
            border: border(),
            label: Text(
              widget.label,
              style: const TextStyle(
                // color: primaryColor,
                fontWeight: FontWeight.normal
              ),
            ),
          ),
        ),
      ),
    );
  }
}