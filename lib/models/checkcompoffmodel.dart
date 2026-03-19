class GetCountCompOffModel {
  bool? status;
  Message? message;

  GetCountCompOffModel({this.status, this.message});

  GetCountCompOffModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class Message {
  String? sId;
  String? internalid;
  String? empid;
  String? fromDate;
  String? toDate;
  int? totalDays;
  String? validTill;
  String? reason;
  String? dept;
  String? leaveType;
  String? leaveTypeName;
  String? requestedBy;
  String? isutilised;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Message(
      {this.sId,
      this.internalid,
      this.empid,
      this.fromDate,
      this.toDate,
      this.totalDays,
      this.validTill,
      this.reason,
      this.dept,
      this.leaveType,
      this.leaveTypeName,
      this.requestedBy,
      this.isutilised,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Message.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    internalid = json['internalid'];
    empid = json['empid'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    totalDays = json['total_days'];
    validTill = json['valid_till'];
    reason = json['reason'];
    dept = json['dept'];
    leaveType = json['leave_type'];
    leaveTypeName = json['leave_type_name'];
    requestedBy = json['requestedBy'];
    isutilised = json['isutilised'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['internalid'] = internalid;
    data['empid'] = empid;
    data['from_date'] = fromDate;
    data['to_date'] = toDate;
    data['total_days'] = totalDays;
    data['valid_till'] = validTill;
    data['reason'] = reason;
    data['dept'] = dept;
    data['leave_type'] = leaveType;
    data['leave_type_name'] = leaveTypeName;
    data['requestedBy'] = requestedBy;
    data['isutilised'] = isutilised;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
