import 'package:educarte/Interector/base/constants.dart';
import 'package:educarte/Interector/models/classroom_model.dart';
import 'package:educarte/Interector/models/legal_guardians_model.dart';
import 'package:educarte/Interector/models/students_model.dart';
import 'package:educarte/Ui/components/bnt_azul.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'dash_line.dart';

class CardTimeControl extends StatelessWidget {
  const CardTimeControl({
    super.key, 
    required this.student
  });
  final Student student;

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
                    student.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
              if(student.classrooms != null)
              InformationAboutTheStudents(
                title: "Sala",
                classroom: student.classrooms!.first,
                first: 0
              ),
              ListView.builder(
                padding: EdgeInsetsDirectional.zero,
                primary: false,
                shrinkWrap: true,
                itemCount: student.legalGuardians!.length, 
                itemBuilder: (_, index) {
                  return InformationAboutTheStudents(
                    legalGuardian: student.legalGuardians![index],
                    first: index == 0 ? 0 : 10,
                  );
                }
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
    this.title = "Representante Legal",
    this.first = 10, 
    this.legalGuardian, 
    this.classroom
  });
  final String title;
  final LegalGuardian? legalGuardian;
  final Classroom? classroom;
  final double first;

  @override
  Widget build(BuildContext context) {
    Color textColor = colorScheme(context).surface;
    String? description = legalGuardian != null ? legalGuardian!.name : classroom!.name ?? "";

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