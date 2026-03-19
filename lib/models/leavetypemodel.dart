class LeaveTypeModel {
  final int empId;
  final int leaveTypeId;
  final String leaveTypeName;
  final String allowhalfday;

  LeaveTypeModel({
    required this.empId,
    required this.leaveTypeId,
    required this.leaveTypeName,
    required this.allowhalfday,
  });

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypeModel(
      empId: json['empid'] is String
          ? int.parse(json['empid'])
          : json['empid'] ?? 0,
      leaveTypeId: json['leavetypeid'] is String
          ? int.parse(json['leavetypeid'])
          : json['leavetypeid'] ?? 0,
      leaveTypeName: json['leavetypename'] ?? "",
      allowhalfday: json['allowhalfday'] ?? "F",
    );
  }
}
