class ViewRejoinModel {
  bool? status;
  List<Message>? message;

  ViewRejoinModel({this.status, this.message});

  ViewRejoinModel.fromJson(Map<String, dynamic> json) {
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
  String? leaveinternalid;
  String? reqapplicationno;
  String? date;
  int? employeenumber;
  String? employeename;
  String? designation;
  String? location;
  String? dept;
  String? expectedresumebackdate;
  String? noofdaysdelay;
  String? isworkresume;
  String? isleaveextended;
  String? actualworkresumedate;
  String? isstatus;
  int? createdby;
  String? createdbyName;
  String? createdDate;
  String? modifiedby;
  String? modifiedbyName;
  String? modifiedDate;
  int? isSync;
  String? source;
  List<ApprovalHistory>? approvalHistory;

  Message(
      {this.sId,
      this.internalid,
      this.leaveinternalid,
      this.reqapplicationno,
      this.date,
      this.employeenumber,
      this.employeename,
      this.designation,
      this.location,
      this.dept,
      this.expectedresumebackdate,
      this.noofdaysdelay,
      this.isworkresume,
      this.isleaveextended,
      this.actualworkresumedate,
      this.isstatus,
      this.createdby,
      this.createdbyName,
      this.createdDate,
      this.modifiedby,
      this.modifiedbyName,
      this.modifiedDate,
      this.isSync,
      this.source,
      this.approvalHistory});

  Message.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    internalid = json['internalid'];
    leaveinternalid = json['leaveinternalid'];
    reqapplicationno = json['reqapplicationno'];
    date = json['date'];
    employeenumber = json['employeenumber'];
    employeename = json['employeename'];
    designation = json['designation'];
    location = json['location'];
    dept = json['dept'];
    expectedresumebackdate = json['expectedresumebackdate'];
    noofdaysdelay = json['noofdaysdelay'];
    isworkresume = json['isworkresume'];
    isleaveextended = json['isleaveextended'];
    actualworkresumedate = json['actualworkresumedate'];
    isstatus = json['isstatus'];
    createdby = json['createdby'];
    createdbyName = json['createdbyName'];
    createdDate = json['createdDate'];
    modifiedby = json['modifiedby'];
    modifiedbyName = json['modifiedbyName'];
    modifiedDate = json['modifiedDate'];
    isSync = json['isSync'];
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
    data['_id'] = sId;
    data['internalid'] = internalid;
    data['leaveinternalid'] = leaveinternalid;
    data['reqapplicationno'] = reqapplicationno;
    data['date'] = date;
    data['employeenumber'] = employeenumber;
    data['employeename'] = employeename;
    data['designation'] = designation;
    data['location'] = location;
    data['dept'] = dept;
    data['expectedresumebackdate'] = expectedresumebackdate;
    data['noofdaysdelay'] = noofdaysdelay;
    data['isworkresume'] = isworkresume;
    data['isleaveextended'] = isleaveextended;
    data['actualworkresumedate'] = actualworkresumedate;
    data['isstatus'] = isstatus;
    data['createdby'] = createdby;
    data['createdbyName'] = createdbyName;
    data['createdDate'] = createdDate;
    data['modifiedby'] = modifiedby;
    data['modifiedbyName'] = modifiedbyName;
    data['modifiedDate'] = modifiedDate;
    data['isSync'] = isSync;
    data['Source'] = source;
    if (approvalHistory != null) {
      data['approval_history'] =
          approvalHistory!.map((v) => v.toJson()).toList();
    }
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
