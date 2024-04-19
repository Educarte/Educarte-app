import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Interector/base/constants.dart';

class CardMessages extends StatefulWidget {
  const CardMessages({
    super.key,
    required this.encaminhado,
    required this.color,
    required this.assets
  });
  final String encaminhado;
  final String assets;
  final Color color;

  @override
  State<CardMessages> createState() => _CardMessagesState();
}

class _CardMessagesState extends State<CardMessages> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context),
      height: 120,
      decoration: BoxDecoration(
          color: widget.color,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8))
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
              widget.assets)
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Para:",style: GoogleFonts.poppins(
                      fontWeight: FontWeight
                          .w200,
                      fontSize: 20,
                      color: colorScheme(
                          context).onPrimary
                  ),),
                  SizedBox(
                    width: 175,
                    child: Text(widget.encaminhado,style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                      fontWeight: FontWeight
                          .w800,
                      fontSize: 20,
                      color: colorScheme(
                          context).onPrimary,
                    ),),
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
