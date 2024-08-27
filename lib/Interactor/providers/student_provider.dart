import 'dart:convert';

import 'package:educarte/Interactor/models/students_model.dart';
import 'package:educarte/core/config/api_config.dart';
import 'package:flutter/material.dart';

import '../../core/base/store.dart';
import '../models/diary_model.dart';
import '../validations/intl_formatter.dart';

class StudentProvider extends Store{
  bool loading = false;

  void setLoading(bool value){
    loading = value;

    notifyListeners();
  }

  List<Student> students = List.empty(growable: true);
  Student dropdownValue = Student.empty();
  Student currentStudent = Student.empty();
  (String day, String month, String year) datesMenu = ("", "", "");

  bool get datesMenuIsValid => datesMenu.$1.isNotEmpty && datesMenu.$2.isNotEmpty && datesMenu.$3.isNotEmpty;

  Future<void> getStudents({
    required BuildContext context,
    required String legalGuardianId
  }) async{
    setLoading(true);
    String errorMessage = "Erro ao buscar dados dos estudantes";

    try {
      var response = await ApiConfig.request(
        url: "/Students?LegalGuardianId=$legalGuardianId"
      );

      if(response.statusCode == 200){
        Map<String,dynamic> jsonData = jsonDecode(response.body);

        if(currentStudent.isEmpty) {
          currentStudent = Student.fromJson(jsonData["items"][0]);
          dropdownValue = currentStudent;
        }

        getStudentId(context: context);
      }else{
        showErrorMessage(context, errorMessage);
      }
    } catch (e) {
      showErrorMessage(context, errorMessage);
    }

    setLoading(false);
  }

  Future<void> getStudentsLegalGuardian({
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
          salaController: salaController,
          changingGuard: true
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
    TextEditingController? responsavelController,
    TextEditingController? salaController,
    bool changingGuard = false
  }) async {
    setLoading(true);
    String errorMessage = "Erro ao dados dos alunos";

    try {
      var response = await ApiConfig.request(
        url: "/Students/${dropdownValue.id}"
      );

      if(response.statusCode == 200){
        var jsonData = jsonDecode(response.body);

        if(jsonData["diaries"] != null){
          for (var diary in jsonData["diaries"]) {
            currentStudent.listDiaries!.add(Diary.fromJson(diary));
          }
        }

        if(changingGuard && jsonData["classroom"] != null){
          var listTeachers = jsonData["classroom"]["teachers"];

          if(listTeachers.length != 0){
            for(var i=0; i< listTeachers.length; i++){
              if(listTeachers[i]["profile"] == 3 || listTeachers[i]["profile"] == 2){
                responsavelController!.text = jsonData["classroom"]["teachers"][i]["name"];
              }
            }
          }

          if(jsonData["classroom"]["teachers"].isNotEmpty){
            responsavelController!.text = jsonData["classroom"]["teachers"][0]["name"];
          }

          salaController!.text = jsonData["classroom"]["name"];
        }

        List accessControls = jsonData["accessControls"] ?? [];

        if(accessControls.length == 1){
          currentStudent.horaEntrada = jsonData["accessControls"][0]["time"].toString();
        }else if(accessControls.length == 2){
          currentStudent.horaEntrada = jsonData["accessControls"][0]["time"].toString();
          currentStudent.horaSaida = jsonData["accessControls"][1]["time"].toString();
        }

        if(jsonData["currentMenu"] != null){
          datesMenu = await IntlFormatter.getCurrentDate(isDe: true, data: jsonData["currentMenu"]["startDate"]);
        }
      }else{
        showErrorMessage(context, errorMessage);
      }
    } catch (e) {
      showErrorMessage(context, errorMessage);
    }

    setLoading(false);
  }
}