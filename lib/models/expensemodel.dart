class ExpenseLine {
  final String date;
  final double amount;
  final double forignamount;
  final double exchangerate;
  final double taxamount;
  final double grossamount;

  ExpenseLine({
    required this.date,
    required this.amount,
    required this.forignamount,
    required this.exchangerate,
    required this.taxamount,
    required this.grossamount,
  });

  factory ExpenseLine.fromJson(Map<String, dynamic> json) {
    return ExpenseLine(
      date: json['date'],
      amount: (json['amount'] ?? 0).toDouble(),
      forignamount: (json['forignamount'] ?? 0).toDouble(),
      exchangerate: (json['exchangerate'] ?? 0).toDouble(),
      taxamount: (json['taxamount'] ?? 0).toDouble(),
      grossamount: (json['grossamount'] ?? 0).toDouble(),
    );
  }
}

class ExpenseData {
  final String internalid;
  final String empname;
  final String classname;
  final String paymonth;
  final String payyear;
  final double totalamt;
  final List<ExpenseLine> expenseLines;

  ExpenseData({
    required this.internalid,
    required this.empname,
    required this.classname,
    required this.paymonth,
    required this.payyear,
    required this.totalamt,
    required this.expenseLines,
  });

  factory ExpenseData.fromJson(Map<String, dynamic> json) {
    var lines = (json['expenseLines'] as List)
        .map((e) => ExpenseLine.fromJson(e))
        .toList();

    return ExpenseData(
      internalid: json['internalid'] ?? "",
      empname: json['empname'] ?? '',
      classname: json['classname'] ?? '',
      paymonth: json['paymonth'] ?? '',
      payyear: json['payyear'] ?? '',
      totalamt: (json['totalamt'] ?? 0).toDouble(),
      expenseLines: lines,
    );
  }
}
