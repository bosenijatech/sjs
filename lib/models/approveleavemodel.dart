class ViewLeaveApproveModel {
  bool? success;
  int? count;
  List<Data>? data;

  ViewLeaveApproveModel({this.success, this.count, this.data});

  ViewLeaveApproveModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    count = json['count'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['count'] = count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? internalid;
  String? leaveapplicationno;
  String? date;
  String? leavetypecode;
  String? leavetypename;
  int? leavebalance;
  String? fromdate;
  String? todate;
  int? totalNoOfDays;
  String? attachmentUrl;
  String? reason;
  String? airticketrequired;
  Null airticketamount;
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
  Null modifiedDate;
  int? isSync;
  String? netsuiteRefNo;
  String? netsuiteRemarks;
  String? lineManagerId;
  String? source;
  List<ApprovalHistory>? approvalHistory;
  String? isallowcancellation;

  Data({
    this.sId,
    this.internalid,
    this.leaveapplicationno,
    this.date,
    this.leavetypecode,
    this.leavetypename,
    this.leavebalance,
    this.fromdate,
    this.todate,
    this.totalNoOfDays,
    this.attachmentUrl,
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
    this.lineManagerId,
    this.source,
    this.approvalHistory,
    this.isallowcancellation,
  });

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    internalid = json['internalid'];
    leaveapplicationno = json['leaveapplicationno'];
    date = json['date'];
    leavetypecode = json['leavetypecode'];
    leavetypename = json['leavetypename'];
    leavebalance = json['leavebalance'];
    fromdate = json['fromdate'];
    todate = json['todate'];
    totalNoOfDays = json['total_no_of_days'];
    attachmentUrl = json['attachmentUrl'];
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
   
    lineManagerId = json['lineManagerId'];
    source = json['Source'];
   
    if (json['approval_history'] != null) {
      approvalHistory = <ApprovalHistory>[];
      json['approval_history'].forEach((v) {
        approvalHistory!.add(ApprovalHistory.fromJson(v));
      });
    }
   
    isallowcancellation = json['isallowcancellation'];
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['internalid'] = internalid;
    data['leaveapplicationno'] = leaveapplicationno;
    data['date'] = date;
    data['leavetypecode'] = leavetypecode;
    data['leavetypename'] = leavetypename;
    data['leavebalance'] = leavebalance;
    data['fromdate'] = fromdate;
    data['todate'] = todate;
    data['total_no_of_days'] = totalNoOfDays;
    data['attachmentUrl'] = attachmentUrl;
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
   
    data['lineManagerId'] = lineManagerId;
    data['Source'] = source;
   
    if (approvalHistory != null) {
      data['approval_history'] =
          approvalHistory!.map((v) => v.toJson()).toList();
    }
  
    data['isallowcancellation'] = isallowcancellation;
    
    return data;
  }
}

class ApprovalHistory {
  String? approverid;
  String? approvername;
  String? approvalLevel;
  String? approvalUserType;
  String? status;
  String? remarks;
  String? reasonforRejection;
  String? approveddate;
  String? sId;

  ApprovalHistory(
      {this.approverid,
      this.approvername,
      this.approvalLevel,
      this.approvalUserType,
      this.status,
      this.remarks,
      this.reasonforRejection,
      this.approveddate,
      this.sId});

  ApprovalHistory.fromJson(Map<String, dynamic> json) {
    approverid = json['approverid'];
    approvername = json['approvername'];
    approvalLevel = json['approvalLevel'];
    approvalUserType = json['approvalUserType'];
    status = json['status'];
    remarks = json['remarks'];
    reasonforRejection = json['reasonforRejection'];
    approveddate = json['approveddate'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['approverid'] = approverid;
    data['approvername'] = approvername;
    data['approvalLevel'] = approvalLevel;
    data['approvalUserType'] = approvalUserType;
    data['status'] = status;
    data['remarks'] = remarks;
    data['reasonforRejection'] = reasonforRejection;
    data['approveddate'] = approveddate;
    data['_id'] = sId;
    return data;
  }
}
