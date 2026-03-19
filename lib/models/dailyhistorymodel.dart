class DailyHistoryModel {
  bool? status;
  List<Message>? message;

  DailyHistoryModel({this.status, this.message});

  DailyHistoryModel.fromJson(Map<String, dynamic> json) {
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
  String? empCode;
  String? punchState;
  int? verifyType;
  String? workCode;
  String? terminalSn;
  String? terminalAlias;
  String? areaAlias;
  String? fromLatitude;
  String? fromLongitude;
  String? fromGpsAddress;
  String? punchInTime;
  String? punchOutTime;
  int? syncCheckinstatus;
  int? syncCheckoutstatus;
  String? mobileid;
  String? source;
  String? purpose;
  String? crc;
  String? isAttendancein;
  String? isAttendanceout;
  String? reserved;
  String? uploadTime;
  String? syncTime;
  int? createdbyid;
  String? createdbyname;
  String? createdDate;
  String? docdate;
  int? iV;
  String? toGpsAddress;
  String? toLatitude;
  String? toLongitude;

  Message(
      {this.sId,
      this.empCode,
      this.punchState,
      this.verifyType,
      this.workCode,
      this.terminalSn,
      this.terminalAlias,
      this.areaAlias,
      this.fromLatitude,
      this.fromLongitude,
      this.fromGpsAddress,
      this.punchInTime,
      this.punchOutTime,
      this.syncCheckinstatus,
      this.syncCheckoutstatus,
      this.mobileid,
      this.source,
      this.purpose,
      this.crc,
      this.isAttendancein,
      this.isAttendanceout,
      this.reserved,
      this.uploadTime,
      this.syncTime,
      this.createdbyid,
      this.createdbyname,
      this.createdDate,
      this.docdate,
      this.iV,
      this.toGpsAddress,
      this.toLatitude,
      this.toLongitude});

  Message.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    empCode = json['emp_code'];
    punchState = json['punch_state'];
    verifyType = json['verify_type'];
    workCode = json['work_code'];
    terminalSn = json['terminal_sn'];
    terminalAlias = json['terminal_alias'];
    areaAlias = json['area_alias'];
    fromLatitude = json['from_latitude'];
    fromLongitude = json['from_longitude'];
    fromGpsAddress = json['from_gps_address'];
    punchInTime = json['punch_in_time'];
    punchOutTime = json['punch_out_time'];
    syncCheckinstatus = json['sync_checkinstatus'];
    syncCheckoutstatus = json['sync_checkoutstatus'];
    mobileid = json['mobileid'];
    source = json['source'];
    purpose = json['purpose'];
    crc = json['crc'];
    isAttendancein = json['is_attendancein'];
    isAttendanceout = json['is_attendanceout'];
    reserved = json['reserved'];
    uploadTime = json['upload_time'];
    syncTime = json['sync_time'];
    createdbyid = json['createdbyid'];
    createdbyname = json['createdbyname'];
    createdDate = json['created_date'];
    docdate = json['docdate'];
    iV = json['__v'];
    toGpsAddress = json['to_gps_address'];
    toLatitude = json['to_latitude'];
    toLongitude = json['to_longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['emp_code'] = empCode;
    data['punch_state'] = punchState;
    data['verify_type'] = verifyType;
    data['work_code'] = workCode;
    data['terminal_sn'] = terminalSn;
    data['terminal_alias'] = terminalAlias;
    data['area_alias'] = areaAlias;
    data['from_latitude'] = fromLatitude;
    data['from_longitude'] = fromLongitude;
    data['from_gps_address'] = fromGpsAddress;
    data['punch_in_time'] = punchInTime;
    data['punch_out_time'] = punchOutTime;
    data['sync_checkinstatus'] = syncCheckinstatus;
    data['sync_checkoutstatus'] = syncCheckoutstatus;
    data['mobileid'] = mobileid;
    data['source'] = source;
    data['purpose'] = purpose;
    data['crc'] = crc;
    data['is_attendancein'] = isAttendancein;
    data['is_attendanceout'] = isAttendanceout;
    data['reserved'] = reserved;
    data['upload_time'] = uploadTime;
    data['sync_time'] = syncTime;
    data['createdbyid'] = createdbyid;
    data['createdbyname'] = createdbyname;
    data['created_date'] = createdDate;
    data['docdate'] = docdate;
    data['__v'] = iV;
    data['to_gps_address'] = toGpsAddress;
    data['to_latitude'] = toLatitude;
    data['to_longitude'] = toLongitude;
    return data;
  }
}
