import 'package:educarte/Interactor/providers/menu_provider.dart';
import 'package:educarte/Ui/components/atoms/card_timer_or_menu.dart';
import 'package:educarte/Ui/components/organisms/header_home.dart';
import 'package:educarte/Ui/components/organisms/modal.dart';
import 'package:educarte/core/base/constants.dart';
import 'package:educarte/core/enum/card_home_type.dart';
import 'package:educarte/core/enum/modal_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../Interactor/providers/student_provider.dart';
import '../../../Interactor/providers/user_provider.dart';
import '../../../Ui/components/atoms/custom_pop_scope.dart';
import '../../../Ui/components/atoms/result_not_found.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final menuProvider = GetIt.instance.get<MenuProvider>();
  final userProvider = GetIt.instance.get<UserProvider>();
  final studentProvider = GetIt.instance.get<StudentProvider>();

  @override
  void initState() {
    super.initState();
    studentProvider.getStudents(
      context: context,
      legalGuardianId: userProvider.currentLegalGuardian.id!
    );
    menuProvider.getMenu(context: context);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle diaryStyle = GoogleFonts.poppins(
      fontSize: 14,
      color: colorScheme(context).onInverseSurface,
      fontWeight: FontWeight.w400
    );
    Radius radius = const Radius.circular(8);

    return CustomPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false ,
        backgroundColor: colorScheme(context).surface,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              HeaderHome(userProvider: userProvider),
              ListenableBuilder(
                listenable: studentProvider,
                builder: (_, __) {
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: screenWidth(context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: colorScheme(context).onSurfaceVariant,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(
                                    0, 4
                                  ),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: screenWidth(context),
                                  height: 103,
                                  decoration: BoxDecoration(
                                      color: colorScheme(context).primary,
                                      borderRadius: BorderRadius.only(
                                        topLeft: radius,
                                        topRight: radius
                                      )
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: SizedBox(
                                            height: 80,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment: MainAxisAlignment
                                                    .end,
                                                children: [
                                                  Text("Recados de",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w400,
                                                      color: const Color(0xffF5F5F5),
                                                    ),),
                                                  Text(
                                                    "HOJE", style: GoogleFonts.poppins(
                                                      fontSize: 71,
                                                      fontWeight: FontWeight.w800,
                                                      color: const Color(0xffF5F5F5),
                                                      height: 0.8
                                                  ),),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Image.asset("assets/imgRecados.png")
                                    ],
                                  ),
                                ),
                                if(studentProvider.currentStudent.listDiaries != null)...[
                                  Expanded(
                                    child: studentProvider.currentStudent.listDiaries!.isEmpty ? const ResultNotFound(
                                      description: "O dia passou tranquilo por aqui, sem recados. Mas agradecemos por lembrar de nós!",
                                      iconData: Symbols.diagnosis
                                    ) : Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: ListView.builder(
                                          padding: const EdgeInsets.only(top: 10),
                                          itemCount: studentProvider.currentStudent.listDiaries!.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Container(
                                              width: screenWidth(context),
                                              margin: const EdgeInsets.only(bottom: 12),
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                    color: colorScheme(context).outline.withOpacity(0.5)
                                                  )
                                                )
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Para: ",
                                                        style: diaryStyle.copyWith(
                                                          fontWeight: FontWeight.w500
                                                        )
                                                      ),
                                                      Text(
                                                        switch(studentProvider.currentStudent.listDiaries![index].diaryType){
                                                          0 => studentProvider.currentStudent.name!,
                                                          1 => "Nome da sala",
                                                          _ => "Escola"
                                                        },
                                                        style: diaryStyle
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    studentProvider.currentStudent.listDiaries![index].description!,
                                                    style: diaryStyle.copyWith(
                                                      fontWeight: FontWeight.w300
                                                    ),
                                                    maxLines: 3,
                                                    overflow: TextOverflow.ellipsis
                                                  ),
                                                  const SizedBox(height: 12)
                                                ],
                                              ),
                                            );
                                          },
                                    
                                        ),
                                      ),
                                    ),
                                  )
                                ]
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          flex: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CardTimerOrMenu(
                                studentProvider: studentProvider
                              ),
                              const SizedBox(width: 12),
                              CardTimerOrMenu(
                                studentProvider: studentProvider,
                                cardType: CardHomeType.menu,
                                action: () { 
                                  if(menuProvider.currentMenu.fileUri == null){
                                    menuProvider.showErrorMessage(context, "Cardápio nāo encontrado");
                                  }else{
                                    ModalEvent.build(
                                      context: context,
                                      document: menuProvider.currentMenu,
                                      modalType: ModalType.menu
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        )
                      ] 
                    ),
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}