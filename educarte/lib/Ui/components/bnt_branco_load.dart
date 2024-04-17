import 'package:educarte/Interector/base/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BotaoBrancoLoad extends StatefulWidget {
  const BotaoBrancoLoad({
    super.key,
    required this.text,
    this.onPressed
  });
  final String text;
  final VoidCallback? onPressed;

  @override
  State<BotaoBrancoLoad> createState() => _BotaoBrancoState();
}

class _BotaoBrancoState extends State<BotaoBrancoLoad> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: screenWidth(context),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith((states) => colorScheme(context).onBackground),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: colorScheme(context).primary)
              )
          ),
        ),
        child: CircularProgressIndicator(
          color: colorScheme(context).onPrimary,
        )
      ),
    );
  }
}
