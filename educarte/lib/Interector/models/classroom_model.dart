class Classroom {
  String? id;
  String? name;
  int? status;
  int? time;
  int? classroomType;

  Classroom({
    this.id,
    this.name,
    this.status,
    this.time,
    this.classroomType
  });

  Classroom.empty();

  Classroom.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    time = json['time'];
    status = json['status'];
    classroomType = json['classroomType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['time'] = time;
    data['classroomType'] = classroomType;

    return data;
  }
}