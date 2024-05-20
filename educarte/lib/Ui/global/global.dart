import 'package:educarte/Interector/models/students_model.dart';
import 'package:flutter/material.dart';

String? nome;
String? token;
String? id;
String? idStudent;
int? profile;

bool updateHomeScreen = false;

String? emailEsqueciSenha;
String? code;

String? nomeAluno;
String? nomeSala;

final ValueNotifier<Student> currentStudent = ValueNotifier<Student>(Student.empty());

int checkUserType({required String profileType}){
  return switch(profileType){
    "Employee" || "Teacher" || "Admin" => profile = 2,
    _ => profile = 1
  };
}
String routerPath(bool firtAccess){
  if(firtAccess){
    return "/redefinirSenha";
  }else{
    if(profile == 1){
      return "/home";
    }else{
      return "/timeControl";
    }
  }

}