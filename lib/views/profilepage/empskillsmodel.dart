class SkillMasterModel {
  final String id;
  final String skillCode;
  final String skillName;
  final bool inactive;

  SkillMasterModel({
    required this.id,
    required this.skillCode,
    required this.skillName,
    required this.inactive,
  });

  factory SkillMasterModel.fromJson(Map<String, dynamic> json) {
    return SkillMasterModel(
      id: json['id']?.toString() ?? '',
      skillCode: json['skillCode'] ?? '',
      skillName: json['skillName'] ?? '',
      inactive: json['inactive'] ?? false,
    );
  }
}
