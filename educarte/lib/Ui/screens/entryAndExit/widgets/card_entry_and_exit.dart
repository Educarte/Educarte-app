import 'package:educarte/Interector/base/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class CardEntryAndExit extends StatelessWidget {
  String date;
  String horaEntrada;
  String? horaSaida;
  CardEntryAndExit({super.key,required this.horaEntrada, this.horaSaida,required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context),
      height: 127,
      margin: EdgeInsets.only(bottom: 20,left: 8,right: 8),
      decoration: BoxDecoration(
        color: colorScheme(context).background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: Offset(0, 4)
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
                    TextSpan(text: horaEntrada,style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w400,color: colorScheme(context).surface)),
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
                    TextSpan(text: horaSaida,style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w400,color: colorScheme(context).surface)),
                  ]
              ),
            ),
            const SizedBox(height: 6,),
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(text: "Resumo diário: ",style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w600,color: colorScheme(context).surface)),
                    TextSpan(text: "00h. 00Min",style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w400,color: colorScheme(context).surface)),
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
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}