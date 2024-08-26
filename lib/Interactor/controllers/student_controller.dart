import 'dart:convert';

import 'package:educarte/Interactor/models/students_model.dart';
import 'package:educarte/core/config/api_config.dart';
import 'package:flutter/material.dart';

import '../../Ui/global/global.dart' as globals;
import '../../core/base/store.dart';

class StudentController extends Store{
  ValueNotifier loading = ValueNotifier(false);

  void setLoading(bool value){
    loading.value = value;
  }

  ValueNotifier students = ValueNotifier<List<Student>>(List.empty(growable: true));
  ValueNotifier dropdownValue = ValueNotifier<Student>(Student.empty());
  ValueNotifier currentStudent = ValueNotifier<Student>(Student.empty());

  Future<void> getStudents({
    required BuildContext context,
    required TextEditingController responsavelController,
    required TextEditingController salaController
  }) async {
    setLoading(true);
    bool first = true;

    try {
      var response = await ApiConfig.request(
        url: "$apiUrl/Students?LegalGuardianId=${globals.id}"
      );

      if(response.statusCode == 200){
        var jsonData = jsonDecode(response.body);

        for(var i=0;i < jsonData["items"].length; i++){
          Student newStudent = Student.fromJson(jsonData["items"][i]);
          students.value.add(newStudent);
        }
        dropdownValue.value = students.value.first;

        if(first) dropdownValue.value = students.value.first;

        await getStudentId(
          context: context,
          responsavelController: responsavelController,
          salaController: salaController
        );
      }
    } catch (e) {
      showErrorMessage(context, "Erro ao obter alunos");
    }

    setLoading(false);
  }

  Future<void> getStudentId({
    required BuildContext context,
    required TextEditingController responsavelController,
    required TextEditingController salaController
  }) async {
    try {
      var response = await ApiConfig.request(
        url: "$apiUrl/Students/${dropdownValue.value.id}"
      );

      if(response.statusCode == 200){
        var jsonData = jsonDecode(response.body);

        if(jsonData["classroom"] != null){
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
        }
      }
    } catch (e) {
      showErrorMessage(context, "Erro ao obter aluno");
    }

    setLoading(false);
  }
}