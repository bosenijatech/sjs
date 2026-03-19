class HolidayModel {
  final String internalId;
  final String name;
  final String region;
  final String holidayDate;
  final String holidayDay;
  final String remark;
  final bool inactive;

  HolidayModel({
    required this.internalId,
    required this.name,
    required this.region,
    required this.holidayDate,
    required this.holidayDay,
    required this.remark,
    required this.inactive,
  });

  factory HolidayModel.fromJson(Map<String, dynamic> json) {
    return HolidayModel(
      internalId: json['internalId']?.toString() ?? '',
      name: json['name'] ?? '',
      region: json['region'] ?? '',
      holidayDate: json['holidayDate'] ?? '',
      holidayDay: json['holidayDay'] ?? '',
      remark: json['remark'] ?? '',
      inactive: json['inactive'] ?? false,
    );
  }
}
