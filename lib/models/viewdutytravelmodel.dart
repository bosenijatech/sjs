class ViewDutytravelModel {
  bool? status;
  List<Message>? message;

  ViewDutytravelModel({this.status, this.message});

  ViewDutytravelModel.fromJson(Map<String, dynamic> json) {
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
  String? sId;
  String? internalid;
  String? date;
  String? travelrequestcode;
  String? travelrequestname;
  String? travelmodecode;
  String? travelmodename;
  String? proposedtraveldate;
  String? depaturedate;
  String? returneddate;
  String? duration;
  String? advancerequired;
  String? destination;
  String? flightDetails;
  String? accomptationDetails;
  int? estimateexpenseamount;
  String? remarks;
  String? attachment;
  String? iscancelled;
  String? isstatus;
  int? createdby;
  String? createdbyName;
  String? createdDate;
  int? isSync;
  List<ApprovalHistory>? approvalHistory;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Message(
      {this.sId,
      this.internalid,
      this.date,
      this.travelrequestcode,
      this.travelrequestname,
      this.travelmodecode,
      this.travelmodename,
      this.proposedtraveldate,
      this.depaturedate,
      this.returneddate,
      this.duration,
      this.advancerequired,
      this.destination,
      this.flightDetails,
      this.accomptationDetails,
      this.estimateexpenseamount,
      this.remarks,
      this.attachment,
      this.iscancelled,
      this.isstatus,
      this.createdby,
      this.createdbyName,
      this.createdDate,
      this.isSync,
      this.approvalHistory,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Message.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    internalid = json['internalid'];
    date = json['date'];
    travelrequestcode = json['travelrequestcode'];
    travelrequestname = json['travelrequestname'];
    travelmodecode = json['travelmodecode'];
    travelmodename = json['travelmodename'];
    proposedtraveldate = json['proposedtraveldate'];
    depaturedate = json['depaturedate'];
    returneddate = json['returneddate'];
    duration = json['duration'];
    advancerequired = json['advancerequired'];
    destination = json['destination'];
    flightDetails = json['flight_details'];
    accomptationDetails = json['accomptation_details'];
    estimateexpenseamount = json['estimateexpenseamount'];
    remarks = json['remarks'];
    attachment = json['attachment'];
    iscancelled = json['iscancelled'];
    isstatus = json['isstatus'];
    createdby = json['createdby'];
    createdbyName = json['createdbyName'];
    createdDate = json['createdDate'];
    isSync = json['isSync'];
    if (json['approval_history'] != null) {
      approvalHistory = <ApprovalHistory>[];
      json['approval_history'].forEach((v) {
        approvalHistory!.add(ApprovalHistory.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['internalid'] = internalid;
    data['date'] = date;
    data['travelrequestcode'] = travelrequestcode;
    data['travelrequestname'] = travelrequestname;
    data['travelmodecode'] = travelmodecode;
    data['travelmodename'] = travelmodename;
    data['proposedtraveldate'] = proposedtraveldate;
    data['depaturedate'] = depaturedate;
    data['returneddate'] = returneddate;
    data['duration'] = duration;
    data['advancerequired'] = advancerequired;
    data['destination'] = destination;
    data['flight_details'] = flightDetails;
    data['accomptation_details'] = accomptationDetails;
    data['estimateexpenseamount'] = estimateexpenseamount;
    data['remarks'] = remarks;
    data['attachment'] = attachment;
    data['iscancelled'] = iscancelled;
    data['isstatus'] = isstatus;
    data['createdby'] = createdby;
    data['createdbyName'] = createdbyName;
    data['createdDate'] = createdDate;
    data['isSync'] = isSync;
    if (approvalHistory != null) {
      data['approval_history'] =
          approvalHistory!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
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
