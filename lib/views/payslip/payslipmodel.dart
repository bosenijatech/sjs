class PaySlipModel {
  bool? status;
  int? statusCode;
  String? message;
  String? response;
  List<Data>? data;

  PaySlipModel(
      {this.status, this.statusCode, this.message, this.response, this.data});

  PaySlipModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    statusCode = json['StatusCode'];
    message = json['Message'];
    response = json['Response'];
    if (json['Data'] != null) {
      data = <Data>[];
      json['Data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['StatusCode'] = statusCode;
    data['Message'] = message;
    data['Response'] = response;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? employeeId;
  String? employeeName;
  List<Payslips>? payslips;

  Data({this.employeeId, this.employeeName, this.payslips});

  Data.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    employeeName = json['employeeName'];
    if (json['payslips'] != null) {
      payslips = <Payslips>[];
      json['payslips'].forEach((v) {
        payslips!.add(Payslips.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employeeId'] = employeeId;
    data['employeeName'] = employeeName;
    if (payslips != null) {
      data['payslips'] = payslips!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payslips {
  String? paymonth;
  String? payslip;

  Payslips({this.paymonth, this.payslip});

  Payslips.fromJson(Map<String, dynamic> json) {
    paymonth = json['paymonth'];
    payslip = json['payslip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paymonth'] = paymonth;
    data['payslip'] = payslip;
    return data;
  }
}