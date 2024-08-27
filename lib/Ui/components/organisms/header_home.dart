import 'package:educarte/Interactor/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/base/constants.dart';
import '../../../core/enum/modal_type_enum.dart';
import 'modal.dart';

class HeaderHome extends StatelessWidget {
  final UserProvider userProvider;
  const HeaderHome({
    super.key,
    required this.userProvider
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: userProvider,
      builder: (_, __) {
        return Expanded(
          flex: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Olá,", 
                    style: GoogleFonts.poppins(
                      color: colorScheme(context).onInverseSurface,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    )
                  ),
                  Text(
                    userProvider.currentLegalGuardian.name!.split(" ").first,
                    style: GoogleFonts.poppins(
                      color: colorScheme(context).primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 25,
                    )
                  ),
                ],
              ),
              IconButton(
                onPressed: () => ModalEvent.build(
                  context: context,
                  modalType: ModalType.myData
                ),
                icon: const Icon(
                  Symbols.account_circle,
                  size: 30
                )
              )
            ],
          ),
        );
      }
    );
  }
}