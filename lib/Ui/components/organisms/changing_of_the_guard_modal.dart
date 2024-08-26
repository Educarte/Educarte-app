import 'dart:convert';

import 'package:educarte/Ui/components/input.dart';
import 'package:educarte/Ui/shell/educarte_shell.dart';
import 'package:educarte/core/enum/modal_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:http/http.dart' as http;

import '../../../Interector/useCase/student_use_case.dart';
import '../../global/global.dart' as globals;
import '../../../Interector/models/students_model.dart';
import '../../../core/base/constants.dart';
import '../bnt_azul.dart';

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
  Student dropdownValue = Student.empty();
  List<Student> students = List.empty(growable: true);
  
  TextEditingController nomeController = TextEditingController();
  TextEditingController salaController = TextEditingController();
  TextEditingController responsavelController = TextEditingController();
  TextEditingController auxiliarController = TextEditingController();

  Future<void> getStudents() async{
    bool first = true;

    var response = await http.get(Uri.parse("http://64.225.53.11:5000/Students?LegalGuardianId=${globals.id}"),
      headers: {
        "Authorization": "Bearer ${globals.token}"
      }
    );

    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);

      setState(() {
        for(var i=0;i < jsonData["items"].length; i++){
          Student newStudent = Student.fromJson(jsonData["items"][i]);
          students.add(newStudent);

        }
        dropdownValue = students.first;

        if(first) dropdownValue = students.first;
        studentId();
      });
    }

  }

  Future<void> studentId()async{
    var response = await http.get(
      Uri.parse("http://64.225.53.11:5000/Students/${dropdownValue.id}"),
      headers: {
        "Authorization": "Bearer ${globals.token}"
      }
    );

    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);

      if(jsonData["classroom"] != null){
        setState(() {
          var listTeachers = jsonData["classroom"]["teachers"];
          if(listTeachers.length != 0){
            for(var i=0; i< listTeachers.length; i++){
              if(listTeachers[i]["profile"] == 3){
                responsavelController.text = jsonData["classroom"]["teachers"][i]["name"];
              }
              if(listTeachers[i]["profile"] == 2){
                responsavelController.text = jsonData["classroom"]["teachers"][i]["name"];
              }
            }
          }
          globals.idStudent = jsonData["id"];
          if(jsonData["classroom"]["teachers"].isNotEmpty){
            responsavelController.text = jsonData["classroom"]["teachers"][0]["name"];
          }
          salaController.text = jsonData["classroom"]["name"];
          globals.nomeSala = jsonData["classroom"]["name"];
          globals.nomeAluno = jsonData["name"];
        });
      }
    }
  }

  @override
  void initState() {
    getStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context),
      height: widget.modalType.height,
      decoration: BoxDecoration(
        color: colorScheme(context).onSurfaceVariant,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8)
        )
      ),
      child: Column(
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
              value: dropdownValue,
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
              onChanged: (Student? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                  //currentStudent = students.where((element) => element == value).toList().first;
                  studentId();
                });
              },
              items: students.map<DropdownMenuItem<Student>>((Student value) {
                return DropdownMenuItem<Student>(
                  value: value,
                  child: Text(value.name!),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16,),
          Input(
            name: "Sala", 
            onChange: salaController,
            readOnly: true
          ),
          const SizedBox(height: 16,),
          Input(
            name: "Responsável pela sala", 
            onChange: responsavelController,
            readOnly: true
          ),
          const SizedBox(height: 16),
          Input(
            name: "Auxiliar", 
            onChange: auxiliarController,
            readOnly: true
          ),
          const SizedBox(height: 32,),
          BotaoAzul(
            text: "Atualizar informações",
            onPressed: () async{
              globals.currentStudent.value = Student.empty();
              globals.currentStudent.value = await StudentUseCase.getStudentId(
                dropdownValue.id!
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
}