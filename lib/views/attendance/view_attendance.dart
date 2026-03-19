import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sjs/models/viewattendancemodel.dart';
import 'package:sjs/models/viewleavemodel.dart';
import 'package:sjs/domain/ApiService.dart';
import 'package:sjs/services/pref.dart';
import 'package:sjs/utils/app_utils.dart';
import 'package:sjs/utils/custom_indicatoronly.dart';
import 'package:sjs/utils/sharedprefconstants.dart';
import 'package:sjs/views/attendance/regualrization.dart';
import 'package:sjs/views/widgets/assets_image_widget.dart';

class ViewAttendance extends StatefulWidget {
  const ViewAttendance({super.key});

  @override
  State<ViewAttendance> createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  List<ViewAttendanceModel> viewModel = [];
  bool loading = false;
  @override
  void initState() {
    getOneMonthAttendance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: AppUtils.buildNormalText(
            text: "View Attendance - Log",
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          actions: const [],
        ),
        body: !loading
            ? SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      informationdetails(),
                      detailpage(),
                    ]),
              )
            : const Center(
                child: CustomIndicator(),
              ));
  }

  Widget informationdetails() {
    return Center(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: const Color(0xffFFB74D))),
            child: AppUtils.buildNormalText(
                text:
                    "You are at the start of the page. Only current month data is available.",
                fontSize: 12,
                lineSpacing: 2,
                color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget detailpage() {
    if (viewModel.isEmpty) {
      return const Center(child: Text("No Data"));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.length,
      itemBuilder: (BuildContext context, int index) {
        final item = viewModel[index];

        final bool isRegularized = item.isRegularized ?? false;
        final bool isOutMissing = item.checkOut!.isEmpty;

        return InkWell(
          onTap: (!isRegularized && isWithin3Days(item.date ?? ""))
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApplyReqularization(
                        id: item.internalId.toString(),
                        checkIn: item.checkIn.toString().isNotEmpty
                            ? item.checkIn.toString()
                            : "",
                        checkOut: item.checkOut.toString().isNotEmpty
                            ? item.checkOut.toString()
                            : "",
                        docdate: item.date.toString(),
                      ),
                    ),
                  ).then((_) => getOneMonthAttendance());
                }
              : null,
          child: Container(
            margin: const EdgeInsets.all(10),
            padding:
                const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade400,
                width: 0.5,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Date & Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppUtils.buildNormalText(
                      text: item.date ?? "",
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    (isRegularized)
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                              color: (!isRegularized)
                                  ? Colors.orange.shade50
                                  : Colors.green.shade50,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: (!isRegularized)
                                    ? Colors.orange
                                    : Colors.green,
                              ),
                            ),
                            child: AppUtils.buildNormalText(
                              text: "Reqularization Applied",
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                ),

                const SizedBox(height: 10),

                // 🔹 Shift Name
                AppUtils.buildNormalText(
                  text: Prefs.getShiftName(
                    SharefprefConstants.sharedshiftName,
                  ),
                  fontSize: 12,
                ),

                const SizedBox(height: 10),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Check In", style: TextStyle(color: Colors.black54)),
                    Text("Check Out", style: TextStyle(color: Colors.black54)),
                  ],
                ),

                const SizedBox(height: 5),

                // 🔹 Times
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.checkIn.toString().isNotEmpty
                          ? item.checkIn!
                          : "--:--",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      item.checkOut!.isNotEmpty ? item.checkOut! : "--:--",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // 🔹 Effective Hours
                if (item.checkIn!.isNotEmpty && item.checkOut!.isNotEmpty)
                  AppUtils.buildNormalText(
                    text: checkeffectivehours(
                      item.checkIn!,
                      item.checkOut!,
                      0,
                    ),
                    fontSize: 11,
                  ),

                const SizedBox(height: 5),

                // 🔹 Regularization Hint
                if (!isRegularized)
                  Center(
                    child: AppUtils.buildNormalText(
                      text: "Tap here to apply regularization",
                      color: Colors.orange,
                      fontSize: 11,
                    ),
                  ),
                isRegularized
                    ? const Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                      )
                    : const SizedBox.shrink(),
                isRegularized
                    ? Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Req In",
                                  style: TextStyle(color: Colors.black54)),
                              Text("Req Out",
                                  style: TextStyle(color: Colors.black54)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.regIn ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                item.regOut ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
                //_showCustomBottomSheet(viewModel)
              ],
            ),
          ),
        );
      },
    );
  }



  void getOneMonthAttendance() async {
    setState(() {
      loading = true;
    });

    ApiService.viewattendancebiohistory().then((response) {
      setState(() {
        loading = false;
      });

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['status'] == true) {
          viewModel.clear();

          List list = decoded['message'];

          viewModel.addAll(
            list.map((e) => ViewAttendanceModel.fromJson(e)).toList(),
          );
        } else {
          viewModel.clear();
        }
      } else {
        throw Exception(jsonDecode(response.body)['message'].toString());
      }
    }).catchError((e) {
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
    });
  }

  String checkeffectivehours(
    String starttime,
    String endtime,
    int status,
  ) {
    try {
      if (starttime.isEmpty || endtime.isEmpty) return "";

      // ⏰ Input format: 12:07:00 PM
      final format = DateFormat("hh:mm:ss a");

      DateTime start = format.parse(starttime);
      DateTime end = format.parse(endtime);

      // 🛑 If checkout is next day
      if (end.isBefore(start)) {
        end = end.add(const Duration(days: 1));
      }

      Duration diff = end.difference(start);

      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;

      if (status == 0) {
        return "Effective Hours $hours hrs $minutes mins";
      } else {
        return "Gross Hours $hours hrs $minutes mins";
      }
    } catch (e) {
      return "";
    }
  }

  void onexitpopup() {
    Navigator.of(context).pop();
  }

  void onrefreshscreen() {
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }
}

bool isWithin3Days(String dateStr) {
  try {
    DateTime itemDate = DateFormat("dd/MM/yyyy").parse(dateStr);
    DateTime today = DateTime.now();

    DateTime threeDaysBefore = today.subtract(const Duration(days: 3));

    return itemDate.isAfter(threeDaysBefore) ||
        itemDate.isAtSameMomentAs(threeDaysBefore);
  } catch (e) {
    return false;
  }
}
