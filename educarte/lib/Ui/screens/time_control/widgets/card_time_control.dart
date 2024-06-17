import 'package:educarte/Interector/base/constants.dart';
import 'package:educarte/Interector/enum/modal_type_enum.dart';
import 'package:educarte/Interector/models/classroom_model.dart';
import 'package:educarte/Interector/models/legal_guardians_model.dart';
import 'package:educarte/Interector/models/students_model.dart';
import 'package:educarte/Ui/components/bnt_azul.dart';
import 'package:educarte/Ui/components/organisms/modal.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'dash_line.dart';

class CardTimeControl extends StatelessWidget {
  const CardTimeControl({
    super.key, 
    required this.student,
    this.showButton = true, 
    this.callback
  });
  final Student student;
  final bool showButton;
  final Function(bool result)? callback;

  @override
  Widget build(BuildContext context) {
    bool verificationEntryandExit = false;
    if(student.contratedHours?.length == 1){
      verificationEntryandExit = true;
    }else if(student.contratedHours?.length == 2){
      verificationEntryandExit = false;
    }

    return Card(
      elevation: 3,
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
            InformationAboutTheStudents(legalGuardian: student.legalGuardian),
            const SizedBox(height: 10),
            if(showButton)
            BotaoAzul(
              text: "Registrar horário",
              onPressed: () => ModalEvent.build(
                context: context, 
                modalType: verificationEntryandExit ? ModalType.confirmEntry : ModalType.confirmExit,
                student: student,
                callback: (result) => callback!(result),
                cardTimeControl: CardTimeControl(
                  student: student,
                  showButton: false
                )
              ),
            )
          ],
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