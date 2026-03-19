class CopyTypeModel {
  final String id;
  final String name;
  final bool inactive;

  CopyTypeModel({
    required this.id,
    required this.name,
    required this.inactive,
  });

  factory CopyTypeModel.fromJson(Map<String, dynamic> json) {
    return CopyTypeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      inactive: json['inactive'] ?? false,
    );
  }
}
