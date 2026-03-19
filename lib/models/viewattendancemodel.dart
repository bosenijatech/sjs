// class ViewAttendanceModel {
//   final String id;
//   final int internalId;
//   final String employeeId;
//   final String employeeName;
//   final String date;
//   final String inTime;
//   final String outTime;
//   final String fromLatLang;
//   final String fromAddress;
//   final String toLatLang;
//   final String toAddress;
//   final String remarks;
//   final bool isRegularized;
//   final String createdAt;
//   final String updatedAt;

//   ViewAttendanceModel({
//     required this.id,
//     required this.internalId,
//     required this.employeeId,
//     required this.employeeName,
//     required this.date,
//     required this.inTime,
//     required this.outTime,
//     required this.fromLatLang,
//     required this.fromAddress,
//     required this.toLatLang,
//     required this.toAddress,
//     required this.remarks,
//     required this.isRegularized,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory ViewAttendanceModel.fromJson(Map<String, dynamic> json) {
//     return ViewAttendanceModel(
//       id: json["_id"],
//       internalId: json["internalId"],
//       employeeId: json["employeeId"],
//       employeeName: json["employeeName"],
//       date: json["date"],
//       inTime: json["inTime"],
//       outTime: json["outTime"] ?? "",
//       fromLatLang: json["fromLatLang"],
//       fromAddress: json["fromAddress"],
//       toLatLang: json["toLatLang"],
//       toAddress: json["toAddress"],
//       remarks: json["remarks"],
//       isRegularized: json["isRegularized"],
//       createdAt: json["createdAt"],
//       updatedAt: json["updatedAt"],
//     );
//   }
// }

class ViewAttendanceModel {
  String? id;
  int? internalId;
  String? empId;
  String? date;
  String? checkIn;
  String? checkOut;
  bool? isRegularized;
  String? regIn;
  String? regOut;
  List<PunchModel>? punches;

  ViewAttendanceModel({
    this.id,
    this.internalId,
    this.empId,
    this.date,
    this.checkIn,
    this.checkOut,
    this.isRegularized,
    this.regIn,
    this.regOut,
    this.punches,
  });

  factory ViewAttendanceModel.fromJson(Map<String, dynamic> json) {
    return ViewAttendanceModel(
      id: json['_id'],
      internalId: json['internalId'],
      empId: json['empId'],
      date: json['date'],
      checkIn: json['checkIn'],
      checkOut: json['checkOut'] ?? "",
      isRegularized: json['isRegularized'],
      regIn: json['regCheckIn'] ?? "",
      regOut: json['regCheckOut'] ?? "",
      punches: json['punches'] != null
          ? List<PunchModel>.from(
              json['punches'].map((x) => PunchModel.fromJson(x)))
          : [],
    );
  }
}

class PunchModel {
  String? type;
  String? time;
  String? latitude;
  String? longitude;
  String? address;

  PunchModel({
    this.type,
    this.time,
    this.latitude,
    this.longitude,
    this.address,
  });

  factory PunchModel.fromJson(Map<String, dynamic> json) {
    return PunchModel(
      type: json['type'],
      time: json['time'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
    );
  }
}
