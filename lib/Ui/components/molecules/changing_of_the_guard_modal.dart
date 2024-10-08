import 'dart:async';

import 'package:educarte/Interactor/providers/student_provider.dart';
import 'package:educarte/Interactor/providers/user_provider.dart';
import 'package:educarte/Ui/components/atoms/custom_button.dart';
import 'package:educarte/Ui/shell/educarte_shell.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/enum/modal_type_enum.dart';
import '../../../Interactor/models/students_model.dart';
import '../../../core/base/constants.dart';
import '../atoms/input.dart';

class ChangingOfTheGuardModal extends StatefulWidget {
  final ModalType modalType;
  const ChangingOfTheGuardModal({
    super.key,
    required this.modalType
  });

  @override
  State<ChangingOfTheGuardModal> createState() => _ChangingOfTheGuardModalState();
}

class _ChangingOfTheGuardModalState extends State<ChangingOfTheGuardModal> {
  final studentProvider = GetIt.instance.get<StudentProvider>();
  final userProvider = GetIt.instance.get<UserProvider>();

  TextEditingController nomeController = TextEditingController();
  TextEditingController salaController = TextEditingController();
  TextEditingController responsavelController = TextEditingController();
  TextEditingController auxiliarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Timer.run(() => studentProvider.getStudentsLegalGuardian(
      context: context,
      responsavelController: responsavelController,
      salaController: salaController,
      legalGuardianId: userProvider.currentLegalGuardian.id!
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: studentProvider,
      builder: (_, __) {
        return Container(
          width: screenWidth(context),
          height: widget.modalType.height,
          decoration: BoxDecoration(color: colorScheme(context).onSurfaceVariant),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: (){
                      selectedIndex.value = 4;
                      studentProvider.selectedStudent = Student.empty();
          
                      Navigator.pop(context);
                    }, 
                    icon: Icon(
                      Symbols.close,
                      color: colorScheme(context).onInverseSurface
                    )
                  ),
                  Text(
                    widget.modalType.title,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: colorScheme(context).onInverseSurface
                    )
                  )
                ]
              ),
              const SizedBox(height: 32,),
              SizedBox(
                height: 55,
                child: DropdownButtonFormField<Student?>(
                  value: studentProvider.students.isEmpty ? studentProvider.dropdownValue : studentProvider.students[studentProvider.dropdownValueIndex],
                  icon: const Icon(Symbols.expand_more),
                  elevation: 16,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: const Color(0xff474C51),
                    height: 1.3
                  ),
                  decoration: InputDecoration(
                    labelText: "Nome",
                    labelStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: const Color(0xff474C51),
                      height: 1.3
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(
                          color: Color(0xffA0A4A8)
                      )
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(
                          color: Color(0xffA0A4A8)
                      )
                    )
                  ),
                  onChanged: (Student? value) async{
                    studentProvider.dropdownValue = value!;
        
                    await studentProvider.getStudentId(
                      context: context,
                      responsavelController: responsavelController,
                      salaController: salaController,
                      receivedStudent: studentProvider.selectedStudent,
                      changingGuard: true
                    );
                  },
                  items: studentProvider.students.map<DropdownMenuItem<Student>>((Student value) {
                    return DropdownMenuItem<Student>(
                      value: value,
                      child: Text(value.name!),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              Input(
                name: "Sala", 
                onChange: salaController,
                readOnly: true
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Input(
                  name: "Responsável pela sala", 
                  onChange: responsavelController,
                  readOnly: true
                ),
              ),
              Input(
                name: "Auxiliar", 
                onChange: auxiliarController,
                readOnly: true
              ),
              const SizedBox(height: 32),
              CustomButton(
                title: "Atualizar informações",
                onPressed: () async{
                  studentProvider.currentStudent = studentProvider.dropdownValue;

                  await studentProvider.getStudentId(
                    context: context,
                    responsavelController: responsavelController,
                    salaController: salaController,
                    receivedStudent: studentProvider.currentStudent,
                    changingGuard: true,
                    changingDiaries: true
                  );
          
                  if(context.mounted){
                    Navigator.pop(context);
          
                    selectedIndex.value = 2;
                  } 
                }
              )
            ],
          ),
        );
      }
    );
  }
}