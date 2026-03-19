import 'package:sjs/models/expensemodel.dart';
import 'package:sjs/routenames.dart';
import 'package:sjs/domain/ApiService.dart';
import 'package:sjs/utils/app_utils.dart';
import 'package:sjs/views/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReimbursementDetails extends StatefulWidget {
  const ReimbursementDetails({super.key});

  @override
  State<ReimbursementDetails> createState() => _ReimbursementDetailsState();
}

class _ReimbursementDetailsState extends State<ReimbursementDetails> {
  bool loading = false;
  late Future<List<ExpenseData>> futureExpenses;
  @override
  void initState() {
    futureExpenses = ApiService.fetchExpenses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AppUtils.buildNormalText(
            text: "Expense Details", color: Colors.black, fontSize: 20),
        centerTitle: true,
      ),
      body: FutureBuilder<List<ExpenseData>>(
        future: futureExpenses,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No Expense Claim found!',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, i) {
                final expense = snapshot.data![i];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor:
                          Colors.transparent, // Remove ExpansionTile line
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      childrenPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      backgroundColor: Colors.white,
                      collapsedBackgroundColor: Colors.white,
                      title: Text(
                        '${expense.empname} ${expense.classname} - ${expense.internalid}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(
                        '${expense.internalid} • ${expense.paymonth} ${expense.payyear}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          expense.empname.isNotEmpty ? expense.empname[0] : '?',
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                      children: expense.expenseLines.map((line) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '📅 ${line.date}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Foreign Amt ${line.forignamount}',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  Text(
                                    'Ex.Rate ${line.exchangerate}',
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Net: ${line.amount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                  Text(
                                    'Tax: ${line.taxamount.toStringAsFixed(2)}',
                                    style:
                                        const TextStyle(color: Colors.orange),
                                  ),
                                  Text(
                                    'Gross: ${line.grossamount.toStringAsFixed(2)}',
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      persistentFooterButtons: [
        CustomButton(
            onPressed: () async {
              final result =
                  await Navigator.pushNamed(context, RouteNames.reimapply);

              if (result == true) {
                setState(() {
                  futureExpenses = ApiService.fetchExpenses(); // No await here
                });
              }
            },
            name: "Click to Apply Expense",
            fontSize: 14,
            circularvalue: 30),
      ],
    );
  }
}
