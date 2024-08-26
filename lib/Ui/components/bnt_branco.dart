import 'package:educarte/core/base/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BotaoBranco extends StatefulWidget {
  const BotaoBranco({
    super.key,
    required this.text,
    this.onPressed,
     this.loading = false
  });
  final bool loading ;
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
        onPressed: widget.loading ? null : widget.onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateColor.resolveWith((states) => colorScheme(context).onSurfaceVariant),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: colorScheme(context).primary)
              )
          ),
        ),
        child: widget.loading ? const CircularProgressIndicator() :
        Text(widget.text,style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colorScheme(context).primary
        ),),
      ),
    );
  }
}
