import 'package:educarte/core/base/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/enum/button_type.dart';

class CustomButton extends StatelessWidget {
  final bool loading;
  final VoidCallback? onPressed;
  final String title;
  final ButtonType buttonType;

  const CustomButton({
    super.key,
    this.loading = false,
    this.onPressed,
    required this.title,
    this.buttonType = ButtonType.primary
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = buttonType == ButtonType.primary ? colorScheme(context).onSurfaceVariant : colorScheme(context).primary;

    return GestureDetector(
      onTap: loading ? null : onPressed,
      onDoubleTap: null,
      child: Container(
        height: 44,
        width: screenWidth(context),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonType == ButtonType.primary ? colorScheme(context).primary : colorScheme(context).onSurfaceVariant, 
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: buttonType == ButtonType.secondary ? colorScheme(context).primary : Colors.transparent, 
            width: 1
          )
        ),
        child: loading ? CircularProgressIndicator(
          color: backgroundColor
        ) : Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: backgroundColor
          )
        )
      )
    );
  }
}