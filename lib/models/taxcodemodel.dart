class TaxModel {
  final String id;
  final String taxocode;
  final String rate;

  TaxModel({
    required this.id,
    required this.taxocode,
    required this.rate,
  });

  factory TaxModel.fromJson(Map<String, dynamic> json) {
    return TaxModel(
      id: json['id']?.toString() ?? '',
      taxocode: json['name'] ?? '', // ✅ correct key
      rate: json['rate']?.toString() ?? '',
    );
  }
}
