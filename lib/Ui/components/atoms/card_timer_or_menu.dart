import 'package:educarte/Interactor/providers/student_provider.dart';
import 'package:educarte/Interactor/validations/intl_formatter.dart';
import 'package:educarte/core/enum/card_home_type.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/base/constants.dart';

class CardTimerOrMenu extends StatelessWidget {
  final VoidCallback? action;
  final StudentProvider studentProvider;
  final CardHomeType cardType;

  const CardTimerOrMenu({
    super.key, 
    required this.studentProvider,
    this.cardType = CardHomeType.timer,
    this.action
  });

  @override
  Widget build(BuildContext context) {
    double cardSize = 166;
    Radius radius = const Radius.circular(8);
    bool isMenu = cardType == CardHomeType.menu;
    double textMenuHeight = 1.2;

    return Expanded(
      child: GestureDetector(
        onTap: action,
        onDoubleTap: null,
        child: Container(
          height: cardSize,
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
                )
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: screenWidth(context),
                height: 74,
                decoration: BoxDecoration(
                  color: isMenu ? colorScheme(context).onSecondary : colorScheme(context).secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: radius,
                    topRight: radius
                  )
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        cardType.backgroundImage
                      )
                    ),
                    switch(cardType){
                      CardHomeType.timer => Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                cardType.firstTitle,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xffF5F5F5),
                                )
                              ),
                              Text(
                                cardType.secondaryTitle,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xffF5F5F5)
                                )
                              ),
                            ],
                          ),
                        ),
                      ),
                      CardHomeType.menu => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: screenWidth(context),
                            child: RichText(text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Atualização\ndo ",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,
                                        color: colorScheme(context).onPrimary
                                    ),
                                  ),
                                  TextSpan(
                                    text: "CARDÁPIO",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: colorScheme(context).onPrimary
                                    )
                                  )
                                ]
                              )
                            ),
                          ),
                        ),
                      )
                    }
                  ],
                ),
              ),
              SizedBox(
                width: screenWidth(context),
                height: 91,
                child: isMenu && !studentProvider.datesMenuIsValid ?
                  Center(
                    child: Text(
                      "Sem atualizações!",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: colorScheme(context).outline
                      ),
                    ),
                  )
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: switch(cardType) {
                      CardHomeType.timer => [
                        Row(
                          children: [
                            Text(
                              "Data: ", style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: colorScheme(context).onSurface
                              )
                            ),
                            if(studentProvider.currentStudent.horaEntrada != null)...[
                              Text(
                                DateFormat('yMd', 'pt_BR').format(
                                  DateTime.parse(studentProvider.currentStudent.horaEntrada!)
                                ) ,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: colorScheme(context).onSurface
                                )
                              )
                            ],
                            if(studentProvider.currentStudent.horaEntrada == null)...[
                              Text(
                                "00/00/00",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: colorScheme(context).onSurface
                                )
                              )
                            ]
                          ]
                        ),
                        Row(
                          children: [
                            Text(
                              "Entrada: ",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: colorScheme(context).onSurface
                              )
                            ),
                            if(studentProvider.currentStudent.horaEntrada != null)...[
                              Text(
                                IntlFormatter.formatTimeToHourMinutes(studentProvider.currentStudent.horaEntrada!),
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: colorScheme(context).onSurface
                                )
                              )
                            ],
                            if(studentProvider.currentStudent.horaEntrada == null)...[
                              Text("00h 00min",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: colorScheme(context).onSurface
                                )
                              )
                            ],
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Saída: ", style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: colorScheme(context).onSurface
                              )
                            ),
                            if(studentProvider.currentStudent.horaSaida == null)...[
                              Text(
                                "00h 00min",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: colorScheme(context)
                                        .onSurface
                                )
                              )
                            ],
                            if(studentProvider.currentStudent.horaSaida != null)...[
                              Text(
                                IntlFormatter.formatTimeToHourMinutes(studentProvider.currentStudent.horaSaida!),
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: colorScheme(context)
                                        .onSurface
                                )
                              )
                            ] 
                          ]
                        ),
                      ],
                      CardHomeType.menu => [
                        Text(
                          studentProvider.datesMenu.$1, 
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            color: colorScheme(context).onSurface,
                            height: textMenuHeight
                          )
                        ),
                        Text(
                          studentProvider.datesMenu.$2,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: colorScheme(context).onSurface,
                            height: textMenuHeight
                          )
                        ),
                        Text(
                          studentProvider.datesMenu.$3, 
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: colorScheme(context).onSurface
                          )
                        ),
                      ]
                    }
                  ),
                )
              )
            ],
          ),
        )
      ),
    );
  }
}