

class AttendanceModel {
  String? id;
  int? internalId;
  String? empId;
  String? date;

  String? checkIn;
  String? checkOut;

  bool? isRegularized;

  List<PunchModel>? punches;

  AttendanceModel({
    this.id,
    this.internalId,
    this.empId,
    this.date,
    this.checkIn,
    this.checkOut,
    this.isRegularized,
    this.punches,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['_id'],
      internalId: json['internalId'],
      empId: json['empId'],
      date: json['date'],
      checkIn: json['checkIn'],
      checkOut: json['checkOut'],
      isRegularized: json['isRegularized'],
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
