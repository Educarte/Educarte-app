import 'dart:convert';

import 'package:educarte/Interactor/models/students_model.dart';
import 'package:educarte/Interactor/providers/menu_provider.dart';
import 'package:educarte/Services/repositories/persistence_repository.dart';
import 'package:educarte/core/config/api_config.dart';
import 'package:educarte/core/enum/persistence_enum.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../core/base/store.dart';
import '../../core/enum/modal_type_enum.dart';
import '../../core/enum/request_type.dart';
import '../models/classroom_model.dart';
import '../models/diary_model.dart';
import '../models/document.dart';
import '../models/entry_and_exit_modal.dart';
import '../validations/intl_formatter.dart';

class StudentProvider extends Store{
  bool loading = false;
  bool initialLoading = false;

  void setLoading(bool value){
    loading = value;

    notifyListeners();
  }

  List<Student> students = List.empty(growable: true);
  List<Student> studentsFilter = List.empty(growable: true);
  Student dropdownValue = Student.empty();
  Student selectedStudent = Student.empty();  
  Classroom classroomSelected = Classroom.empty();
  Student currentStudent = Student.empty();
  List<Diary> listDiaries = List.empty(growable: true);
  List<EntryAndExit> listAccess = List.empty(growable: true);
  List<Classroom> classrooms = List.empty(growable: true);
  int dropdownValueIndex = 0;
  int classroomSelectedIndex = 0;
  String summary = "";
  String monthSummary = "";
  (String day, String month, String year) datesMenu = ("", "", "");

  bool get datesMenuIsValid => datesMenu.$1.isNotEmpty && datesMenu.$2.isNotEmpty && datesMenu.$3.isNotEmpty;

  Future<void> filterStudents({required String term}) async {
    studentsFilter = term.isEmpty ? [] : students.where((element) => element.name!.toLowerCase().contains(term.toLowerCase())).toList();

    notifyListeners();
  } 

  Future<void> getClassrooms({
    required BuildContext context,

  }) async {
    setLoading(true);
    String errorMessage = "Erro ao buscar salas";

    try {
      var response = await ApiConfig.request(
        url: "/Classroom"
      );

      if (response.statusCode == 200) {
        classrooms.clear();

        Map<String, dynamic> jsonData = jsonDecode(response.body);
        classrooms.add(Classroom.empty());

        for (var classroom in jsonData["items"]) {
          classrooms.add(Classroom.fromJson(classroom));
        }
      }else{
        showErrorMessage(context, errorMessage);
      }
    } catch (e) {
      showErrorMessage(context, errorMessage);
    }

    setLoading(false);
  }
  
  Future<void> registerHour({
    required BuildContext context,
    required String studentId,
    required ModalType modalType
  }) async {
    setLoading(true);
    String errorMessage = "Erro ao confirmar entrada e saída!";
    
    try {
      String? token = await PersistenceRepository().read(key: SecureKey.token);  
      
      var response = await ApiConfig.request(
        url: "/Students/AccessControl/$studentId",
        requestType: RequestType.post,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: {}
      );

      if (response.statusCode == 200) {
        if (modalType == ModalType.confirmEntry) {
          showSuccessMessage(context, "Entrada confirmada com sucesso!");
        } else {
          showSuccessMessage(context, "Saída confirmada com sucesso!");
        }

        Navigator.of(context).pop();
      } else {
        showErrorMessage(context, errorMessage);
      }
    } catch (e) {
      showErrorMessage(context, errorMessage);
    }

    setLoading(false);
  }

