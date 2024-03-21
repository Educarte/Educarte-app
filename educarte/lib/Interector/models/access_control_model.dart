class AcessControl {
  String? id;
  int? accessControlType;
  String? time;

  AcessControl({
    this.id,
    this.accessControlType,
    this.time
  });

  AcessControl.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accessControlType = json['accessControlType'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['accessControlType'] = accessControlType;
    data['time'] = time;

    return data;
  }
}