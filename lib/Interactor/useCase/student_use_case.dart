import 'dart:convert';

import 'package:educarte/core/base/store.dart';
import 'package:educarte/Interactor/models/students_model.dart';
import 'package:educarte/Ui/global/global.dart' as globals;
import 'package:educarte/core/config/api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class StudentUseCase {
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
