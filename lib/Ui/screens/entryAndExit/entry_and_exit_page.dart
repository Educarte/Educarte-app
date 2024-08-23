import 'dart:convert';

import 'package:educarte/core/base/constants.dart';
import 'package:educarte/Interector/models/entry_and_exit_modal.dart';
import 'package:educarte/Services/config/api_config.dart';
import 'package:educarte/Ui/components/custom_table_calendar.dart';
import 'package:educarte/Ui/screens/entryAndExit/widgets/card_entry_and_exit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../components/result_not_found.dart';
import '../../global/global.dart';
import 'package:http/http.dart' as http;
import '../../global/global.dart' as globals;

class EntryAndExitPage extends StatefulWidget {
  const EntryAndExitPage({super.key});

  @override
  State<EntryAndExitPage> createState() => _EntryAndExitPageState();
}

enum Loadings { none, list }

class _EntryAndExitPageState extends State<EntryAndExitPage> {
  Loadings loading = Loadings.none;
  List<EntryAndExit> listAccess = [];
  String summary = "";

  void setLoading({required Loadings load}) {
    setState(() {
      loading = load;
    });
  }

  Future<void> getAccessControls(DateTime startDate, DateTime? endDate) async {
    setLoading(load: Loadings.list);
    setState(() {
      summary = "";
      listAccess = [];
    });
    var params = {
      'Id': currentStudent.value.id,
      "StartDate": DateFormat.yMd().format(startDate).toString(),
      "EndDate": endDate == null
          ? DateFormat.yMd().format(startDate).toString()
          : DateFormat.yMd().format(endDate).toString()
    };

    var response = await http.get(
      Uri.parse("$baseUrl/Students/AccessControls/${currentStudent.value.id}")
          .replace(queryParameters: params),
      headers: {"Authorization": "Bearer ${globals.token}"},
    );
    if (response.statusCode == 200) {
      var decodeJson = jsonDecode(response.body);
      if (!decodeJson["accessControlsByDate"].isEmpty) {
        decodeJson["accessControlsByDate"]
            .forEach((item) => listAccess.add(EntryAndExit.fromJson(item)));
        summary = decodeJson["summary"];
      }
    }
    setLoading(load: Loadings.none);
  }

  @override
  void initState() {
    super.initState();
    getAccessControls(DateTime.now(), DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: screenWidth(context),
        height: screenHeight(context),
        color: colorScheme(context).background,
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
                    getAccessControls(startDate!, endDate);
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
                        "Saldo de horas: +${summary.substring(0, 2)}h. ${summary.substring(3, 5)}Min",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: colorScheme(context).onPrimary),
                      ),
              ),
              if (loading == Loadings.list)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                Expanded(
                  child: listAccess.isEmpty
                      ? const ResultNotFound(
                          description:
                              "Sem registro de entrada e saída desse aluno!",
                          iconData: Symbols.error)
                      : ListView.builder(
                          padding:
                              const EdgeInsets.only(top: 10, left: 8, right: 8),
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
            ],
          ),
        ),
      ),
    );
  }
}
