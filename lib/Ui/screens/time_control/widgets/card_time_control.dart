import 'package:educarte/Ui/components/atoms/custom_button.dart';
import 'package:educarte/core/base/constants.dart';
import 'package:educarte/core/base/store.dart';
import 'package:educarte/core/enum/modal_type_enum.dart';
import 'package:educarte/Interactor/models/classroom_model.dart';
import 'package:educarte/Interactor/models/legal_guardians_model.dart';
import 'package:educarte/Interactor/models/students_model.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../Ui/components/organisms/modal.dart';
import 'dash_line.dart';

class CardTimeControl extends StatefulWidget {
  final Student student;
  final bool showButton;
  final Function(bool result)? callback;

  const CardTimeControl({
    super.key, 
    required this.student,
    this.showButton = true, 
    this.callback
  });
  
  @override
  State<CardTimeControl> createState() => _CardTimeControlState();
}

class _CardTimeControlState extends State<CardTimeControl> {
  bool verificationEntryandExit = false;
  
  @override
  Widget build(BuildContext context) {
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
                  widget.student.name!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme(context).bodyLarge!.copyWith(
                    color: colorScheme(context).onInverseSurface,
                    fontWeight: FontWeight.w600
                  )
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: DashedLine(),
            ),
            if(widget.student.classrooms != null)...[
              InformationAboutTheStudents(
                title: "Sala",
                classroom: widget.student.classrooms!,
                first: 0
              )
            ],
            InformationAboutTheStudents(
              legalGuardian: widget.student.legalGuardian
            ),
            const SizedBox(height: 10),
            if(widget.showButton)...[
              CustomButton(
                title: "Registrar horário",
                onPressed: () {
                  if(widget.student.accessControl!.length < 2){
                    ModalEvent.build(
                      context: context,
                      modalType: widget.student.accessControl!.isEmpty ? ModalType.confirmEntry : ModalType.confirmExit,
                      student: widget.student,
                      callback: (result) => widget.callback!(result),
                      cardTimeControl: CardTimeControl(
                        student: widget.student,
                        showButton: false
                      )
                    ); 
                  }else{
                    Store().showErrorMessage(context, "Este usuário já registrou entrada e saída para o dia de hoje.");
                  }
                },
              )
            ]
          ]
        )
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
    Color textColor = colorScheme(context).onInverseSurface;
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