class LegalGuardian {
  String? id;
  String? name;
  String? email;
  String? cellphone;
  String? legalGuardianType;
  int? profile;
  int? status;

  LegalGuardian({
    this.id,
    this.name,
    this.email,
    this.cellphone,
    this.legalGuardianType,
    this.profile,
    this.status
  });

  factory LegalGuardian.fromJson(Map<String, dynamic> json) {
    return LegalGuardian(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      cellphone: json['cellphone'],
      legalGuardianType: json['legalGuardianType'],
      profile: json['profile'],
      status: json['status']
    );
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