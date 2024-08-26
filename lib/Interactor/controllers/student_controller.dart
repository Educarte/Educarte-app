import 'dart:convert';

import 'package:educarte/Interactor/models/students_model.dart';
import 'package:educarte/core/config/api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Ui/global/global.dart' as globals;
import '../../core/base/store.dart';

class StudentController extends Store{
  List<Student> students = List.empty(growable: true);
  ValueNotifier loading = ValueNotifier(false);

  void setLoading(bool value){
    loading.value = value;
  }

  Future<void> getStudents({
    required BuildContext context
  }) async {
    setLoading(true);
    // bool first = true;

    try {
      var response = await ApiConfig.request(
        url: "$apiUrl/Students?LegalGuardianId=${globals.id}"
      );

      if(response.statusCode == 200){
        var jsonData = jsonDecode(response.body);

        for(var i=0;i < jsonData["items"].length; i++){
          Student newStudent = Student.fromJson(jsonData["items"][i]);
          students.add(newStudent);
        }
        // dropdownValue = students.first;

        // if(first) dropdownValue = students.first;
        // studentId();
      }
    } catch (e) {
      showErrorMessage(context, "Erro ao obter alunos");
    }

    setLoading(true);
  }

  Future<void> getStudentId({
    required BuildContext context
  }) async {
    try {
      var response = await http.get(
        Uri.parse("$apiUrl/Students/${students.first.id}"),
        headers: {
          "Authorization": "Bearer ${globals.token}"
        }
      );

      if(response.statusCode == 200){
        // var jsonData = jsonDecode(response.body);
      }
    } catch (e) {
      showErrorMessage(context, "Erro ao obter aluno");
    }
  }
}