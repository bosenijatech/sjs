class AssetTypeModel {
  final String id;
  final String name;
  final bool inactive;

  AssetTypeModel({
    required this.id,
    required this.name,
    required this.inactive,
  });

  factory AssetTypeModel.fromJson(Map<String, dynamic> json) {
    return AssetTypeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      inactive: json['inactive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'inactive': inactive,
    };
  }
}