  Future<void> getStudents({
    required BuildContext context,
    String? legalGuardianId,
    String? customUrl,
    String? term,
    Response? customResponse,
    bool changingDiaries = false
  }) async{
    setLoading(true);
    String errorMessage = "Erro ao buscar dados dos estudantes";

    try {
      var response = customResponse ?? await ApiConfig.request(
        url: customUrl ?? "/Students/Mobile?LegalGuardianId=$legalGuardianId"
      );

      if(response.statusCode == 200){
        Map<String,dynamic> jsonData = jsonDecode(response.body);

        if(customUrl != null){
          students.clear();

          for (var student in jsonData["items"]) {
            students.add(Student.fromJson(student));
          }
        
          await filterStudents(term: term ?? "");
        }else{
          if(currentStudent.isEmpty) {
            currentStudent = Student.fromJson(jsonData["items"][0]);
            dropdownValue = currentStudent;
          }
        
          await getStudentId(
            context: context,
            receivedStudent: currentStudent,
            changingDiaries: changingDiaries
          );
        }
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
    required TextEditingController salaController,
    required String legalGuardianId
  }) async {
    setLoading(true);
    bool first = true;
    String errorMessage = "Erro ao obter dados dos estudantes";

    try {
      var response = await ApiConfig.request(
        url: "/Students/Mobile?LegalGuardianId=$legalGuardianId"
      );

      if(response.statusCode == 200){
        var jsonData = jsonDecode(response.body);
        students.clear();

        for(var i=0;i < jsonData["items"].length; i++){
          Student newStudent = Student.fromJson(jsonData["items"][i]);
          students.add(newStudent);
        }
        
        if(selectedStudent.id != null){
          selectedStudent = dropdownValue;
          dropdownValueIndex = students.indexWhere((element) => element.id == dropdownValue.id);
        }else{
          selectedStudent = students.first;
          dropdownValue = students.first;

          if(first) dropdownValue = students.first;
        }

        await getStudentId(
          context: context,
          responsavelController: responsavelController,
          salaController: salaController,
          changingGuard: true,
          receivedStudent: currentStudent
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
    bool changingGuard = false,
    bool changingDiaries = false,
    required Student receivedStudent
  }) async {
    setLoading(true);
    String errorMessage = "Erro ao dados dos alunos";

    try {
      var response = await ApiConfig.request(
        url: "/Students/${dropdownValue.id}"
      );

      if(response.statusCode == 200){
        var jsonData = jsonDecode(response.body);

        if(changingDiaries && jsonData["diaries"] != null){
          receivedStudent.listDiaries!.clear();
          
          for (var diary in jsonData["diaries"]) {
            receivedStudent.listDiaries!.add(Diary.fromJson(diary));
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
          receivedStudent.horaEntrada = jsonData["accessControls"][0]["time"].toString();
        }else if(accessControls.length == 2){
          receivedStudent.horaEntrada = jsonData["accessControls"][0]["time"].toString();
          receivedStudent.horaSaida = jsonData["accessControls"][1]["time"].toString();
        }

        if(jsonData["currentMenu"] != null){
          final menuProvider = GetIt.instance.get<MenuProvider>();
          
          menuProvider.currentMenu = Document(
            id: jsonData["currentMenu"]["id"].toString(),
            name: jsonData["currentMenu"]["name"].toString(),
            fileUri: jsonData["currentMenu"]["uri"].toString(),
            startDate: jsonData["currentMenu"]["startDate"],
            validUntil: jsonData["currentMenu"]["validUntil"]
          );
          
          datesMenu = await IntlFormatter.getCurrentDate(isDe: true, data: menuProvider.currentMenu.startDate);
        }
      }else{
        showErrorMessage(context, errorMessage);
      }
    } catch (e) {
      showErrorMessage(context, errorMessage);
    }

    setLoading(false);
  }

  Future<void> getAccessControls({
    required BuildContext context,
    required DateTime startDate,
    DateTime? endDate
  }) async{
    setLoading(true);
    String errorMessage = "Erro ao buscar entradas e saídas";

    try {
      var params = {
        'Id': currentStudent.id,
        "StartDate": DateFormat.yMd().format(startDate).toString(),
        "EndDate": endDate == null
            ? DateFormat.yMd().format(startDate).toString()
            : DateFormat.yMd().format(endDate).toString()
      };

      
      var response = await ApiConfig.request(
        customUri: Uri.parse("$apiUrl/Students/AccessControls/${currentStudent.id}").replace(queryParameters: params)
      );

      if(response.statusCode == 200) {
        var decodeJson = jsonDecode(response.body);
        summary = "";
        
        if (!decodeJson["accessControlsByDate"].isEmpty) {
          listAccess.clear();

          decodeJson["accessControlsByDate"] .forEach((item) => listAccess.add(EntryAndExit.fromJson(item)));
          await getSummary(receivedSummary: decodeJson["summary"]);
        }
      }else{
        showErrorMessage(context, errorMessage);
      }
    } catch (e) {
      showErrorMessage(context, errorMessage);
    }

    setLoading(false);
  }

  String messageRecipient({required Diary diary}){
    return switch(diary.diaryType){
      0 => currentStudent.name!,
      1 => diary.classroom!.isNotEmpty ? diary.classroom!.first.name! : "Sala nāo encontrada",
      _ => "Escola"
    };
  }

  Future<void> getDiarys({
    required BuildContext context,
    required DateTime startDate,
    DateTime? endDate,
    bool initial = false
  }) async{
    setLoading(true);

    if(initialLoading){
      initialLoading = true;
    } 

    String errorMessage = "Erro ao buscar diários";

    try {
      var params = {
        'StudentId': currentStudent.id,
        "StartDate": startDate.toString(),
        "EndDate": endDate == null ? startDate.toString() : endDate.toString()
      };

      var response = await ApiConfig.request(
        customUri: Uri.parse("$apiUrl/Diary/Mobile").replace(queryParameters: params)
      );

      if(response.statusCode == 200){
        var jsonData = jsonDecode(response.body);

        if(jsonData["items"] != null){
          listDiaries.clear();

          for (var diary in jsonData["items"]) {
            listDiaries.add(Diary.fromJson(diary));
          }
        }
      }else{
        showErrorMessage(context, errorMessage);
      }
    } catch (e) {
      showErrorMessage(context, errorMessage);
    }

    initialLoading = false;
    setLoading(false);
  } 

  String getDailySummary({
    required String firstDate,
    required String lastDate
  }) {
    DateTime firstTime = DateTime.parse(firstDate);
    DateTime secondTime = DateTime.parse(lastDate);

    Duration difference = firstTime.difference(secondTime);
    String result = '${difference.inHours}h. ${difference.inMinutes % 60} min';

    return result;
  }

  Future<void> getSummary({
    required String receivedSummary
  }) async{
    DateTime timeNow = DateTime.now();
    double contractedHour = listAccess.first.contractedHour!.hours!;
    int hours = contractedHour.toInt();
    int minutes = ((contractedHour - hours) * 60).round();
    DateTime contractedTime = DateTime(timeNow.year, timeNow.month, timeNow.day, hours, minutes, 0, 0);

    receivedSummary = receivedSummary.replaceAll("-", "");
    DateTime dateTimeBase = DateTime(timeNow.year, timeNow.month, timeNow.day);

    Duration duration = Duration(
      hours: int.parse(receivedSummary.split(":")[0]),
      minutes: int.parse(receivedSummary.split(":")[1]),
      seconds: int.parse(receivedSummary.split(":")[2].split(".")[0])
    );

    DateTime dateTimeSummary = dateTimeBase.add(duration);

    Duration difference = contractedTime.difference(dateTimeSummary);
    String result = '${difference.inHours}h. ${difference.inMinutes % 60} min';

    monthSummary = result.contains("-") ? result : "+$result";
  }
}