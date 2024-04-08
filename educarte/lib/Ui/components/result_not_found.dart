import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Interector/base/constants.dart';

class ResultNotFound extends StatelessWidget {
  final String description;
  final IconData iconData;
  const ResultNotFound({
    super.key, 
    required this.description, 
    required this.iconData
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData, 
            size: 40
          ),
          const SizedBox(height: 12),
          Text(
           description,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: colorScheme(context).onSurface
            ), 
            textAlign: TextAlign.center
          ),
        ],
      ),
    );
  }
}