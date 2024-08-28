import 'package:educarte/Interactor/providers/student_provider.dart';
import 'package:educarte/core/base/constants.dart';
import 'package:educarte/Interactor/models/entry_and_exit_modal.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../Ui/components/atoms/custom_pop_scope.dart';
import '../../../Ui/components/atoms/custom_table_calendar.dart';
import '../../../Ui/screens/entry_and_exit/widgets/card_entry_and_exit.dart';
import '../../components/atoms/result_not_found.dart';

class EntryAndExitPage extends StatefulWidget {
  const EntryAndExitPage({super.key});

  @override
  State<EntryAndExitPage> createState() => _EntryAndExitPageState();
}

enum Loadings { none, list }

class _EntryAndExitPageState extends State<EntryAndExitPage> {
  final studentProvider = GetIt.instance.get<StudentProvider>();

  List<EntryAndExit> listAccess = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      studentProvider.getAccessControls(
        context: context,
        startDate: DateTime.now(),
        endDate: DateTime.now()
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      child: ListenableBuilder(
        listenable: studentProvider,
        builder: (_, __) {
          return Scaffold(
            body: Container(
              width: screenWidth(context),
              height: screenHeight(context),
              color: colorScheme(context).surface,
              alignment: Alignment.center,
              child: SafeArea(
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
          
                        studentProvider.getAccessControls(
                          context: context,
                          startDate: startDate!,
                          endDate: endDate
                        );
                      }),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      height: 38,
                      color: colorScheme(context).primary.withOpacity(0.5),
                      child: listAccess.isEmpty
                          ? Text(
                              "Saldo de horas: +00h. 00Min",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme(context).onPrimary),
                            )
                          : Text(
                              "Saldo de horas: +${studentProvider.summary.substring(0, 2)}h. ${studentProvider.summary.substring(3, 5)}Min",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme(context).onPrimary),
                            ),
                    ),
                    if (studentProvider.loading )...[
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator()
                        )
                      )
                    ]else...[
                      Expanded(
                        child: listAccess.isEmpty
                          ? const ResultNotFound(
                              description:
                                  "Sem registro de entrada e saída desse aluno!",
                              iconData: Symbols.error)
                          : ListView.builder(
                        padding:const EdgeInsets.only(top: 10, left: 8, right: 8),
                        shrinkWrap: true,
                        itemCount: listAccess.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CardEntryAndExit(
                            date: DateFormat.yMMMMd('pt_BR').format(
                                DateTime.parse(
                                    listAccess[index].date.toString())),
                            horaEntrada: listAccess[index]
                                .accessControls![0]
                                .time
                                .toString(),
                            horaSaida:
                                listAccess[index].accessControls!.length == 2
                                    ? listAccess[index]
                                        .accessControls![1]
                                        .time
                                        .toString()
                                    : null,
                            resumoDiario: listAccess[index]
                                .dailySummary
                                ?.substring(0, 8),
                          );
                        },
                      ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
