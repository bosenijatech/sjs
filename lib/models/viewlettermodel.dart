class ViewletterModel {
  bool? status;
  List<Message>? message;

  ViewletterModel({this.status, this.message});

  ViewletterModel.fromJson(Map<String, dynamic> json) {
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
  String? internalid;
  String? sId;
  String? requestapplicationno;
  String? date;
  String? lettertypecode;
  String? lettertypename;
  String? letteraddresstocode;
  String? letteraddresstoname;
  String? purpose;
  String? attachment;
  String? iscancelled;
  String? isstatus;
  int? createdby;
  String? createdDate;
  int? toEmpID;
  String? toEmpName;
  int? isSync;
  List<ApprovalHistory>? approvalHistory;
  int? iV;
  String? others;
  String? copyTypeName;
  String? copyTypeId;
  Message(
      {this.internalid,
      this.sId,
      this.requestapplicationno,
      this.date,
      this.lettertypecode,
      this.lettertypename,
      this.letteraddresstocode,
      this.letteraddresstoname,
      this.purpose,
      this.attachment,
      this.iscancelled,
      this.isstatus,
      this.createdby,
      this.createdDate,
      this.toEmpID,
      this.toEmpName,
      this.isSync,
      this.approvalHistory,
      this.iV,
      this.others,
      this.copyTypeName,
      this.copyTypeId});

  Message.fromJson(Map<String, dynamic> json) {
    internalid = json['internalid'];
    sId = json['_id'];
    requestapplicationno = json['requestapplicationno'];
    date = json['date'];
    lettertypecode = json['lettertypecode'];
    lettertypename = json['lettertypename'];
    letteraddresstocode = json['letteraddresstocode'];
    letteraddresstoname = json['letteraddresstoname'];
    purpose = json['purpose'];
    attachment = json['attachmentUrl'];
    iscancelled = json['iscancelled'];
    isstatus = json['isstatus'];
    createdby = json['createdby'];
    createdDate = json['createdDate'];
    toEmpID = json['toEmpID'];
    toEmpName = json['toEmpName'];
    isSync = json['isSync'];

    if (json['approval_history'] != null) {
      approvalHistory = <ApprovalHistory>[];
      json['approval_history'].forEach((v) {
        approvalHistory!.add(ApprovalHistory.fromJson(v));
      });
    }
    iV = json['__v'];
    others = json['NetsuiteRemarks'];
    copyTypeId = json['copyTypeId'];
    copyTypeName = json['copyTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['internalid'] = internalid;
    data['_id'] = sId;
    data['requestapplicationno'] = requestapplicationno;
    data['date'] = date;
    data['lettertypecode'] = lettertypecode;
    data['lettertypename'] = lettertypename;
    data['letteraddresstocode'] = letteraddresstocode;
    data['letteraddresstoname'] = letteraddresstoname;
    data['purpose'] = purpose;
    data['attachmentUrl'] = attachment;
    data['iscancelled'] = iscancelled;
    data['isstatus'] = isstatus;
    data['createdby'] = createdby;
    data['createdDate'] = createdDate;
    data['toEmpID'] = toEmpID;
    data['toEmpName'] = toEmpName;
    data['isSync'] = isSync;
    if (approvalHistory != null) {
      data['approval_history'] =
          approvalHistory!.map((v) => v.toJson()).toList();
    }
    data['__v'] = iV;
    data['others'] = others;
    data['copyTypeId'] = copyTypeId;
    data['copyTypeName'] = copyTypeName;
    return data;
  }
}

class ApprovalHistory {
  String? approverid;
  String? approvername;
  String? department;
  String? status;
  String? remarks;
  String? approveddate;
  String? sId;

  ApprovalHistory(
      {this.approverid,
      this.approvername,
      this.department,
      this.status,
      this.remarks,
      this.approveddate,
      this.sId});

  ApprovalHistory.fromJson(Map<String, dynamic> json) {
    approverid = json['approverid'];
    approvername = json['approvername'];
    department = json['department'];
    status = json['status'];
    remarks = json['remarks'];
    approveddate = json['approveddate'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['approverid'] = approverid;
    data['approvername'] = approvername;
    data['department'] = department;
    data['status'] = status;
    data['remarks'] = remarks;
    data['approveddate'] = approveddate;
    data['_id'] = sId;
    return data;
  }
}
