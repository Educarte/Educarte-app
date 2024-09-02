class User {
  String? id;
  String? name;
  String? email;
  String? cellphone;
  int? profile;

  User({
    this.id,
    this.name,
    this.email,
    this.cellphone,
    this.profile,
  });

  User.empty();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      cellphone: json['cellphone'],
      profile: json['profile']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['cellphone'] = cellphone;
    data['profile'] = profile;

    return data;
  }
}