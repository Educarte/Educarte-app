import 'package:educarte/Interactor/providers/menu_provider.dart';
import 'package:educarte/Interactor/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/base/constants.dart';
import '../../../core/enum/modal_type_enum.dart';
import 'modal.dart';

class HeaderHome extends StatelessWidget {
  final UserProvider userProvider;
  final MenuProvider? menuProvider;
  final bool secondProfile;
  const HeaderHome({
    super.key,
    required this.userProvider,
    this.menuProvider,
    this.secondProfile = false
  });

  @override
  Widget build(BuildContext context) {
    dynamic user;
    if(secondProfile){
      user = userProvider.user;
    }else{
      user = userProvider.currentLegalGuardian;
    }
    double iconSize = 30;

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
                    user.name!.split(" ").first,
                    style: GoogleFonts.poppins(
                      color: colorScheme(context).primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 25,
                    )
                  ),
                ],
              ),
              Row(
                children: [
                  if(secondProfile)...[
                    GestureDetector(
                      onTap: () async{
                        await menuProvider!.getMenu(context: context);
                        

                        if(menuProvider!.currentMenu.id != null){
                          ModalEvent.build(
                            context: context,
                            modalType: ModalType.menu,
                            document: menuProvider!.currentMenu
                          );
                        }
                      },
                      child: Icon(
                        Symbols.nutrition,
                        size: iconSize
                      )
                    )
                  ],
                  IconButton(
                    onPressed: () => ModalEvent.build(
                      context: context,
                      modalType: ModalType.myData
                    ),
                    icon: Icon(
                      Symbols.account_circle,
                      size: iconSize
                    )
                  )
                ]
              )
            ],
          ),
        );
      }
    );
  }
}