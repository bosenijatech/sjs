class ExpCatModel {
  final int id;
  final String name;
  final int expenseacct;
  // final String subsidiary;
  // final String? description;

  ExpCatModel({
    required this.id,
    required this.name,
    required this.expenseacct,
    // required this.subsidiary,
    // this.description,
  });

  factory ExpCatModel.fromJson(Map<String, dynamic> json) {
    final details = json['details'] ?? {};

    return ExpCatModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      expenseacct: details['expenseacct'] ?? 0,
      // subsidiary: details['subsidiary'] ?? '',
      // description: details['description'],
    );
  }
}
