class ViewAssetModel {
  bool? status;
  List<Message>? message;

  ViewAssetModel({this.status, this.message});

  ViewAssetModel.fromJson(Map<String, dynamic> json) {
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
  String? assetrequestapplicationno;
  String? date;
  String? assettypecode;
  String? assettypename;
  String? assetcode;
  String? assetname;
  String? remarks;
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

  Message(
      {this.internalid,
      this.sId,
      this.assetrequestapplicationno,
      this.date,
      this.assettypecode,
      this.assettypename,
      this.assetcode,
      this.assetname,
      this.remarks,
      this.attachment,
      this.iscancelled,
      this.isstatus,
      this.createdby,
      this.createdDate,
      this.toEmpID,
      this.toEmpName,
      this.isSync,
      this.approvalHistory,
      this.iV});

  Message.fromJson(Map<String, dynamic> json) {
    internalid = json['internalid'];
    sId = json['_id'];
    assetrequestapplicationno = json['assetrequestapplicationno'];
    date = json['date'];
    assettypecode = json['assettypecode'];
    assettypename = json['assettypename'];

    assetcode = json['assetcode'];
    assetname = json['assetname'];

    remarks = json['remarks'];
    attachment = json['attachment'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['internaid'] = internalid;
    data['_id'] = sId;
    data['assetrequestapplicationno'] = assetrequestapplicationno;
    data['date'] = date;
    data['assettypecode'] = assettypecode;
    data['assettypename'] = assettypename;
    data['assetcode'] = assetcode;
    data['assetname'] = assetname;
    data['remarks'] = remarks;
    data['attachment'] = attachment;
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
