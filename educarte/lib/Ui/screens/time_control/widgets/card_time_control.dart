import 'package:educarte/Interector/base/constants.dart';
import 'package:educarte/Ui/components/bnt_azul.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'dash_line.dart';

class CardTimeControl extends StatelessWidget {
  const CardTimeControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 0,
      child: Card(
        elevation: 1,
        color: colorScheme(context).onPrimary,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Symbols.child_care
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Nome do aluno exemplo",
                    style: textTheme(context).bodyLarge!.copyWith(
                      color: colorScheme(context).surface,
                      fontWeight: FontWeight.w600
                    )
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: DashedLine(),
              ),
              const InformationAboutTheStudents(
                title: "Sala",
                description: "Berçário I",
                first: 0
              ),
              const InformationAboutTheStudents(
                title: "Representante Legal",
                description: "Nome do represente Legal"
              ),
              const InformationAboutTheStudents(
                title: "Representante Legal",
                description: "Nome do represente Legal"
              ),
              const SizedBox(height: 10),
              const BotaoAzul(
                text: "Registrar horário"
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InformationAboutTheStudents extends StatelessWidget {
  const InformationAboutTheStudents({
    super.key,
    required this.title,
    required this.description,
    this.first = 10
  });
  final String title;
  final String description;
  final double first;

  @override
  Widget build(BuildContext context) {
    Color textColor = colorScheme(context).surface;

    return Expanded(
      flex: 0,
      child: Padding(
        padding:  EdgeInsets.only(top: first),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$title: ",
                style: textTheme(context).bodyLarge!.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600
                )
              ),
              TextSpan(
                text: description,
                style: textTheme(context).bodyLarge!.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w400
                )
              )
            ]
          )
        ),
      ),
    );
  }
}