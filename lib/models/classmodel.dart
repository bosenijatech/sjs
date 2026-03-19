class ClassModel {
  final int id;
  final String name;

  ClassModel({
    required this.id,
    required this.name,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}
