class SubsidiaryModel {
  final int id;
  final String name;
  final bool inactive;

  SubsidiaryModel(
      {required this.id, required this.name, required this.inactive});

  factory SubsidiaryModel.fromJson(Map<String, dynamic> json) {
    return SubsidiaryModel(
        id: int.tryParse(json['id'] ?? '') ?? 0,
        name: json['name'] ?? '',
        inactive: json['inactive']);
  }
}
