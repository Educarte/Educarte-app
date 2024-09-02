import 'package:flutter/material.dart';

import '../../../core/base/constants.dart';

class CustomAppBar extends PreferredSize {
  CustomAppBar({super.key, 
    required BuildContext context,
    required VoidCallback action,
    double paddingLeft = 12,
    required String title
  }) : super(
    child: ClipRRect(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme(context).primary,
          toolbarHeight: 60,
          title: Text(
            title,
            style: textTheme(context).titleLarge!.copyWith(
              color: colorScheme(context).surface,
              fontWeight: FontWeight.bold
            )
          ),
          centerTitle: false,
          leadingWidth: screenWidth(context),
          leading: Padding(
            padding: EdgeInsets.only(left: paddingLeft),
            child: Row(
              children: [
                GestureDetector(
                  onTap: action,
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 24,
                    color: colorScheme(context).surface
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: textTheme(context).titleLarge!.copyWith(
                    color: colorScheme(context).onPrimary,
                    fontWeight: FontWeight.bold
                  )
                )
              ],
            ),
          ),
        ), 
      ),
    ),
    preferredSize: const Size.fromHeight(60),
  );
}