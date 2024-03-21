class ContratedHour {
  String? id;
  String? name;
  String? email;
  String? cellphone;
  String? legalGuardianType;
  int? profile;
  int? status;

  ContratedHour({
    this.id,
    this.name,
  });

  ContratedHour.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    cellphone = json['cellphone'];
    legalGuardianType = json['legalGuardianType'];
    profile = json['profile'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['cellphone'] = cellphone;
    data['legalGuardianType'] = legalGuardianType;
    data['profile'] = profile;
    data['status'] = status;

    return data;
  }
}