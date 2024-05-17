class EntryAndExit {
  String? date;
  List<AccessControls>? accessControls;
  ContractedHour? contractedHour;

  EntryAndExit(
      {this.date, this.accessControls, this.contractedHour});

  EntryAndExit.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['accessControls'] != null) {
      accessControls = <AccessControls>[];
      json['accessControls'].forEach((v) {
        accessControls!.add(AccessControls.fromJson(v));
      });
    }
    contractedHour = json['contractedHour'] != null
        ? ContractedHour.fromJson(json['contractedHour'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    if (accessControls != null) {
      data['accessControls'] =
          accessControls!.map((v) => v.toJson()).toList();
    }
    if (contractedHour != null) {
      data['contractedHour'] = contractedHour!.toJson();
    }
    return data;
  }
}

class AccessControls {
  String? id;
  int? accessControlType;
  String? time;

  AccessControls({this.id, this.accessControlType, this.time});

  AccessControls.fromJson(Map<String, dynamic> json) {
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

class ContractedHour {
  String? id;
  double? hours;
  int? status;
  String? startDate;
  String? endDate;

  ContractedHour(
      {this.id, this.hours, this.status, this.startDate, this.endDate});

  ContractedHour.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hours = json['hours'];
    status = json['status'];
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['hours'] = hours;
    data['status'] = status;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    return data;
  }
}
