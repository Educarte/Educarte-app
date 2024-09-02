import 'package:educarte/Interactor/models/document.dart';
import 'package:educarte/Ui/components/organisms/modal.dart';
import 'package:educarte/core/base/constants.dart';
import 'package:educarte/core/enum/modal_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../Interactor/providers/student_provider.dart';
import '../../../Ui/components/atoms/card_messages.dart';
import '../../../Ui/components/atoms/custom_pop_scope.dart';
import '../../../Ui/components/atoms/custom_table_calendar.dart';
import '../../components/atoms/result_not_found.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key, this.idStudent});
  final String? idStudent;
  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final studentProvider = GetIt.instance.get<StudentProvider>();
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      studentProvider.getDiarys(
        context: context,
        startDate: today, 
        endDate: today,
        initial: true
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w400
    );

    if (studentProvider.initialLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return CustomPopScope(
        child: Scaffold(
          body: SafeArea(
            child: Container(
              width: screenWidth(context),
              height: screenHeight(context),
              color: colorScheme(context).surface,
              alignment: Alignment.center,
              child: Column(
                children: [
                  CustomTableCalendar(
                    paddingTop: 16,
                    callback: (DateTime? startDate, DateTime? endDate) {
                      if (endDate != null) {
                        if (startDate != null && startDate.isAfter(endDate)) {
                          DateTime temp = startDate;
                          startDate = endDate;
                          endDate = temp;
                        }
                      }
                      
                      studentProvider.getDiarys(
                        context: context,
                        startDate: startDate!, 
                        endDate: endDate
                      );
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ListenableBuilder(
                    listenable: studentProvider, 
                    builder: (_, __){
                      if(studentProvider.loading){
                        return const Expanded(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      return Expanded(
                        child: studentProvider.listDiaries.isEmpty ? const ResultNotFound(
                          description: "O dia passou tranquilo por aqui, sem recados. Mas agradecemos por lembrar de nós!",
                          iconData: Symbols.diagnosis)
                        : ListView.builder(
                          padding: const EdgeInsets.only(top: 10, right: 8, left: 8),
                          shrinkWrap: true,
                          itemCount: studentProvider.listDiaries.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: screenWidth(context),
                              margin: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: colorScheme(context).onPrimary,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: const Offset(0, 4)
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  CardMessages(
                                    title: studentProvider.messageRecipient(
                                      diary: studentProvider.listDiaries[index]
                                    ),
                                    color: colorScheme(context).primary,
                                    assets: switch(studentProvider.listDiaries[index].diaryType){
                                      0 => "imgRecados3",
                                      1 =>  "imgRecados2",
                                      _ => "imgRecados1"
                                    }
                                  ),
                                  Container(
                                    width: screenWidth(context),
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            studentProvider.listDiaries[index].name.toString(),
                                            textAlign: TextAlign.start,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: textStyle.copyWith(
                                              fontWeight: FontWeight.w600
                                            )
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 16,
                                              bottom: 8
                                            ),
                                            child: Text(
                                              studentProvider.listDiaries[index].description.toString(),
                                              textAlign: TextAlign.start,
                                              style: textStyle
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Atenciosamente,",
                                                    style: textStyle
                                                  ),
                                                  Text(
                                                    "A Direção",
                                                    style: textStyle
                                                  ),
                                                ],
                                              ),
                                              if (studentProvider.listDiaries[index].fileUri != "null")...[
                                                GestureDetector(
                                                  onTap: () {
                                                    
                                                    ModalEvent.build(
                                                      context: context,
                                                      modalType: ModalType.archive,
                                                      document: Document(
                                                        id: studentProvider.listDiaries[index].id,
                                                        name: studentProvider.listDiaries[index].name,
                                                        fileUri: studentProvider.listDiaries[index].fileUri
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 36,
                                                    height: 36,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: colorScheme(context).secondary,
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Symbols.attach_file,
                                                      color: colorScheme(context).onInverseSurface,
                                                      size: 20,
                                                    ),
                                                  ),
                                                )
                                              ]
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
