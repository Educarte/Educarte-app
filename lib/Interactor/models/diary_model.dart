import 'package:educarte/Interactor/models/classroom_model.dart';

class Diary {
  String? id;
  String? name;
  String? fileUri;
  String? description;
  bool? isDiaryForAll;
  int? diaryType;
  List<Classroom>? classroom; 
  String? time;
  String? imageBackground;

  Diary({
    this.id,
    this.name,
    this.fileUri,
    this.description,
    this.isDiaryForAll,
    this.classroom,
    this.diaryType,
    this.time,
    this.imageBackground
  });

  Diary.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fileUri = json['fileUri'];
    description = json['description'];
    isDiaryForAll = json['isDiaryForAll'];
    diaryType = json['diaryType'];
    classroom = json['classrooms'] != null ? (json['classrooms'] as List).map((val) => Classroom.fromJson(val)).toList() : [];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['fileUri'] = fileUri;
    data['description'] = description;
    data['isDiaryForAll'] = isDiaryForAll;
    data['diaryType'] = diaryType;
    data['time'] = time;

    return data;
  }
}