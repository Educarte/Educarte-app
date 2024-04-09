class ApiDiaries {
  String? id;
  String? name;
  String? fileUri;
  String? description;
  bool? isDiaryForAll;
  int? diaryType;
  String? time;
  String? imageBackground;

  ApiDiaries({
    this.id,
    this.name,
    this.fileUri,
    this.description,
    this.isDiaryForAll,
    this.diaryType,
    this.time,
    this.imageBackground
  });

  ApiDiaries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fileUri = json['fileUri'];
    description = json['description'];
    isDiaryForAll = json['isDiaryForAll'];
    diaryType = json['diaryType'];
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