class ViewAllEmployeeModel {
  bool? status;
  List<Message>? message;

  ViewAllEmployeeModel({this.status, this.message});

  ViewAllEmployeeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (message != null) {
      data['message'] = message!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  int? nsId;
  String? employeeCode;
  String? firstName;
  String? middleName;
  String? lastName;
  String? shortName;
  String? department;

  Message(
      {this.nsId,
      this.employeeCode,
      this.firstName,
      this.middleName,
      this.lastName,
      this.shortName,
      this.department});

  Message.fromJson(Map<String, dynamic> json) {
    nsId = json['nsId'];
    employeeCode = json['employeeCode'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    shortName = json['shortName'];
    department = json['department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nsId'] = nsId;
    data['employeeCode'] = employeeCode;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['shortName'] = shortName;
    data['department'] = department;
    return data;
  }
}
