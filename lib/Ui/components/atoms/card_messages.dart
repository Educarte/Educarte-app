import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/base/constants.dart';

class CardMessages extends StatefulWidget {
  final String assets;
  final String title;
  final Color color;

  const CardMessages({
    super.key,
    required this.title,
    required this.assets,
    required this.color
  });

  @override
  State<CardMessages> createState() => _CardMessagesState();
}

class _CardMessagesState extends State<CardMessages> {
  Radius get radius => const Radius.circular(8);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context),
      height: 120,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.only(
          topLeft: radius,
          topRight: radius
        )
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              "assets/${widget.assets}.png"
            )
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Para:",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w200,
                      fontSize: 20,
                      color: colorScheme(context).onPrimary
                    )
                  ),
                  SizedBox(
                    width: 175,
                    child: Text(
                      widget.title,
                      style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: colorScheme(context).onPrimary,
                      )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

