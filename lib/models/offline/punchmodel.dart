// class Punch {
//   final int? id;
//   final String attendanceId;
//   final String type;
//   final String time;
//   final String latitude;
//   final String longitude;
//   final String address;
 
//   const Punch({
//     this.id,
//     required this.attendanceId,
//     required this.type,
//     required this.time,
//     required this.latitude,
//     required this.longitude,
//     required this.address,
//   });
 
//   Map<String, dynamic> toMap() {
//     return {
//       if (id != null) 'id': id, // omit → AUTOINCREMENT fires on INSERT
//       'attendanceId': attendanceId,
//       'type': type,
//       'time': time,
//       'latitude': latitude,
//       'longitude': longitude,
//       'address': address,
//     };
//   }
 
//   factory Punch.fromMap(Map<String, dynamic> map) {
//     return Punch(
//       id: map['id'] as int?,
//       attendanceId: map['attendanceId'] as String,
//       type: map['type'] as String,
//       time: map['time'] as String,
//       latitude: map['latitude'] as String,
//       longitude: map['longitude'] as String,
//       address: map['address'] as String,
//     );
//   }
 
//   Punch copyWith({
//     int? id,
//     String? attendanceId,
//     String? type,
//     String? time,
//     String? latitude,
//     String? longitude,
//     String? address,
//   }) {
//     return Punch(
//       id: id ?? this.id,
//       attendanceId: attendanceId ?? this.attendanceId,
//       type: type ?? this.type,
//       time: time ?? this.time,
//       latitude: latitude ?? this.latitude,
//       longitude: longitude ?? this.longitude,
//       address: address ?? this.address,
//     );
//   }
 
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Punch &&
//           runtimeType == other.runtimeType &&
//           id == other.id &&
//           attendanceId == other.attendanceId &&
//           time == other.time;
 
//   @override
//   int get hashCode => Object.hash(id, attendanceId, time);
 
//   @override
//   String toString() =>
//       'Punch(id: $id, attendanceId: $attendanceId, type: $type, time: $time)';
// }
 

 // models/offline/punchmodel.dart

class Punch {
  final String attendanceId;
  final String type;
  final String time;
  final String latitude;
  final String longitude;
  final String address;
    final String remark; 
  final bool isSynced; // ✅ NEW — punch level sync tracking

  Punch({
    required this.attendanceId,
    required this.type,
    required this.time,
    required this.latitude,
    required this.longitude,
    required this.address,
     this.remark = "",  
    this.isSynced = false, // default: unsynced
  });

  Map<String, dynamic> toMap() => {
        'attendanceId': attendanceId,
        'type': type,
        'time': time,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'remark': remark,   
        'isSynced': isSynced ? 1 : 0,
      };

  factory Punch.fromMap(Map<String, dynamic> map) => Punch(
        attendanceId: map['attendanceId'] as String? ?? "",
        type: map['type'] as String? ?? "",
        time: map['time'] as String? ?? "",
        latitude: map['latitude'] as String? ?? "",
        longitude: map['longitude'] as String? ?? "",
        address: map['address'] as String? ?? "",
        remark: map['remark'] as String? ?? "",
        isSynced: (map['isSynced'] as int? ?? 0) == 1,
      );

  // ✅ copyWith — isSynced update-க்கு use பண்ணு
  Punch copyWith({
    String? attendanceId,
    String? type,
    String? time,
    String? latitude,
    String? longitude,
    String? address,
    String? remark,
    bool? isSynced,
  }) =>
      Punch(
        attendanceId: attendanceId ?? this.attendanceId,
        type: type ?? this.type,
        time: time ?? this.time,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        address: address ?? this.address,
         remark: remark ?? this.remark,
        isSynced: isSynced ?? this.isSynced,
      );
}