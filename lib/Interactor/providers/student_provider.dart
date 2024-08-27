import 'dart:convert';

import 'package:educarte/Interactor/models/students_model.dart';
import 'package:educarte/core/config/api_config.dart';
import 'package:flutter/material.dart';

import '../../Ui/global/global.dart' as globals;
import '../../core/base/store.dart';

class StudentProvider extends Store{
  bool loading = false;

  void setLoading(bool value){
    loading = value;

    notifyListeners();
  }

  List<Student> students = List.empty(growable: true);
  Student dropdownValue = Student.empty();
  Student currentStudent = Student.empty();

  Future<void> getStudents({
    required BuildContext context,
    required TextEditingController responsavelController,
    required TextEditingController salaController
  }) async {
    setLoading(true);
    bool first = true;
    String errorMessage = "Erro ao obter dados dos estudantes";

    try {
      var response = await ApiConfig.request(
        url: "/Students?LegalGuardianId=${currentStudent.id}"
      );

      if(response.statusCode == 200){
        var jsonData = jsonDecode(response.body);

        for(var i=0;i < jsonData["items"].length; i++){
          Student newStudent = Student.fromJson(jsonData["items"][i]);
          students.add(newStudent);
        }
        dropdownValue = students.first;

        if(first) dropdownValue = students.first;

        await getStudentId(
          context: context,
          responsavelController: responsavelController,
          salaController: salaController
        );
      }else{
        showErrorMessage(context, errorMessage);
      }
    } catch (e) {
      showErrorMessage(context, errorMessage);
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
        url: "/Students/${dropdownValue.id}"
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