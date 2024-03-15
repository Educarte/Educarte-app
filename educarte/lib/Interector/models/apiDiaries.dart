
class apiDiaries {
  String? id;
  String? name;
  String? fileUri;
  String? description;
  bool? isDiaryForAll;
  int? diaryType;
  String? time;

  apiDiaries(
      {this.id,
        this.name,
        this.fileUri,
        this.description,
        this.isDiaryForAll,
        this.diaryType,
        this.time});

  apiDiaries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fileUri = json['fileUri'];
    description = json['description'];
    isDiaryForAll = json['isDiaryForAll'];
    diaryType = json['diaryType'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['fileUri'] = this.fileUri;
    data['description'] = this.description;
    data['isDiaryForAll'] = this.isDiaryForAll;
    data['diaryType'] = this.diaryType;
    data['time'] = this.time;
    return data;
  }
}