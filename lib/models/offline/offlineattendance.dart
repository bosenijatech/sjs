class Attendance {
  final String id;
  final int internalId;
  final String empId;
  final String date;
  final String checkIn;
  final String? checkOut;
  final String status;
  final bool isRegularized;
  final bool isSynced;       // ✅ sync queue flag
  final int? shiftId;        // 🔗 FK → shift_master
  final int? projectId;      // 🔗 FK → project_master
  final String createdAt;
  final String updatedAt;
 
  const Attendance({
    required this.id,
    required this.internalId,
    required this.empId,
    required this.date,
    required this.checkIn,
    this.checkOut,
    required this.status,
    required this.isRegularized,
    this.isSynced = false,
    this.shiftId,
    this.projectId,
    required this.createdAt,
    required this.updatedAt,
  });
 
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'internalId': internalId,
      'empId': empId,
      'date': date,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'status': status,
      'isRegularized': isRegularized ? 1 : 0,
      'isSynced': isSynced ? 1 : 0,
      'shiftId': shiftId,
      'projectId': projectId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
 
  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'] as String,
      internalId: map['internalId'] as int,
      empId: map['empId'] as String,
      date: map['date'] as String,
      checkIn: map['checkIn'] as String,
      checkOut: map['checkOut'] as String?,
      status: map['status'] as String,
      isRegularized: (map['isRegularized'] as int? ?? 0) == 1,
      isSynced: (map['isSynced'] as int? ?? 0) == 1,
      shiftId: map['shiftId'] as int?,
      projectId: map['projectId'] as int?,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
    );
  }
 
  Attendance copyWith({
    String? id,
    int? internalId,
    String? empId,
    String? date,
    String? checkIn,
    String? checkOut,
    String? status,
    bool? isRegularized,
    bool? isSynced,
    int? shiftId,
    int? projectId,
    String? createdAt,
    String? updatedAt,
  }) {
    return Attendance(
      id: id ?? this.id,
      internalId: internalId ?? this.internalId,
      empId: empId ?? this.empId,
      date: date ?? this.date,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      status: status ?? this.status,
      isRegularized: isRegularized ?? this.isRegularized,
      isSynced: isSynced ?? this.isSynced,
      shiftId: shiftId ?? this.shiftId,
      projectId: projectId ?? this.projectId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
 
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Attendance && runtimeType == other.runtimeType && id == other.id;
 
  @override
  int get hashCode => id.hashCode;
 
  @override
  String toString() =>
      'Attendance(id: $id, empId: $empId, date: $date, '
      'status: $status, isSynced: $isSynced)';
}
 