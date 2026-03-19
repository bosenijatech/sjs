class ClaimModel {
  String? status;
  String? responseCode;
  int? totalRecords;
  List<Records>? records;

  ClaimModel({this.status, this.responseCode, this.totalRecords, this.records});

  ClaimModel.fromJson(Map<String, dynamic> json) {
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
  String? id;
  String? name;
  bool? inactive;

  Records({this.id, this.name, this.inactive});

  Records.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    inactive = json['inactive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['inactive'] = inactive;
    return data;
  }
}
