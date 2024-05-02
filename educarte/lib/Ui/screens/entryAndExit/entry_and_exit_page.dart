import 'package:educarte/Interector/base/constants.dart';
import 'package:educarte/Ui/components/table_calendar.dart';
import 'package:educarte/Ui/screens/entryAndExit/widgets/card_entry_and_exit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Messagens/messages_screen.dart';

class EntryAndExitPage extends StatefulWidget {
  const EntryAndExitPage({super.key});

  @override
  State<EntryAndExitPage> createState() => _EntryAndExitPageState();
}

class _EntryAndExitPageState extends State<EntryAndExitPage> {
  Loadings loading = Loadings.none;

  void setLoading({required Loadings load}){
    setState(() {
      loading = load;
    });
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
                  callback:(start, end) {

                  }
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Container(
                  alignment: Alignment.center,
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
              ),
              if(loading == Loadings.list)
                const Expanded(
                  child: Center(
                      child: CircularProgressIndicator()),
                )
              else
              Expanded(
                child: Padding(
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
