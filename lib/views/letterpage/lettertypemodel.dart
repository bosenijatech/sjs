class LetterTypeModel {
  final String id;
  final String name;
  final bool inactive;

  LetterTypeModel({
    required this.id,
    required this.name,
    required this.inactive,
  });

  factory LetterTypeModel.fromJson(Map<String, dynamic> json) {
    return LetterTypeModel(
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
