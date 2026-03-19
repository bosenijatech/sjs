class CurrencyModel {
  final int id;
  final String name;
  final String symbol;

  CurrencyModel({required this.id, required this.name, required this.symbol});

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
        id: int.tryParse(json['id'] ?? '') ?? 0,
        name: json['name'] ?? '',
        symbol: json['symbol']);
  }
}
