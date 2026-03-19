class ViewLeaveModel {
  bool? status;
  List<Message>? message;

  ViewLeaveModel({this.status, this.message});

  ViewLeaveModel.fromJson(Map<String, dynamic> json) {
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
  String? intenalId;
  String? sId;
  String? leaveapplicationno;
  String? date;
  String? leavetypecode;
  String? leavetypename;
  var leavebalance;
  String? fromdate;
  String? todate;
  var totalNoOfDays;
  List<Attachment>? attachment;
  String? reason;
  String? airticketrequired;
  int? airticketamount;
  String? airticketattachment;
  String? iscancelled;
  String? iscancelledreason;
  String? iscancelleddate;
  String? ispullbackcancelled;
  String? ispullbackcancelledreason;
  String? ispullbackcancelleddate;
  String? isstatus;
  int? createdby;
  String? createdByEmpName;
  String? createdDate;
  int? toEmpID;
  String? toEmpCode;
  String? toEmpName;
  String? modifiedby;
  String? modifiedDate;
  int? isSync;
  String? netsuiteRefNo;
  String? netsuiteRemarks;
  List<NetsuiteResponse>? netsuiteResponse;
  String? source;
  List<ApprovalHistory>? approvalHistory;
  String? imageUrl;

  Message(
      {this.intenalId,
      this.sId,
      this.leaveapplicationno,
      this.date,
      this.leavetypecode,
      this.leavetypename,
      this.leavebalance,
      this.fromdate,
      this.todate,
      this.totalNoOfDays,
      this.attachment,
      this.reason,
      this.airticketrequired,
      this.airticketamount,
      this.airticketattachment,
      this.iscancelled,
      this.iscancelledreason,
      this.iscancelleddate,
      this.ispullbackcancelled,
      this.ispullbackcancelledreason,
      this.ispullbackcancelleddate,
      this.isstatus,
      this.createdby,
      this.createdByEmpName,
      this.createdDate,
      this.toEmpID,
      this.toEmpCode,
      this.toEmpName,
      this.modifiedby,
      this.modifiedDate,
      this.isSync,
      this.netsuiteRefNo,
      this.netsuiteRemarks,
      this.netsuiteResponse,
      this.source,
      this.approvalHistory,
      this.imageUrl});

  Message.fromJson(Map<String, dynamic> json) {
    intenalId = json['internalid'];
    sId = json['_id'];
    leaveapplicationno = json['leaveapplicationno'];
    date = json['date'];
    leavetypecode = json['leavetypecode'];
    leavetypename = json['leavetypename'];
    leavebalance = json['leavebalance'];
    fromdate = json['fromdate'];
    todate = json['todate'];
    totalNoOfDays = json['total_no_of_days'];
    if (json['attachment'] != null) {
      attachment = <Attachment>[];
      json['attachment'].forEach((v) {
        attachment!.add(Attachment.fromJson(v));
      });
    }
    reason = json['reason'];
    airticketrequired = json['airticketrequired'];
    airticketamount = json['airticketamount'];
    airticketattachment = json['airticketattachment'];
    iscancelled = json['iscancelled'];
    iscancelledreason = json['iscancelledreason'];
    iscancelleddate = json['iscancelleddate'];
    ispullbackcancelled = json['ispullbackcancelled'];
    ispullbackcancelledreason = json['ispullbackcancelledreason'];
    ispullbackcancelleddate = json['ispullbackcancelleddate'];
    isstatus = json['isstatus'];
    createdby = json['createdby'];
    createdByEmpName = json['createdByEmpName'];
    createdDate = json['createdDate'];
    toEmpID = json['toEmpID'];
    toEmpCode = json['toEmpCode'];
    toEmpName = json['toEmpName'];
    modifiedby = json['modifiedby'];
    modifiedDate = json['modifiedDate'];
    isSync = json['isSync'];
    netsuiteRefNo = json['NetsuiteRefNo'];
    netsuiteRemarks = json['NetsuiteRemarks'];
    imageUrl = json['attachmentUrl'];
    if (json['NetsuiteResponse'] != null) {
      netsuiteResponse = <NetsuiteResponse>[];
      json['NetsuiteResponse'].forEach((v) {
        netsuiteResponse!.add(NetsuiteResponse.fromJson(v));
      });
    }
    source = json['Source'];
    if (json['approval_history'] != null) {
      approvalHistory = <ApprovalHistory>[];
      json['approval_history'].forEach((v) {
        approvalHistory!.add(ApprovalHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['internalid'] = intenalId;
    data['_id'] = sId;
    data['leaveapplicationno'] = leaveapplicationno;
    data['date'] = date;
    data['leavetypecode'] = leavetypecode;
    data['leavetypename'] = leavetypename;
    data['leavebalance'] = leavebalance;
    data['fromdate'] = fromdate;
    data['todate'] = todate;
    data['total_no_of_days'] = totalNoOfDays;
    if (attachment != null) {
      data['attachment'] = attachment!.map((v) => v.toJson()).toList();
    }
    data['reason'] = reason;
    data['airticketrequired'] = airticketrequired;
    data['airticketamount'] = airticketamount;
    data['airticketattachment'] = airticketattachment;
    data['iscancelled'] = iscancelled;
    data['iscancelledreason'] = iscancelledreason;
    data['iscancelleddate'] = iscancelleddate;
    data['ispullbackcancelled'] = ispullbackcancelled;
    data['ispullbackcancelledreason'] = ispullbackcancelledreason;
    data['ispullbackcancelleddate'] = ispullbackcancelleddate;
    data['isstatus'] = isstatus;
    data['createdby'] = createdby;
    data['createdByEmpName'] = createdByEmpName;
    data['createdDate'] = createdDate;
    data['toEmpID'] = toEmpID;
    data['toEmpCode'] = toEmpCode;
    data['toEmpName'] = toEmpName;
    data['modifiedby'] = modifiedby;
    data['modifiedDate'] = modifiedDate;
    data['isSync'] = isSync;
    data['NetsuiteRefNo'] = netsuiteRefNo;
    data['NetsuiteRemarks'] = netsuiteRemarks;
    data['attachmentUrl'] = imageUrl;
    if (netsuiteResponse != null) {
      data['NetsuiteResponse'] =
          netsuiteResponse!.map((v) => v.toJson()).toList();
    }
    data['Source'] = source;
    if (approvalHistory != null) {
      data['approval_history'] =
          approvalHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attachment {
  String? documentNo;
  String? fileData;
  String? fileType;
  String? fileName;
  String? fileSize;
  String? sId;

  Attachment(
      {this.documentNo,
      this.fileData,
      this.fileType,
      this.fileName,
      this.fileSize,
      this.sId});

  Attachment.fromJson(Map<String, dynamic> json) {
    documentNo = json['DocumentNo'];
    fileData = json['FileData'];
    fileType = json['FileType'];
    fileName = json['FileName'];
    fileSize = json['FileSize'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DocumentNo'] = documentNo;
    data['FileData'] = fileData;
    data['FileType'] = fileType;
    data['FileName'] = fileName;
    data['FileSize'] = fileSize;
    data['_id'] = sId;
    return data;
  }
}

class NetsuiteResponse {
  String? sId;
  String? type;
  String? isSync;
  String? netsuiteRefNo;
  String? netsuiteRemarks;

  NetsuiteResponse(
      {this.sId,
      this.type,
      this.isSync,
      this.netsuiteRefNo,
      this.netsuiteRemarks});

  NetsuiteResponse.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    isSync = json['isSync'];
    netsuiteRefNo = json['NetsuiteRefNo'];
    netsuiteRemarks = json['NetsuiteRemarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['type'] = type;
    data['isSync'] = isSync;
    data['NetsuiteRefNo'] = netsuiteRefNo;
    data['NetsuiteRemarks'] = netsuiteRemarks;
    return data;
  }
}

class ApprovalHistory {
  String? sId;
  String? approverid;
  String? approvername;
  String? department;
  String? status;
  String? remarks;
  String? approveddate;

  ApprovalHistory(
      {this.sId,
      this.approverid,
      this.approvername,
      this.department,
      this.status,
      this.remarks,
      this.approveddate});

  ApprovalHistory.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    approverid = json['approverid'];
    approvername = json['approvername'];
    department = json['department'];
    status = json['status'];
    remarks = json['remarks'];
    approveddate = json['approveddate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['approverid'] = approverid;
    data['approvername'] = approvername;
    data['department'] = department;
    data['status'] = status;
    data['remarks'] = remarks;
    data['approveddate'] = approveddate;
    return data;
  }
}
