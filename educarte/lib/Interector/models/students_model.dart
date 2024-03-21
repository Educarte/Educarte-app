import 'package:educarte/Interector/models/access_control_model.dart';
import 'package:educarte/Interector/models/contracted_hour_model.dart';
import 'package:educarte/Interector/models/legal_guardians_model.dart';

import 'classroom_model.dart';

class Student {
  String? id;
  String? name;
  String? naturalness;
  String? healthProblem;
  String? allergicFood;
  String? allergicMedicine;
  bool? epilepsy;
  String? allergicBugBite;
  String? specialChild;
  bool? specialChildHasReport;
  String? profession;
  String? workplace;
  int? genre;
  int? bloodType;
  int? time;
  int? status;
  String? birthDate;
  List<Classroom>? classrooms;
  List<LegalGuardian>? legalGuardians;
  List<ContratedHour>? contratedHours;
  List<AcessControl>? accessControl;

  Student({
    this.id,
    this.name,
    this.naturalness,
    this.healthProblem,
    this.allergicFood,
    this.allergicMedicine,
    this.epilepsy,
    this.allergicBugBite,
    this.specialChild,
    this.specialChildHasReport,
    this.profession,
    this.workplace,
    this.genre,
    this.bloodType,
    this.time,
    this.status,
    this.birthDate,
    this.classrooms,
    this.legalGuardians,
    this.contratedHours,
    this.accessControl
  });

  Student.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    naturalness = json['naturalness'];
    healthProblem = json['healthProblem'];
    allergicFood = json['allergicFood'];
    allergicMedicine = json['allergicMedicine'];
    epilepsy = json['epilepsy'];
    allergicBugBite = json['allergicBugBite'];
    specialChild = json['specialChild'];
    specialChildHasReport = json['specialChildHasReport'];
    profession = json['profession'];
    workplace = json['workplace'];
    genre = json['genre'];
    bloodType = json['bloodType'];
    time = json['time'];
    status = json['status'];
    birthDate = json['birthDate'];
    if (json['classrooms'] != null) {
      classrooms = [];
      json['classrooms'].forEach((classroomJson) {
        classrooms!.add(Classroom.fromJson(classroomJson));
      });
    }
    if (json['legalGuardians'] != null) {
      legalGuardians = [];
      json['legalGuardians'].forEach((guardianJson) {
        legalGuardians!.add(LegalGuardian.fromJson(guardianJson));
      });
    }
    if (json['contratedHours'] != null) {
      contratedHours = [];
      json['contratedHours'].forEach((hourJson) {
        contratedHours!.add(ContratedHour.fromJson(hourJson));
      });
    }
    if (json['accessControls'] != null) {
      accessControl = [];
      json['accessControls'].forEach((acessJson) {
        accessControl!.add(AcessControl.fromJson(acessJson));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['naturalness'] = naturalness;
    data['healthProblem'] = healthProblem;
    data['allergicFood'] = allergicFood;
    data['allergicMedicine'] = allergicMedicine;
    data['epilepsy'] = epilepsy;
    data['allergicBugBite'] = allergicBugBite;
    data['specialChild'] = specialChild;
    data['specialChildHasReport'] = specialChildHasReport;
    data['profession'] = profession;
    data['workplace'] = workplace;
    data['genre'] = genre;
    data['bloodType'] = bloodType;
    data['time'] = time;
    data['status'] = status;
    data['birthDate'] = birthDate;
    if (classrooms != null) {
      data['classrooms'] = classrooms!.map((classroom) => classroom.toJson()).toList();
    }
    if (legalGuardians != null) {
      data['legalGuardians'] = legalGuardians!.map((guardian) => guardian.toJson()).toList();
    }
    if (contratedHours != null) {
      data['contratedHours'] = contratedHours!.map((hour) => hour.toJson()).toList();
    }
    if (accessControl != null) {
      data['accessControls'] = accessControl!.map((acess) => acess.toJson()).toList();
    }

    return data;
  }
}