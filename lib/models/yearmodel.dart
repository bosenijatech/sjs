class YearModel {
  final String id;
  final String name;
  final bool inactive;

  YearModel({
    required this.id,
    required this.name,
    required this.inactive,
  });

  factory YearModel.fromJson(Map<String, dynamic> json) {
    return YearModel(
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
