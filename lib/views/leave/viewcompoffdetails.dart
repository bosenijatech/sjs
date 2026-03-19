import 'dart:convert';
import 'dart:io';

import 'package:winstar/models/viewleavemodelnew.dart';
import 'package:winstar/routenames.dart';
import 'package:winstar/domain/ApiService.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/appcolor.dart';
import 'package:winstar/utils/constants.dart';
import 'package:winstar/utils/custom_indicatoronly.dart';
import 'package:winstar/utils/sharedprefconstants.dart';
import 'package:winstar/views/payslip/viewallfiles.dart';
import 'package:winstar/views/widgets/assets_image_widget.dart';
import 'package:winstar/views/widgets/colorstatus.dart';
import 'package:winstar/views/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewCompOffPage extends StatefulWidget {
  const ViewCompOffPage({super.key});

  @override
  State<ViewCompOffPage> createState() => _ViewCompOffPageState();
}

class _ViewCompOffPageState extends State<ViewCompOffPage>
    with SingleTickerProviderStateMixin {
  bool loading = false;
  List<ViewLeaveModelNew> leavemodel = [];
  List<ViewLeaveModelNew> filteredLeaveList = [];
  List<dynamic> jsonList = [];
  String uniqId = "";
  TextEditingController searchcontroller = TextEditingController();
  TextEditingController cancelleavecontroller = TextEditingController();
  TextEditingController cancelpullleavecontroller = TextEditingController();
  String search = "";
  String cancelleavetxt = "";
  String pullbacktext = "";
  String internalId = "";
  final formKey = GlobalKey<FormState>();
  bool isSearching = false;
  var totalcount = 0;

  List<String> leaveTypes = ["All"];
  String selectedLeaveType = "All";
  List<String> durations = ["All", "Full Day"];
  String selectedDuration = "All";
  List<String> statuses = [
    "All",
    "Approved",
    "Pending Approval",
    "Rejected",
    "Cancelled"
  ];
  String selectedStatus = "All";

  TextEditingController reasonforRejectionController = TextEditingController();
  DateTime? selectedFromDate;
  DateTime? selectedToDate;

  @override
  void initState() {
    super.initState();

    if (mounted) {
      getdetailsdata();
    }
  }

  @override
  void dispose() {
    searchcontroller.dispose();
    cancelleavecontroller.dispose();
    cancelpullleavecontroller.dispose();
    reasonforRejectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () {
            if (isSearching) {
              setState(() {
                isSearching = false;
                searchcontroller.clear();
                filteredLeaveList = leavemodel;
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: !isSearching
            ? const Text(
                "Comp off Leave Details",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              )
            : TextField(
                controller: searchcontroller,
                autofocus: true,
                onChanged: (value) =>
                    onSearchTextChanged(value), // ✅ FIXED HERE
                style: const TextStyle(color: Colors.black, fontSize: 18),
                decoration: const InputDecoration(
                  hintText: "Search leave...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  searchcontroller.clear();
                  filteredLeaveList = leavemodel;
                }
                isSearching = !isSearching;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_alt, color: Colors.black),
            onPressed: () {
              _showFilterSheet(context);
            },
          ),
        ],
      ),
      body: !loading
          ? SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  leavedetailes(
                      Prefs.getNsID(SharefprefConstants.sharednsid).toString())
                ],
              ),
            )
          : const CustomIndicator(),
      persistentFooterButtons: [
        CustomButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.applycompoffleave)
                  .then((_) {
                setState(() {
                  getdetailsdata();
                });
              });
            },
            name: "Click to Apply Leave",
            fontSize: 14,
            circularvalue: 30)
      ],
    );
  }

  void _showFilterSheet(BuildContext context) async {
    String tempLeaveType = selectedLeaveType;
    String tempStatus = selectedStatus;
    String tempDuration = selectedDuration;
    DateTime? tempFromDate = selectedFromDate;
    DateTime? tempToDate = selectedToDate;

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) => SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Filter Leave Records",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, {
                            "type": "All",
                            "status": "All",
                            "duration": "All",
                            "from": null,
                            "to": null
                          });
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Leave Type
                  const Text("Leave Type",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: leaveTypes.map((type) {
                      return ChoiceChip(
                        label: Text(type),
                        selected: tempLeaveType == type,
                        selectedColor: Colors.blue.shade100,
                        onSelected: (val) {
                          setModalState(() => tempLeaveType = type);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Status
                  const Text("Status",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: statuses.map((status) {
                      return ChoiceChip(
                        label: Text(status),
                        selected: tempStatus == status,
                        selectedColor: Colors.blue.shade100,
                        onSelected: (val) {
                          setModalState(() => tempStatus = status);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Duration
                  const Text("Duration",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: durations.map((dur) {
                      return ChoiceChip(
                        label: Text(dur),
                        selected: tempDuration == dur,
                        selectedColor: Colors.blue.shade100,
                        onSelected: (val) {
                          setModalState(() => tempDuration = dur);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // From Date
                  const Text("From Date",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: tempFromDate != null
                          ? "${tempFromDate!.day}/${tempFromDate!.month}/${tempFromDate!.year}"
                          : "",
                    ),
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      hintText: "Select From Date",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: tempFromDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null)
                        setModalState(() => tempFromDate = picked);
                    },
                  ),
                  const SizedBox(height: 16),

                  // To Date
                  const Text("To Date",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: tempToDate != null
                          ? "${tempToDate!.day}/${tempToDate!.month}/${tempToDate!.year}"
                          : "",
                    ),
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      hintText: "Select To Date",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: tempToDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null)
                        setModalState(() => tempToDate = picked);
                    },
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, {
                            "type": "All",
                            "status": "All",
                            "duration": "All",
                            "from": null,
                            "to": null
                          });
                        },
                        child: const Text("Clear",
                            style: TextStyle(color: Colors.red)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check,
                            color: Colors.white, size: 18),
                        label: const Text(
                          "Apply",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context, {
                            "type": tempLeaveType,
                            "status": tempStatus,
                            "duration": tempDuration,
                            "from": tempFromDate,
                            "to": tempToDate
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedLeaveType = result["type"]!;
        selectedStatus = result["status"]!;
        selectedDuration = result["duration"]!;
        selectedFromDate = result["from"];
        selectedToDate = result["to"];
        _applyFilters();
      });
    }
  }

  void _applyFilters() {
    setState(() {
      filteredLeaveList = leavemodel.where((leave) {
        // Leave Type filter
        final leaveTypeMatch = selectedLeaveType == 'All' ||
            leave.leavetypename?.toLowerCase() ==
                selectedLeaveType.toLowerCase();

        // Status filter
        final statusMatch = selectedStatus == 'All' ||
            leave.isstatus?.toLowerCase() == selectedStatus.toLowerCase();

        // Duration filter
        final durationMatch = selectedDuration == 'All' ||
            (selectedDuration == 'Half Day'
                ? leave.totalNoOfDays == "0.5"
                : leave.totalNoOfDays != "0.5");

        // Date range filter
        bool dateMatch = true;
        try {
          final leaveFrom = DateTime.parse(leave.fromdate ?? '');
          final leaveTo = DateTime.parse(leave.todate ?? '');

          if (selectedFromDate != null) {
            dateMatch &= !leaveTo
                .isBefore(selectedFromDate!); // leave ends after from date
          }
          if (selectedToDate != null) {
            dateMatch &= !leaveFrom
                .isAfter(selectedToDate!); // leave starts before to date
          }
        } catch (e) {
          dateMatch = true; // fallback if date parsing fails
        }

        return leaveTypeMatch && statusMatch && durationMatch && dateMatch;
      }).toList();
    });
  }

  Widget leavedetailes(String loggedInEmpId) {
    return filteredLeaveList.isNotEmpty
        ? ListView.builder(
            itemCount: filteredLeaveList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final leave = filteredLeaveList[index];
              final statusText =
                  leave.iscancelled == "Y" || leave.ispullbackcancelled == "Y"
                      ? "Cancelled"
                      : leave.isstatus ?? "Unknown";

              final backgroundColor = leave.iscancelled == "Y"
                  ? Colors.red.shade50
                  : leave.ispullbackcancelled == "Y"
                      ? Colors.blue.shade50
                      : Colors.white;

              return Card(
                color: backgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Header Row (Avatar + Name + Status + More)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.person_crop_circle,
                                size: 30,
                                color: AppConstants.containercolorArray[
                                    index.remainder(AppConstants
                                        .containercolorArray.length)],
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    leave.intenalId ?? "-",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    "${AppConstants.changeddmmyyformat(leave.createdDate.toString().substring(0, 10)) ?? ""}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              statusPendingColor(text: statusText),
                              (leave.approvalHistory!.isEmpty &&
                                      leave.isstatus == "Pending Approval")
                                  ? (() {
                                      bool isFutureDate = false;

                                      try {
                                        if ((leave.fromdate ?? "").isNotEmpty) {
                                          final fromDate =
                                              DateTime.parse(leave.fromdate!);
                                          final now = DateTime.now();

                                          final today = DateTime(
                                              now.year, now.month, now.day);
                                          final leaveDay = DateTime(
                                              fromDate.year,
                                              fromDate.month,
                                              fromDate.day);

                                          isFutureDate = leaveDay
                                                  .isAfter(today) ||
                                              leaveDay.isAtSameMomentAs(today);
                                        }
                                      } catch (e) {
                                        isFutureDate = false;
                                      }

                                      return isFutureDate
                                          ? GestureDetector(
                                              onTap: () {
                                                uniqId = leave.sId ?? "";
                                                internalId =
                                                    leave.intenalId ?? "";
                                                showCancel(
                                                    context, index, leave);
                                              },
                                              child: const Icon(Icons.more_vert,
                                                  color: Colors.grey),
                                            )
                                          : const SizedBox(width: 0, height: 0);
                                    }())
                                  : const SizedBox(width: 0, height: 0)
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Divider(
                        color: Colors.grey.shade300,
                        height: 1,
                      ),
                      const SizedBox(height: 5),
                      _infoRow("Leave Type", leave.leavetypename ?? "-"),
                      const SizedBox(height: 5),
                      _infoRow("Date Range",
                          "${AppConstants.changeddmmyyformat(leave.fromdate ?? "")} to ${AppConstants.changeddmmyyformat(leave.todate ?? "")}"),
                      const SizedBox(height: 5),
                      _infoRow("Total Days",
                          "${leave.totalNoOfDays} ${leave.totalNoOfDays > 1 ? "days" : "day"}"),
                      const SizedBox(height: 5),
                      _infoRow("Requested By", leave.toEmpName ?? "-"),
                      const SizedBox(height: 5),

                      if (leave.reason != null && leave.reason!.isNotEmpty) ...[
                        const Text("Reason",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 5),
                        Text(
                          leave.reason!,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 5),
                      ],

                      /// Attachment
                      if (leave.imageUrl != null &&
                          leave.imageUrl != "null" &&
                          leave.imageUrl!.isNotEmpty)
                        GestureDetector(
                          //onTap: () => _launchUrl(leave.imageUrl!),
                          onTap: () async {
                            if (leave.imageUrl!.isEmpty) return;

                            final mime =
                                await AppConstants.getMimeType(leave.imageUrl!);
                            final ext = AppConstants.getExtensionFromMime(mime);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ViewFiles(
                                  fileUrl: leave.imageUrl!,
                                  fileName: 'file.$ext',
                                  mimeType: mime,
                                ),
                              ),
                            );
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.attachment,
                                  size: 16, color: Colors.blue),
                              SizedBox(width: 5),
                              Text("View Attachment",
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 12)),
                            ],
                          ),
                        ),

                      const SizedBox(height: 5),

                      /// Approval History
                      if (leave.approvalHistory?.isNotEmpty ?? false)
                        Column(
                          children: [
                            Divider(
                              color: Colors.grey.shade300,
                              height: 1,
                            ),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: const Text("Approval History",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                              trailing:
                                  const Icon(Icons.remove_red_eye, size: 18),
                              onTap: () {
                                showSheet(context, leave);
                              },
                            ),
                          ],
                        ),

                      /// Status Message
                    ],
                  ),
                ),
              );
            })
        : SizedBox(
            height:
                MediaQuery.of(context).size.height * 0.6, // or double.infinity
            child: const Center(child: Text("No Data Found!")),
          );
  }

  /// Helper Widget for title-value pair
  Widget _infoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
        Text(value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget bottomsheetrejectupdate(internalID, dynamic leave) {
    return Card(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            // changed from Wrap to Column
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppUtils.bottomHanger(context),
              const SizedBox(height: 10),
              const Text(
                "Reason for Rejection!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: reasonforRejectionController,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Reason for Rejection!",
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.grey)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Colors.black26, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Close",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolor.primarycolor),
                    onPressed: () {
                      Navigator.pop(context);
                      //updateapproveleave("2", internalID, leave);
                    },
                    child: const Text("Submit",
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void showSheet(context, ViewLeaveModelNew leave) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                AppUtils.gethanger(context),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: leave.approvalHistory!.length,
                  itemBuilder: (BuildContext context, int index1) {
                    final history = leave.approvalHistory![index1];
                    final status = history.status?.toString() ?? "-";
                    final approver = history.approvername?.toString() ?? "-";
                    final approverdept =
                        history.approvalUserType?.toString() ?? "-";
                    final date = history.approveddate?.toString() ?? "-";
                    final remarks = history.remarks?.toString() ?? "-";

                    Color statusColor;
                    IconData statusIcon;
                    switch (status) {
                      case "Approved":
                        statusColor = Colors.green;
                        statusIcon = Icons.check_circle;
                        break;
                      case "Rejected":
                        statusColor = Colors.red;
                        statusIcon = Icons.cancel;
                        break;
                      case "Pending":
                      default:
                        statusColor = Colors.orange;
                        statusIcon = Icons.hourglass_top;
                        break;
                    }

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 4),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Status icon
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: statusColor.withOpacity(0.15),
                                child: Icon(statusIcon,
                                    color: statusColor, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Approver name + Status
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          approver,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: statusColor,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            status,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    remarks.isNotEmpty
                                        ? Text(remarks,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ))
                                        : Container(),
                                    // Date
                                    const SizedBox(height: 6),
                                    if (date.isNotEmpty) ...[
                                      Text(
                                        date,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.grey.shade200,
                          )
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          );
        });
  }

  void onSearchTextChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredLeaveList = leavemodel;
      });
      return;
    }

    final lowerQuery = query.toLowerCase();
    setState(() {
      filteredLeaveList = leavemodel.where((leave) {
        final approver = leave.toEmpName?.toLowerCase() ?? '';
        final applicant = leave.createdByEmpName?.toLowerCase() ?? '';
        final leaveType = leave.leavetypename?.toLowerCase() ?? '';
        final status = leave.isstatus?.toLowerCase() ?? '';
        final reason = leave.reason?.toLowerCase() ?? '';
        return approver.contains(lowerQuery) ||
            applicant.contains(lowerQuery) ||
            leaveType.contains(lowerQuery) ||
            status.contains(lowerQuery) ||
            reason.contains(lowerQuery);
      }).toList();
    });
  }

  void showCancel(context, index, ViewLeaveModelNew leave) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              leave.isstatus == "Approved"
                  ? ListTile(
                      leading: const Icon(Icons.cancel),
                      title: const Text('Cancel Leave'),
                      onTap: () {
                        Navigator.pop(context);
                        _canceldialog(
                          context,
                          cancelleavecontroller,
                        );
                      },
                    )
                  : Container(),
              leave.isstatus == "Pending Approval" &&
                      leave.approvalHistory!.isEmpty
                  ? ListTile(
                      leading: const Icon(Icons.rotate_right),
                      title: const Text('Pull Back Leave'),
                      onTap: () {
                        Navigator.pop(context);
                        _pullbackdialog(context, cancelpullleavecontroller);
                      },
                    )
                  : Container(),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Cancel Dialog'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<void> _canceldialog(
      BuildContext context, cancelleavecontroller) async {
    cancelleavetxt = "";
    cancelleavecontroller.text = "";
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Please Enter Remarks'),
            content: Form(
              key: formKey,
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    cancelleavetxt = value.toString();
                    cancelleavecontroller = value.toString();
                  });
                },
                validator: (value) =>
                    value!.isEmpty ? 'Remarks should not empty!' : null,
                controller: cancelleavecontroller,
                decoration:
                    const InputDecoration(hintText: "Please Cancel Remarks"),
              ),
            ),
            actions: [
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('Cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    final FormState form = formKey.currentState!;
                    if (form.validate()) {
                      Navigator.pop(context);
                      postcancelleave();
                    } else {
                      AppUtils.showSingleDialogPopup(
                          context,
                          "Please Enter Remarks",
                          "ok",
                          exitpopup,
                          AssetsImageWidget.warningimage);
                    }
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> _pullbackdialog(
      BuildContext context, cancelpullleavecontroller) async {
    pullbacktext = "";
    cancelpullleavecontroller.text = "";
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Please Enter Remarks'),
            content: Form(
              key: formKey,
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    pullbacktext = value.toString();
                    cancelpullleavecontroller = value.toString();
                  });
                },
                validator: (value) =>
                    value!.isEmpty ? 'Remarks should not empty!' : null,
                controller: cancelpullleavecontroller,
                decoration:
                    const InputDecoration(hintText: "Please Enter Remarks"),
              ),
            ),
            actions: [
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('Cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    final FormState form = formKey.currentState!;
                    if (form.validate()) {
                      Navigator.pop(context);
                      postpullbackleave();
                    } else {
                      AppUtils.showSingleDialogPopup(
                          context,
                          "Please Enter Remarks",
                          "ok",
                          exitpopup,
                          AssetsImageWidget.warningimage);
                    }
                  });
                },
              ),
            ],
          );
        });
  }

  void exitpopup() {
    Navigator.pop(context);
  }

  void exitwithrefresh() {
    Navigator.of(context).pop();
    getdetailsdata();
  }

  Future<void> _launchUrl(url, {bool isNewTab = true}) async {
    if (Platform.isAndroid) {
      if (!await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalNonBrowserApplication)) {
        throw Exception('Could not launch $url');
      }
    } else if (Platform.isIOS) {
      if (!await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    }
  }

  void postcancelleave() async {
    setState(() {
      loading = true;
    });
    ApiService.cancelleave(internalId, cancelleavetxt, uniqId).then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              exitwithrefresh,
              AssetsImageWidget.successimage);
        } else {
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              onexitpopup,
              AssetsImageWidget.warningimage);
        }
      } else {
        throw Exception(jsonDecode(response.body).toString()).toString();
      }
    }).catchError((e) {
      setState(() {
        loading = false;
      });
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", onexitpopup,
          AssetsImageWidget.errorimage);
    });
  }

  void postpullbackleave() async {
    setState(() {
      loading = true;
    });
    ApiService.pullbackleave(internalId, cancelleavetxt, uniqId)
        .then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              exitwithrefresh,
              AssetsImageWidget.successimage);
        } else {
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              onexitpopup,
              AssetsImageWidget.warningimage);
        }
      } else {
        throw Exception(jsonDecode(response.body).toString()).toString();
      }
    }).catchError((e) {
      setState(() {
        loading = false;
      });
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", onexitpopup,
          AssetsImageWidget.errorimage);
    });
  }

  void getdetailsdata() async {
    setState(() {
      loading = true;
    });

    try {
      final response = await ApiService.viewcompoffleave();
      setState(() {
        loading = false;
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody['status'].toString() == "true") {
          List<dynamic> jsonList =
              responseBody['message']; // get the array from API
          leavemodel =
              jsonList.map((json) => ViewLeaveModelNew.fromJson(json)).toList();

// Sort by internalId descending
          leavemodel.sort((a, b) {
            final idA = int.tryParse(a.intenalId ?? "0") ?? 0;
            final idB = int.tryParse(b.intenalId ?? "0") ?? 0;
            return idB.compareTo(idA); // largest internalId first
          });

          final typesFromApi = leavemodel
              .map((e) => e.leavetypename ?? "")
              .where((name) => name.isNotEmpty)
              .toSet()
              .toList();

          filteredLeaveList = List.from(leavemodel);

          setState(() {
            totalcount = leavemodel.length;
            leaveTypes = [
              "All",
              ...typesFromApi
            ]; // dynamically populate filter
          });
        } else {
          setState(() {
            leavemodel.clear();
            filteredLeaveList.clear();
            leaveTypes = ["All"];
            totalcount = 0;
          });
        }
      } else {
        throw Exception(jsonDecode(response.body).toString());
      }
    } catch (e) {
      if (!mounted) return;
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
    Navigator.of(context).pop();
  }
}
