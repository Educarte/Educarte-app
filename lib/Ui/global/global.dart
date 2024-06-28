import 'package:educarte/Interector/models/students_model.dart';
import 'package:flutter/material.dart';

String? nome;
String? token;
String? id;
String? idStudent;
int? profile;
bool firstAccess = false;
bool updateHomeScreen = false;

String? emailEsqueciSenha;
String? code;

String? nomeAluno;
String? nomeSala;


final ValueNotifier<Student> currentStudent = ValueNotifier<Student>(Student.empty());
final ValueNotifier<List<Student>> listStudent = ValueNotifier<List<Student>>([]);

int checkUserType({required String profileType}){
  return switch(profileType){
    "Employee" || "Teacher" || "Admin" => profile = 2,
    _ => profile = 1
  };
}
String routerPath({required bool firstAccess}){
  print(profile);
  if(firstAccess){
    return "/redefinirSenha";
  }else{
    if(profile == 1){
      return "/home";
    }else{
      return "/timeControl";
    }
  }
}