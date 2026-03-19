class PayCompModel {
  final int id;
  final String name;
  final int paygrpinpayrollcomp;

  PayCompModel(
      {required this.id,
      required this.name,
      required this.paygrpinpayrollcomp});

  factory PayCompModel.fromJson(Map<String, dynamic> json) {
    return PayCompModel(
        id: json['id'],
        name: json['name'] ?? '',
        paygrpinpayrollcomp: json['paygrpinpayrollcomp']);
  }
}
