class ShiftMaster {
  final int? id;
  final String name;
  final bool active;
 
  const ShiftMaster({
    this.id,
    required this.name,
    required this.active,
  });
 
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'active': active ? 1 : 0,
    };
  }
 
  factory ShiftMaster.fromMap(Map<String, dynamic> map) {
    return ShiftMaster(
      id: map['id'] as int?,
      name: map['name'] as String,
      active: (map['active'] as int? ?? 1) == 1,
    );
  }
 
  ShiftMaster copyWith({int? id, String? name, bool? active}) {
    return ShiftMaster(
      id: id ?? this.id,
      name: name ?? this.name,
      active: active ?? this.active,
    );
  }
 
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShiftMaster && runtimeType == other.runtimeType && id == other.id;
 
  @override
  int get hashCode => id.hashCode;
 
  @override
  String toString() =>
      'ShiftMaster(id: $id, name: $name, active: $active)';
}