class LocalAttendance {
  String type;
  String time;
  String address;

  LocalAttendance({
    required this.type,
    required this.time,
    required this.address,
  });

  factory LocalAttendance.fromMap(Map<String, dynamic> json) {
    return LocalAttendance(
      type: json['type'],
      time: json['time'],
      address: json['address'],
    );
  }
}