class ProjectMaster {
  final int? id;
  final String code;
  final String name;
  final bool active;
 
  const ProjectMaster({
    this.id,
    required this.code,
    required this.name,
    required this.active,
  });
 
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      'active': active ? 1 : 0,
    };
  }
 
  factory ProjectMaster.fromMap(Map<String, dynamic> map) {
    return ProjectMaster(
      id: map['id'] as int?,
      code: map['code'] as String,
      name: map['name'] as String,
      active: (map['active'] as int? ?? 1) == 1,
    );
  }
 
  ProjectMaster copyWith({int? id, String? code, String? name, bool? active}) {
    return ProjectMaster(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      active: active ?? this.active,
    );
  }
 
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectMaster &&
          runtimeType == other.runtimeType &&
          id == other.id;
 
  @override
  int get hashCode => id.hashCode;
 
  @override
  String toString() =>
      'ProjectMaster(id: $id, code: $code, name: $name, active: $active)';
}
 