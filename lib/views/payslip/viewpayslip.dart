import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:winstar/domain/ApiService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:winstar/models/yearmodel.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/sharedprefconstants.dart';
import 'package:winstar/views/payslip/payslipmodel.dart';
import 'package:winstar/views/payslip/viewpdf.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewPaySlipPage extends StatefulWidget {
  const ViewPaySlipPage({super.key});

  @override
  State<ViewPaySlipPage> createState() => _ViewPaySlipPageState();
}

class _ViewPaySlipPageState extends State<ViewPaySlipPage> {
  final now = DateTime.now();
  bool loading = false;
  String? selectedYear;
  PaySlipModel? paySlipModel;
  YearModel? selectedYearModel;
  List<YearModel> years = [];
  @override
  void initState() {
    selectedYearModel =
        YearModel(name: now.year.toString(), id: "1", inactive: false);
    selectedYear = now.year.toString();
    getPayslip(selectedYear.toString());
    fetchYears();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Payslip",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🎯 Year Selection Chips
                  Text(
                    "Select Year",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 8),

                  if (years.isEmpty)
                    const Center(child: CircularProgressIndicator())
                  else
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: years
                          .map((year) => ChoiceChip(
                                label: Text(
                                  year.name,
                                  style: TextStyle(
                                    color: selectedYearModel?.id == year.id
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                selected: selectedYearModel?.id == year.id,
                                selectedColor: Colors.deepPurple,
                                checkmarkColor: Colors.white,
                                backgroundColor: Colors.grey[200],
                                onSelected: (bool selected) {
                                  if (selected) {
                                    setState(() {
                                      selectedYearModel = year;
                                      selectedYear = year.name;
                                    });
                                    getPayslip(year.name);
                                  }
                                },
                              ))
                          .toList(),
                    ),
                  const SizedBox(height: 20),

                  // 🧾 Payslip List
                  Expanded(
                    child: (paySlipModel != null &&
                            paySlipModel!.data != null &&
                            paySlipModel!.data!.isNotEmpty &&
                            paySlipModel!.data!.first.payslips != null &&
                            paySlipModel!.data!.first.payslips!.isNotEmpty)
                        ? ListView.separated(
                            itemCount:
                                paySlipModel!.data!.first.payslips!.length,
                            itemBuilder: (context, index) {
                              final payslip =
                                  paySlipModel!.data!.first.payslips![index];
                              return _buildPayslipCard(
                                  payslip.paymonth ?? "Unknown",
                                  payslip.payslip ?? "");
                            },
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                          )
                        : _buildEmptyState(),
                  ),
                ],
              ),
            ),
    );
  }

  // 🪄 Beautiful Payslip Card
  Widget _buildPayslipCard(String month, String pdfUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: const Icon(
              Icons.picture_as_pdf_rounded,
              color: Colors.deepPurple,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  month,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  selectedYear ?? "",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: "View Payslip",
                icon: const Icon(
                  CupertinoIcons.eye_fill,
                  color: Colors.deepPurple,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewPdf(pdfurl: pdfUrl),
                    ),
                  );
                },
              ),
              IconButton(
                tooltip: "Download",
                icon: const Icon(
                  CupertinoIcons.arrow_down_circle_fill,
                  color: Colors.green,
                ),
                onPressed: () {
                  _launchUrl(Uri.parse(pdfUrl));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🪫 Empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(CupertinoIcons.doc_text_search,
              size: 60, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            "No payslips found for $selectedYear",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // 🌐 Launch PDF URL
  Future<void> _launchUrl(url, {bool isNewTab = true}) async {
    if (kIsWeb) {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: isNewTab ? '_blank' : '_self',
      )) {
        throw Exception('Could not launch $url');
      }
    } else if (Platform.isAndroid) {
      if (!await launchUrl(url,
          mode: LaunchMode.externalNonBrowserApplication)) {
        throw Exception('Could not launch $url');
      }
    } else if (Platform.isIOS) {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    }
  }

  // 💼 Payslip API
  void getPayslip(String year) async {
    final String employeeId =
        Prefs.getNsID(SharefprefConstants.sharednsid).toString();

    setState(() => loading = true);

    var body = {
      "employeeId": employeeId,
      "year": year,
    };

    try {
      final response = await ApiService.viewPayslip(body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        print("Payslip API Response: $jsonResponse");

        if (jsonResponse['success'] == true) {
          final List<dynamic> employeeList = jsonResponse['payload'] ?? [];

          final matchedEmployee = employeeList.firstWhere(
            (e) => e['employeeId'].toString() == employeeId,
            orElse: () => null,
          );

          setState(() {
            paySlipModel = matchedEmployee != null
                ? PaySlipModel.fromJson({
                    "Data": [matchedEmployee],
                  })
                : null;

            loading = false;
          });
        } else {
          setState(() {
            paySlipModel = null;
            loading = false;
          });
        }
      } else {
        print("Error: HTTP ${response.statusCode}");
        setState(() => loading = false);
      }
    } catch (e) {
      print("Exception in getPayslip: $e");
      setState(() => loading = false);
    }
  }

  // Fetch Years
  Future<void> fetchYears() async {
    try {
      years = await ApiService.getyearModel(filter: "");
      // Set selected to current year if available
      final currentYear = now.year.toString();
      selectedYearModel = years.firstWhere(
        (year) => year.name == currentYear,
        orElse: () => years.isNotEmpty
            ? years.first
            : YearModel(name: currentYear, id: "1", inactive: false),
      );
      selectedYear = selectedYearModel?.name ?? currentYear;
      setState(() {});
    } catch (e) {
      print("Error fetching years: $e");
    }
  }
}
