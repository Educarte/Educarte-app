import 'dart:convert';

import 'package:educarte/Interector/base/constants.dart';
import 'package:educarte/Interector/models/entry_and_exit_modal.dart';
import 'package:educarte/Services/config/api_config.dart';
import 'package:educarte/Ui/components/table_calendar.dart';
import 'package:educarte/Ui/screens/entryAndExit/widgets/card_entry_and_exit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../components/result_not_found.dart';
import '../../global/global.dart';
import '../Messagens/messages_screen.dart';
import 'package:http/http.dart' as http;
import '../../global/global.dart' as globals;

class EntryAndExitPage extends StatefulWidget {
  const EntryAndExitPage({super.key});

  @override
  State<EntryAndExitPage> createState() => _EntryAndExitPageState();
}

enum Loadings {none,list}
class _EntryAndExitPageState extends State<EntryAndExitPage> {
  Loadings loading = Loadings.none;
  List<EntryAndExit> listAccess = [];

  void setLoading({required Loadings load}){
    setState(() {
      loading = load;
    });
  }

  Future<void> getAccessControls(DateTime startDate, DateTime? endDate)async{
    setLoading(load: Loadings.list);
    var params = {
      'Id': idStudent,
      "StartDate": DateFormat.yMd().format(startDate).toString(),
      "EndDate": endDate == null ? DateFormat.yMd().format(startDate).toString() : DateFormat.yMd().format(endDate).toString()
    };

    var response = await http.get(Uri.parse("$baseUrl/Students/AccessControls/${globals.idStudent}").replace(queryParameters: params),
      headers: {
        "Authorization": "Bearer ${globals.token}"
      },
    );
    print(response.statusCode);
    if(response.statusCode == 200){
      var decodeJson = jsonDecode(response.body);
      print(decodeJson["accessControlsByDate"]);
      print("${!decodeJson["accessControlsByDate"].isEmpty} asssdfadsfasdf");
      if(!decodeJson["accessControlsByDate"].isEmpty) {
        decodeJson.forEach((item) => listAccess.add(EntryAndExit.fromJson(item)));
      }else{
        print(loading);
        setLoading(load: Loadings.none);
      }
    }
    print(loading);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAccessControls(DateTime.now(),DateTime.now());
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomTableCalendar(
                      paddingTop: 24,
                      callback: (DateTime? startDate, DateTime? endDate) {
                        if (endDate != null) {
                          if (startDate != null && startDate.isAfter(endDate)) {
                            DateTime temp = startDate;
                            startDate = endDate;
                            endDate = temp;
                          }
                        }
                        getAccessControls(startDate!, endDate);
                      }
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 16),
                  height: 38,
                  color: colorScheme(context).primary.withOpacity(0.5),
                  child: Text(
                    "Saldo de horas: +00h. 00min ",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorScheme(context).onPrimary
                    ),
                  ),
                ),
                if(loading == Loadings.list)
                  const Expanded(
                    child: Center(
                        child: CircularProgressIndicator()),
                  )
                else
                  Expanded(
                    child:listAccess.isEmpty ? const ResultNotFound(
                        description: "O dia passou tranquilo por aqui, sem recados. Mas agradecemos por lembrar de nós!",
                        iconData: Symbols.diagnosis
                    ) :
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return CardEntryAndExit();
                        },
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      );
  }
}
