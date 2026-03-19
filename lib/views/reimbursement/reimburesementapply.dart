import 'dart:convert';
import 'dart:developer';

import 'package:sjs/models/classmodel.dart';
import 'package:sjs/models/curremcymodel.dart';
import 'package:sjs/models/deptmodel.dart';
import 'package:sjs/models/expcatmodel.dart';
import 'package:sjs/models/expenseamuntmodel.dart';
import 'package:sjs/models/paycompmodel.dart';
import 'package:sjs/models/subsidiarymodel.dart';
import 'package:sjs/models/taxcodemodel.dart';
import 'package:sjs/domain/ApiService.dart';
import 'package:sjs/services/pref.dart';
import 'package:sjs/utils/app_utils.dart';
import 'package:sjs/utils/sharedprefconstants.dart';
import 'package:sjs/views/widgets/assets_image_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReimbursementApplyPage extends StatefulWidget {
  const ReimbursementApplyPage({super.key});

  @override
  State<ReimbursementApplyPage> createState() =>
      _ReimbursementApplyPagePageState();
}

class _ReimbursementApplyPagePageState extends State<ReimbursementApplyPage>
    with SingleTickerProviderStateMixin {
  final expcatKey = GlobalKey<DropdownSearchState<ExpCatModel>>();
  List<ExpenseRow> rows = [ExpenseRow()];
  final formKey = GlobalKey<FormState>();
  String getdeptId = "";
  String getdeptName = "";
  String payrollcomponentid = "";
  String payrollcomponentname = "";
  String getclassId = "";
  String getclassName = "";
  String getheaderSubId = "";
  String getheaderSubName = "";
  bool loading = false;

  DeptModel? selectedDept;
  ClassModel? selectedclass;
  PayCompModel? selectedpayModel;
  SubsidiaryModel? selectSubsidiary;
  ExpCatModel? selectCategory;

  ExpAmountModel? selectedExpAmount;

  CurrencyModel? selectedCurrency;
  TaxModel? selectedTax;

  void addRow() {
    setState(() {
      selectCategory = null;
      selectedExpAmount = null;
      selectedCurrency = null;
      selectedTax = null;

      rows.add(ExpenseRow());
    });
  }

  void removeRow(int index) {
    setState(() => rows.removeAt(index));
  }

  @override
  void initState() {
    if (Prefs.getSubSidiaryId(SharefprefConstants.subsidiaryId) != null &&
        Prefs.getSubSidiaryName(SharefprefConstants.subsidiaryName) != null) {
      selectSubsidiary = SubsidiaryModel(
        id: _getSubsidiaryId(),
        name: Prefs.getSubSidiaryName(SharefprefConstants.subsidiaryName)
            .toString(),
        inactive: false,
      );
    } else {
      // Fallback if pref values are null or empty
      selectSubsidiary = null; // or assign a default model
    }
    _setDefaultPayrollComponent();
    super.initState();
  }

  int _getSubsidiaryId() {
    final rawId = Prefs.getSubSidiaryId(SharefprefConstants.subsidiaryId);
    if (rawId == null ||
        rawId.toString() == "null" ||
        rawId.toString().isEmpty) {
      return 0;
    }
    return int.tryParse(rawId.toString()) ?? 0;
  }

  void _setDefaultPayrollComponent() async {
    setState(() {
      loading = true;
    });
    List<PayCompModel> list = await ApiService.paycomponentlist(filter: "");
    if (list.isNotEmpty) {
      setState(() {
        selectedpayModel = list[0];
        payrollcomponentid = list[0].id.toString();
        payrollcomponentname = list[0].name.toString();
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Example: you can call an API or pass data back
        Navigator.pop(context, true); // send result to previous screen
        return false; // prevent default pop, since we already did it manually
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            "Expense Entry",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Call calculate again in case some fields changed
                    for (var row in rows) {
                      row.calculate();
                    }

                    // Convert all rows to JSON
                    List<Map<String, dynamic>> jsonList =
                        rows.map((row) => row.toJson()).toList();

                    // if (selectedclass == null) {
                    //   AppUtils.showSingleDialogPopup(context,
                    //       "Please Choose Class", "Ok", onexitpopup, null);
                    // } else

                    if (selectedDept == null) {
                      AppUtils.showSingleDialogPopup(context,
                          "Please Choose Department", "Ok", onexitpopup, null);
                    } else if (payrollcomponentid.toString().isEmpty) {
                      AppUtils.showSingleDialogPopup(
                          context,
                          "Please Choose Payroll Component",
                          "Ok",
                          onexitpopup,
                          null);
                    } else {
                      // ✅ All validations passed
                      postParentRecord();
                    }
                  }
                },
                icon: const Icon(Icons.save))
          ],
          // flexibleSpace: Container(
          //     decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //       colors: <Color>[
          //         Color(0xff9ecb3b),
          //         Color(0xFFB5E254),
          //       ]),
          // )),
        ),
        body: !loading
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerwidget(),
                    Form(
                      key: formKey,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: rows.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return buildrows(index);
                        },
                      ),
                    ),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget headerwidget() {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            // AppUtils.buildNormalText(text: "CLASS"),
            // DropdownSearch<ClassModel>(
            //   selectedItem: selectedclass,
            //   validator: (value) {
            //     if (value == null) {
            //       return 'Please select Class';
            //     }
            //     return null;
            //   },
            //   asyncItems: (String filter) =>
            //       ApiService.getClassList(filter: filter),
            //   itemAsString: (ClassModel item) => item.name,
            //   onChanged: (value) {
            //     if (value != null) {
            //       getclassId = value.id.toString();
            //       getclassName = value.name.toString();
            //       selectedclass = ClassModel(
            //           id: int.parse(getclassId) ?? 0, name: getclassName);
            //     }
            //   },
            //   dropdownDecoratorProps: const DropDownDecoratorProps(
            //     dropdownSearchDecoration: InputDecoration(
            //       labelText: "",
            //       contentPadding: EdgeInsets.symmetric(horizontal: 12),
            //       border: OutlineInputBorder(),
            //     ),
            //   ),
            //   popupProps: PopupProps.menu(
            //     showSearchBox: true,
            //     itemBuilder: (context, item, isSelected) => ListTile(
            //       title: Text(item.name),
            //     ),
            //   ),
            // ),
            // const SizedBox(
            //   height: 5,
            // ),
            AppUtils.buildNormalText(text: "Department"),
            DropdownSearch<DeptModel>(
              selectedItem: selectedDept,
              validator: (value) {
                if (value == null) {
                  return 'Please select department';
                }
                return null;
              },
              asyncItems: (String filter) =>
                  ApiService.getDepartmentList(filter: filter),
              itemAsString: (DeptModel item) => item.name,
              onChanged: (value) {
                if (value != null) {
                  getdeptId = value.id.toString();
                  getdeptName = value.name.toString();
                  selectedDept =
                      DeptModel(id: int.parse(getdeptId), name: getdeptName);
                }
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "",
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(),
                ),
              ),
              popupProps: PopupProps.menu(
                showSearchBox: true,
                itemBuilder: (context, item, isSelected) => ListTile(
                  title: Text(item.name),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const SizedBox(
              height: 5,
            ),
            AppUtils.buildNormalText(text: "Payroll Component"),
            DropdownSearch<PayCompModel>(
              validator: (value) {
                if (value == null) {
                  return 'Please payroll component';
                }
                return null;
              },
              selectedItem: selectedpayModel,
              asyncItems: (String filter) =>
                  ApiService.paycomponentlist(filter: filter),
              itemAsString: (PayCompModel item) => item.name,
              onChanged: (value) {
                if (value != null) {
                  payrollcomponentid = value.id.toString();
                  payrollcomponentname = value.name.toString();
                  selectedpayModel = PayCompModel(
                      id: value.id,
                      name: value.name,
                      paygrpinpayrollcomp: value.paygrpinpayrollcomp);
                }
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "",
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(),
                ),
              ),
              popupProps: PopupProps.menu(
                showSearchBox: true,
                itemBuilder: (context, item, isSelected) => ListTile(
                  title: Text(item.name),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> postParentRecord() async {
    setState(() {
      loading = true;
    });

    try {
      DateTime now = DateTime.now();
      int currentYear = now.year;
      String currentMonthName = DateFormat('MMMM').format(now);

      final body = {
        "data": {
          "empid": Prefs.getNsID(SharefprefConstants.sharednsid),
          "empname": Prefs.getFullName(SharefprefConstants.shareFullName),
          "exchangerate": "1.00",
          "approvalstatus": "2",
          "approvaluserrole": "1059",
          "expensecurrency": "1",
          "departmentid": getdeptId,
          "departmentname": getdeptName,
          "paymonth": currentMonthName,
          "payyear": currentYear,
          "classid": getclassId,
          "classname": getclassName,
          "date": DateFormat('dd/MM/yyyy').format(now),
          "paygroupid":
              Prefs.getPayGroupId(SharefprefConstants.sharedpaygroupid),
          "paygroupname":
              Prefs.getPayGroupName(SharefprefConstants.sharedpaygroupname),
          "totalamt": rows
              .fold(0.0, (sum, row) => sum + row.grossAmount)
              .toStringAsFixed(2),
          "subsidiary": selectSubsidiary!.id.toString(),
          "payrollcomponentid": payrollcomponentid,
          "payrollcomponentname": payrollcomponentname,
        }
      };

      log("Header : ${jsonEncode(body)}");

      final response = await ApiService.postexpparent(body);

      setState(() {
        loading = false;
      });

      final resJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (resJson['status'].toString() == "true") {
          final parentId = resJson['parentId'].toString();
          await postLineItems(parentId);
        } else {
          AppUtils.showSingleDialogPopup(
            context,
            resJson['message'],
            "Ok",
            onexitpopup,
            AssetsImageWidget.warningimage,
          );
        }
      } else {
        throw Exception(resJson['message']);
      }
    } catch (e) {
      setState(() {
        loading = false;
      });

      AppUtils.showSingleDialogPopup(
        context,
        e.toString(),
        "Ok",
        onexitpopup,
        AssetsImageWidget.errorimage,
      );
    }
  }

  void onexitpopup() {
    AppUtils.pop(context);
  }

  void onrefreshscreen() {
    AppUtils.pop(context);
    AppUtils.pop(context);
  }

  Future<void> postLineItems(String parentId) async {
    setState(() {
      loading = true;
    });

    try {
      final now = DateTime.now();
      final formatter = DateFormat('dd/MM/yyyy');

      List<Map<String, dynamic>> lineItems = rows.map((row) {
        row.calculate();
        return {
          "parentid": parentId,
          "data": {
            "date": formatter.format(now),
            "expensecategory": row.category,
            "subsidiary": selectSubsidiary!.id.toString(),
            "class": getclassId ?? "",
            "department": getdeptId ?? "",
            "amount": row.amount.toStringAsFixed(2),
            "currency": row.currency ?? "",
            "exchangerate": row.exchangeRate.toStringAsFixed(2),
            "forignamount": row.foreignAmount.toStringAsFixed(2),
            "taxcode": row.taxCode ?? "",
            "taxrate": "${(row.taxRate).toStringAsFixed(2)}%",
            "grossamount": row.grossAmount.toStringAsFixed(2),
            "account": row.account ?? "",
            "taxamount": row.taxAmount.toStringAsFixed(2),
          }
        };
      }).toList();

      log("details ${jsonEncode(lineItems)}");

      final response = await ApiService.postexpdetails(lineItems);

      setState(() {
        loading = false;
      });

      final resJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (resJson['status'].toString() == "true") {
          AppUtils.showSingleDialogPopup(
            context,
            resJson['message'],
            "Ok",
            refreshscreen,
            AssetsImageWidget.warningimage,
          );
        } else {
          AppUtils.showSingleDialogPopup(
            context,
            resJson['message'],
            "Ok",
            onexitpopup,
            AssetsImageWidget.warningimage,
          );
        }
      } else {
        throw Exception(resJson['message'].toString());
      }
    } catch (e) {
      setState(() {
        loading = false;
      });

      AppUtils.showSingleDialogPopup(
        context,
        e.toString(),
        "Ok",
        onexitpopup,
        AssetsImageWidget.errorimage,
      );
    }
  }

  void refreshscreen() {
    AppUtils.pop(context);
    Navigator.pop(context, true);
  }

  Widget buildrows(int index) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(children: [
              Text("Expense #${index + 1}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                onPressed: () => addRow(),
                icon:
                    const Icon(CupertinoIcons.add_circled, color: Colors.green),
              ),
              if (rows.length > 1)
                IconButton(
                  onPressed: () => removeRow(index),
                  icon: const Icon(CupertinoIcons.clear_circled,
                      color: Colors.red),
                ),
            ]),
            const SizedBox(
              height: 10,
            ),
            AppUtils.buildNormalText(text: "Select Category"),
            DropdownSearch<ExpCatModel>(
              validator: (value) {
                if (value == null) {
                  return 'Please select a category';
                }
                return null;
              },
              selectedItem: rows[index].selectedCategory,
              asyncItems: (String filter) =>
                  ApiService.getCategoryList(filter: filter),
              itemAsString: (ExpCatModel item) => item.name,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    rows[index].category = value.id.toString();
                  });
                }
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "",
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  border: OutlineInputBorder(),
                ),
              ),
              popupProps: PopupProps.menu(
                showSearchBox: true,
                itemBuilder: (context, item, isSelected) => ListTile(
                  title: Text(item.name),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            AppUtils.buildNormalText(text: "Select Expense Account"),
            DropdownSearch<ExpAmountModel>(
              selectedItem: selectedExpAmount,
              asyncItems: (String filter) =>
                  ApiService.getexpenseAccount(filter: filter),
              itemAsString: (ExpAmountModel item) => item.acctName,
              onChanged: (value) {
                if (value != null) {
                  print('Selected: ${value.id}, account: ${value.acctName}');
                  setState(() {
                    rows[index].account = value.id.toString();
                    // selectedExpAmount =
                    //     ExpAmountModel(id: value.id, acctName: value.acctName);
                    rows[index].selectedExpAmount = value;
                    rows[index].account = value.id.toString();
                  });
                }
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "",
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(),
                ),
              ),
              popupProps: PopupProps.menu(
                showSearchBox: true,
                itemBuilder: (context, item, isSelected) => ListTile(
                  title: Text(item.id.toString()),
                  subtitle: Text(item.acctName),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            AppUtils.buildNormalText(text: "Foreign Amount"),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: rows[index].foreignAmountControllrt,
              decoration: InputDecoration(
                labelText: '',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.grey)),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.grey)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.black26, width: 1),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (val) {
                rows[index].calculate();
              },
            ),
            Row(
              children: [
                Expanded(
                  child: AppUtils.buildNormalText(text: "Currency"),
                ),
                Expanded(
                  child: AppUtils.buildNormalText(text: "Tax Code"),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownSearch<CurrencyModel>(
                    // validator: (value) {
                    //   if (value == null) {
                    //     return 'Please select a Currency';
                    //   }
                    //   return null;
                    // },
                    selectedItem: selectedCurrency,
                    asyncItems: (String filter) =>
                        ApiService.getCurrencyList(filter: filter),
                    itemAsString: (CurrencyModel item) => item.name,
                    onChanged: (value) async {
                      if (value != null) {
                        final rate = await ApiService.getExchangeRate(
                          baseCurrencyId: "1",
                          transactionCurrencyId: value.id.toString(),
                        );
                        setState(() {
                          rows[index].selectedCurrency = value;
                          rows[index].currency = value.id.toString();
                          rows[index].exchangeRate =
                              double.tryParse(rate ?? '0') ?? 0.0;
                          rows[index]
                              .calculate(); // Calculate amount, tax, gross
                        });
                      }
                    },
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      itemBuilder: (context, item, isSelected) => ListTile(
                        title: Text(item.id.toString()),
                        subtitle: Text(item.name),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: DropdownSearch<TaxModel>(
                    selectedItem: selectedTax,
                    asyncItems: (String filter) => ApiService.getTaxCodeList(
                      filter: filter,
                    ),
                    itemAsString: (TaxModel item) =>
                        "${item.taxocode} ${item.rate}",
                    onChanged: (value) {
                      if (value != null) {
                        print(
                            'Selected: ${value.taxocode}, account: ${value.rate}');

                        setState(() {
                          rows[index].selectedTax = value;
                          double parsedTaxRate = 0.0;
                          if (value.rate.contains('%')) {
                            final cleaned =
                                value.rate.replaceAll('%', '').trim();
                            final parsed = double.tryParse(cleaned);
                            parsedTaxRate = parsed ?? 0.0;
                          }

                          rows[index].taxRate = parsedTaxRate;
                          rows[index].taxCode = value.id;
                          rows[index]
                              .calculate(); // Recalculate amount, tax, gross
                        });
                      }
                    },
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      itemBuilder: (context, item, isSelected) => ListTile(
                        title: Text(item.taxocode.toString()),
                        subtitle: Text(item.rate),
                      ),
                    ),
                  ),
                )
              ],
            ),
            AppUtils.buildNormalText(text: "MEMO"),
            TextFormField(
              controller: rows[index].memoController,
              decoration: InputDecoration(
                labelText: '',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.grey)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.black26, width: 1),
                ),
              ),
              keyboardType: TextInputType.text,
              onChanged: (val) {
                setState(() {});
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Exchange Rate: ${rows[index].exchangeRate.toStringAsFixed(2)}'),
                Text('Amount: ${rows[index].amount.toStringAsFixed(2)}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tax Rate: ${rows[index].taxRate.toStringAsFixed(2)}'),
                Text('Tax Amount: ${rows[index].taxAmount.toStringAsFixed(2)}'),
              ],
            ),
            Text('Gross Amount: ${rows[index].grossAmount.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}

class ExpenseRow {
  String? category;
  String? account;
  String? subsidiary;
  String? currency;
  String? taxCode;

  ExpCatModel? selectedCategory;
  ExpAmountModel? selectedExpAmount;
  CurrencyModel? selectedCurrency;
  TaxModel? selectedTax;

  final TextEditingController foreignAmountControllrt = TextEditingController();
  final TextEditingController memoController = TextEditingController();
  // Calculated fields
  double exchangeRate = 0.0;
  double amount = 0.0;
  double taxRate = 0; // Default 18%
  double taxAmount = 0.0;
  double grossAmount = 0.0;

  double get foreignAmount =>
      double.tryParse(foreignAmountControllrt.text) ?? 0;

  String? get memo => memoController.text;

  void calculate() {
    final double foreignAmountVal = foreignAmount;

    if (foreignAmountVal > 0 && exchangeRate > 0) {
      amount = foreignAmountVal * exchangeRate;
      taxAmount = amount * taxRate / 100;
      grossAmount = amount + taxAmount;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'expensecategory': category,
      'account': account,
      'foreignAmount': foreignAmount,
      'subsidiary': subsidiary,
      'currency': currency,
      'exchangeRate': exchangeRate,
      'amount': amount,
      'taxCode': taxCode,
      'taxRate': taxRate,
      'taxAmount': taxAmount,
      'grossAmount': grossAmount,
      'memo': memo,
    };
  }
}
