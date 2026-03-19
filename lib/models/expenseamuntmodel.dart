class ExpAmountModel {
  final String id;
  final String acctName;

  ExpAmountModel({
    required this.id,
    required this.acctName,
  });

  factory ExpAmountModel.fromJson(Map<String, dynamic> json) {
    return ExpAmountModel(
      id: json['id'] ?? '',
      acctName: json['acctName'] ?? '',
    );
  }
}
