import 'dart:convert';

import 'package:educarte/core/base/store.dart';
import 'package:educarte/Interactor/models/students_model.dart';
import 'package:educarte/Ui/global/global.dart';
import 'package:educarte/Ui/global/global.dart' as globals;
import 'package:educarte/core/config/api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/api_diaries.dart';
import '../validations/convertter.dart';

class StudentUseCase {
  static Future<Student> getStudentId(String idStudent) async {
    Student student = Student(listDiaries: List.empty(growable: true));

    try {
      var response = await http.get(
        Uri.parse("http://64.225.53.11:5000/Students/$idStudent"),
        headers: {
          // "Authorization": "Bearer ${globals.token}"
        }
      );

      if (response.statusCode == 200) {
        var decodeJson = jsonDecode(response.body);
        student = Student.fromJson(decodeJson);

        List<ApiDiaries> listDiariesFiltro = [];
        listDiariesFiltro = student.listDiaries!;
        student.listDiaries = listDiariesFiltro
            .where((element) =>
                DateFormat.yMd()
                    .format(DateTime.parse(element.time.toString())) ==
                DateFormat.yMd().format(DateTime.now()))
            .toList();
        List accessControls = decodeJson["accessControls"] ?? [];

        if (accessControls.length == 1) {
          student.horaEntrada =
              decodeJson["accessControls"][0]["time"].toString();
        } else if (accessControls.length == 2) {
          student.horaEntrada =
              decodeJson["accessControls"][0]["time"].toString();
          student.horaSaida =
              decodeJson["accessControls"][1]["time"].toString();
        }
        if (decodeJson["currentMenu"] != null) {
          student.listData = await Convertter.getCurrentDate(
              isDe: true, data: decodeJson["currentMenu"]["startDate"]);
        }
        updateHomeScreen = false;
      }

      return student;
    } catch (e) {
      return student;
    }
  }

  static Future<void> getStudentsReset({required BuildContext context}) async {
    try {
      globals.listStudent.value.clear();

      var response = await http.get(Uri.parse("$apiUrl/Students"), headers: {
        // "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        List<Student> newListStudent =
            jsonData["items"].map<Student>((e) => Student.fromJson(e)).toList();
        globals.listStudent.value = newListStudent;
      }
    } catch (e) {
      Store().showErrorMessage(context, "Erro ao tentar buscar alunos!");
    }
  }
}
