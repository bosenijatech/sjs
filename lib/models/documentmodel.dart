class DocumentTypeModel {
  String id;
  String name;
  bool inactive;

  DocumentTypeModel(
      {required this.id, required this.name, required this.inactive});

  factory DocumentTypeModel.fromJson(Map<String, dynamic> json) {
    return DocumentTypeModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      inactive: json['inactive'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['inactive'] = inactive;
    return data;
  }
}
