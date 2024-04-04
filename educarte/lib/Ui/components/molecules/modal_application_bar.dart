import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../Interector/base/constants.dart';

class ModalApplicationBar extends StatelessWidget {
  const ModalApplicationBar({
    super.key, 
    required this.title
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Symbols.close,
          color: colorScheme(context).surface)
        ),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: colorScheme(context).surface
          )
        )
      ],
    );
  }
}