import 'package:educarte/Interector/base/constants.dart';
import 'package:flutter/material.dart';

class CardEntryAndExit extends StatelessWidget {
  const CardEntryAndExit({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context),
      height: 120,
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme(context).background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: Offset(0, 4)
          ),
        ],borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}