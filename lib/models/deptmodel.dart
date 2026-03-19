class DeptModel {
  final int id;
  final String name;

  DeptModel({
    required this.id,
    required this.name,
  });

  factory DeptModel.fromJson(Map<String, dynamic> json) {
    return DeptModel(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}
