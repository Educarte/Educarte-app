import 'package:educarte/core/base/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

class CardEntryAndExit extends StatelessWidget {
  const CardEntryAndExit({
    super.key,
    required this.horaEntrada, 
    this.horaSaida,
    this.resumoDiario,
    required this.date
  });
  final String date;
  final String horaEntrada;
  final String? horaSaida;
  final String? resumoDiario;
  String dateConverte(String dateEntrada ,String dateSaida){
    DateTime dateTime = DateTime.parse(dateEntrada);
    DateTime dateTime2 = DateTime.parse(dateSaida);


    String formattedDate1 = DateFormat('HH', 'pt_BR').format(dateTime);
    String formattedTime1 = DateFormat('mm', 'pt_BR').format(dateTime);
    String formattedDate2 = DateFormat('HH', 'pt_BR').format(dateTime2);
    String formattedTime2 = DateFormat('mm', 'pt_BR').format(dateTime2);


    // Concatenando a data formatada
    String result = '${int.parse(formattedDate2) -  int.parse(formattedDate1)}h. ${int.parse(formattedTime2) -  int.parse(formattedTime1)} Min';

    // Output
    return result; // Saída: 18h. 08 Min

  }

  String dateConverteData(String date){
    DateTime dateTime = DateTime.parse(date);


    String formattedDate = DateFormat('HH', 'pt_BR').format(dateTime);
    String formattedTime = DateFormat('mm', 'pt_BR').format(dateTime);

    // Concatenando a data formatada
    String result = '${formattedDate}h. ${formattedTime}min';

    // Output
    return result; // Saída: 18h. 08 Min

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context),
      height: 127,
      margin: const EdgeInsets.only(bottom: 20,left: 8,right: 8),
      decoration: BoxDecoration(
        color: colorScheme(context).background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4)
          ),
        ],borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Symbols.more_time,color: colorScheme(context).outline,size: 18,),
                const SizedBox(width: 12,),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: date,style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w300,color: colorScheme(context).surface)),
                      // TextSpan(text: "Janeiro ",style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w700,color: colorScheme(context).surface)),
                      // TextSpan(text: "de 2024",style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w300,color: colorScheme(context).surface)),
                      //
                    ]
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: MySeparator(color: colorScheme(context).outline,),
            ),
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(text: "Entrada: ",style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w600,color: colorScheme(context).surface)),
                    TextSpan(text: dateConverteData(horaEntrada),style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w400,color: colorScheme(context).surface)),
                  ]
              ),
            ),
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(text: "Saida: ",style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w600,color: colorScheme(context).surface)),
                    if(horaSaida == null)
                    TextSpan(text: "00h. 00Min",style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w400,color: colorScheme(context).surface)),
                    if(horaSaida != null)
                    TextSpan(text: dateConverteData(horaSaida!),style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w400,color: colorScheme(context).surface)),
                  ]
              ),
            ),
            const SizedBox(height: 6,),
            if(horaSaida != null)
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(text: "Resumo diário: ",style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w600,color: colorScheme(context).surface)),
                    TextSpan(text: "${resumoDiario!.substring(0,2)}h. ${resumoDiario!.substring(3,5)}Min",style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w400,color: colorScheme(context).surface)),
                  ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 3.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}