import 'dart:convert';

import 'package:educarte/Interector/models/students_model.dart';
import 'package:educarte/Ui/global/global.dart';
import 'package:educarte/Ui/global/global.dart'as globals;
import 'package:educarte/Ui/shell/educarte_shell.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/api_diaries.dart';
import '../validations/convertter.dart';

class UseCaseStudent{
  static Future<Student> getStudentId(String idStudent) async{
    Student student = Student(
      listDiaries: List.empty(growable: true)
    );

    try{
      var response = await http.get(Uri.parse("http://64.225.53.11:5000/Students/$idStudent"),
          headers: {
            "Authorization": "Bearer ${globals.token}"
          }
      );

      if(response.statusCode == 200){
        var decodeJson = jsonDecode(response.body);
        student = Student.fromJson(decodeJson);

        List<ApiDiaries> listDiariesFiltro = [];
          listDiariesFiltro = student.listDiaries!;
          student.listDiaries = listDiariesFiltro.where((element) => DateFormat.yMd().format(DateTime.parse(element.time.toString())) == DateFormat.yMd().format(DateTime.now())).toList();
          List accessControls = decodeJson["accessControls"] ?? [];

          if(accessControls.length == 1){
            student.horaEntrada = DateFormat.H().format(DateTime.parse(decodeJson["accessControls"][0]["time"].toString()));
          }
          else if(accessControls.length == 2){
            student.horaEntrada = DateFormat.H().format(DateTime.parse(decodeJson["accessControls"][0]["time"].toString()));
          }
        if(decodeJson["currentMenu"] != null){
          student.listData = await Convertter.getCurrentDate(isDe: true, data: decodeJson["currentMenu"]["startDate"]);
        }
        updateHomeScreen = false;

      }

      return student;
    }catch (e){
      return student;
    }
  }
}