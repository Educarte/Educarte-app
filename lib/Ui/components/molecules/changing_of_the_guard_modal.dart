import 'package:educarte/Interactor/controllers/student_controller.dart';
import 'package:educarte/Ui/components/atoms/custom_button.dart';
import 'package:educarte/Ui/shell/educarte_shell.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../Interactor/useCase/student_use_case.dart';
import '../../../core/enum/modal_type_enum.dart';
import '../../global/global.dart' as globals;
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
  StudentController studentController = StudentController();
  
  TextEditingController nomeController = TextEditingController();
  TextEditingController salaController = TextEditingController();
  TextEditingController responsavelController = TextEditingController();
  TextEditingController auxiliarController = TextEditingController();

  @override
  void initState() {
    studentController.getStudents(
      context: context,
      responsavelController: responsavelController,
      salaController: salaController
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: studentController.loading,
      builder: (_, __, ___) {
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
                      setState(() {
                        selectedIndex = 4;
                      });
          
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
                child: DropdownButtonFormField<Student>(
                  value: studentController.dropdownValue.value,
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
                    studentController.dropdownValue.value = value!;
        
                    await studentController.getStudentId(
                      context: context,
                      responsavelController: responsavelController,
                      salaController: salaController
                    );
                  },
                  items: studentController.students.value.map<DropdownMenuItem<Student>>((Student value) {
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
                  globals.currentStudent.value = Student.empty();
                  studentController.currentStudent.value = await StudentUseCase.getStudentId(
                    studentController.dropdownValue.value.id!
                  );
          
                  if(context.mounted){
                    Navigator.pop(context);
          
                    globals.updateHomeScreen = true;
                    selectedIndex = 2;
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