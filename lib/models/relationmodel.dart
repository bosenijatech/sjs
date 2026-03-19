class RelationShipModel {
  String id;
  String name;
  bool inactive;

  RelationShipModel(
      {required this.id, required this.name, required this.inactive});

  factory RelationShipModel.fromJson(Map<String, dynamic> json) {
    return RelationShipModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '', // ✅ correct key
      inactive: json['inactive'] ?? false,
    );
  }
}
