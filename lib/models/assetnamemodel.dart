class AssetNameModel {
  final String id;
  final String name;
  final bool inactive;

  AssetNameModel({
    required this.id,
    required this.name,
    required this.inactive,
  });

  factory AssetNameModel.fromJson(Map<String, dynamic> json) {
    return AssetNameModel(
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
