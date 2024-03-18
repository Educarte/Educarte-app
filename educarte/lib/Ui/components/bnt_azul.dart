import 'package:educarte/Interector/base/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BotaoAzul extends StatefulWidget {
  const BotaoAzul({
    super.key,
    required this.text,
    this.onPressed, 
    this.loading = false
  });
  final String text;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  State<BotaoAzul> createState() => _BotaoAzulState();
}

class _BotaoAzulState extends State<BotaoAzul> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: screenWidth(context),
      child: ElevatedButton(
        onPressed: widget.loading ? null : widget.onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith((states) => colorScheme(context).primary),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )
          ),
        ),
        child: widget.loading ? const CircularProgressIndicator() : Text(
            widget.text,style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colorScheme(context).onPrimary
          )
        )
      ),
    );
  }
}
