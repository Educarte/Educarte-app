import 'package:educarte/Interector/base/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BotaoBranco extends StatefulWidget {
  const BotaoBranco({
    super.key,
    required this.text,
    this.onPressed
  });
  final String text;
  final VoidCallback? onPressed;

  @override
  State<BotaoBranco> createState() => _BotaoBrancoState();
}

class _BotaoBrancoState extends State<BotaoBranco> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: screenWidth(context),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith((states) => colorScheme(context).onPrimary),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: colorScheme(context).primary)
              )
          ),
        ),
        child: Text(widget.text,style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colorScheme(context).primary
        ),),
      ),
    );
  }
}
