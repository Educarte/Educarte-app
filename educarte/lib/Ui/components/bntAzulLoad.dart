import 'package:educarte/Interector/base/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BotaoAzulLoad extends StatefulWidget {
  BotaoAzulLoad({super.key});
  @override
  State<BotaoAzulLoad> createState() => _BotaoAzulState();
}

class _BotaoAzulState extends State<BotaoAzulLoad> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: screenWidth(context),
      child: ElevatedButton(
        onPressed: (){},
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith((states) => colorScheme(context).primary),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
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
