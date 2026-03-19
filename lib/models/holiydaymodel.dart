class HolidayModel {
  String? status;
  String? responseCode;
  int? totalRecords;
  List<Records>? records;

  HolidayModel(
      {this.status, this.responseCode, this.totalRecords, this.records});

  HolidayModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    responseCode = json['ResponseCode'];
    totalRecords = json['totalRecords'];
    if (json['records'] != null) {
      records = <Records>[];
      json['records'].forEach((v) {
        records!.add(Records.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['ResponseCode'] = responseCode;
    data['totalRecords'] = totalRecords;
    if (records != null) {
      data['records'] = records!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Records {
  String? internalId;
  String? name;
  String? region;
  String? location;
  String? holidayDay;
  String? holidayDate;
  String? weeklyOffCriteria;
  String? remark;
  bool? isAlternativeSaturday;
  bool? considerForLeave;
  bool? inactive;

  Records(
      {this.internalId,
      this.name,
      this.region,
      this.location,
      this.holidayDay,
      this.holidayDate,
      this.weeklyOffCriteria,
      this.remark,
      this.isAlternativeSaturday,
      this.considerForLeave,
      this.inactive});

  Records.fromJson(Map<String, dynamic> json) {
    internalId = json['internalId'];
    name = json['name'];
    region = json['region'];
    location = json['location'];
    holidayDay = json['holidayDay'];
    holidayDate = json['holidayDate'];
    weeklyOffCriteria = json['weeklyOffCriteria'];
    remark = json['remark'];
    isAlternativeSaturday = json['isAlternativeSaturday'];
    considerForLeave = json['considerForLeave'];
    inactive = json['inactive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['internalId'] = internalId;
    data['name'] = name;
    data['region'] = region;
    data['location'] = location;
    data['holidayDay'] = holidayDay;
    data['holidayDate'] = holidayDate;
    data['weeklyOffCriteria'] = weeklyOffCriteria;
    data['remark'] = remark;
    data['isAlternativeSaturday'] = isAlternativeSaturday;
    data['considerForLeave'] = considerForLeave;
    data['inactive'] = inactive;
    return data;
  }
}
