import 'package:educarte/Interector/base/constants.dart';
import 'package:educarte/Ui/components/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EntryAndExitPage extends StatefulWidget {
  const EntryAndExitPage({super.key});

  @override
  State<EntryAndExitPage> createState() => _EntryAndExitPageState();
}

class _EntryAndExitPageState extends State<EntryAndExitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomTableCalendar(
              paddingTop: 24,
              callback:(start, end) {
                  
              }
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
            )
          ],
        ),
      ),
    );
  }
}