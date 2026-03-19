class LeaveBalanceModel {
  final String internalId;
  final String empId;
  final String employeeName;
  final String leaveTypeId;
  final String leaveTypeName;
  final String yearlyLeaveBalance;
  final String leaveBalanceCredited;
  final String leaveBalanceTaken;
  final String totalAppliedDays;
  final String availableLeaveBalance;

  LeaveBalanceModel({
    required this.internalId,
    required this.empId,
    required this.employeeName,
    required this.leaveTypeId,
    required this.leaveTypeName,
    required this.yearlyLeaveBalance,
    required this.leaveBalanceCredited,
    required this.leaveBalanceTaken,
    required this.totalAppliedDays,
    required this.availableLeaveBalance,
  });

  factory LeaveBalanceModel.fromJson(Map<String, dynamic> json) {
    return LeaveBalanceModel(
      internalId: json['internalId'] ?? "",
      empId: json['empId'] ?? "",
      employeeName: json['employeeName'] ?? "",
      leaveTypeId: json['leaveTypeId'] ?? "",
      leaveTypeName: json['leaveType'] ?? '',
      yearlyLeaveBalance: json['yearlyLeaveBalance'] ?? '0',
      leaveBalanceCredited: json['leaveBalanceCredited'] ?? '0',
      leaveBalanceTaken: json['leaveBalanceTaken'] ?? '0',
      totalAppliedDays: json['totalAppliedDays'] ?? '0',
      availableLeaveBalance: json['availableLeaveBalance'] ?? '0',
    );
  }
}
