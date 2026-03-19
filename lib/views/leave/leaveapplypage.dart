import 'package:sjs/models/checkcompoffmodel.dart';
import 'package:sjs/models/leavebalancemodel.dart';
import 'package:sjs/models/leavetypemodel.dart';
import 'package:sjs/services/filepickerservice.dart';
import 'package:sjs/services/uploadservice.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sjs/models/error_model.dart';
import 'package:sjs/models/filemodel.dart';
import 'package:sjs/domain/ApiService.dart';
import 'package:sjs/services/pref.dart';
import 'package:sjs/utils/app_utils.dart';
import 'package:sjs/utils/appcolor.dart';
import 'package:sjs/utils/constants.dart';
import 'package:sjs/utils/sharedprefconstants.dart';
import 'package:sjs/views/widgets/assets_image_widget.dart';
import 'package:sjs/views/widgets/custom_button.dart';
import 'package:sjs/views/widgets/custom_daterange_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as log;

class LeaveApplyPage extends StatefulWidget {
  const LeaveApplyPage({super.key});

  @override
  State<LeaveApplyPage> createState() => _LeaveApplyPageState();
}

class _LeaveApplyPageState extends State<LeaveApplyPage> {
  final leaveTypekey = GlobalKey<DropdownSearchState<LeaveTypeModel>>();
  final balancekey = GlobalKey<DropdownSearchState<LeaveBalanceModel>>();

  LeaveTypeModel? selectedLeaveType;
  LeaveBalanceModel? selectedLeavebalance;

  List<LeaveBalanceModel> leaveBalances = [];
  //List<LeaveTypeModel> leaveTypes = [];

  double? noofdays = 0.00;
  bool? check1 = false;
  bool loading = false;
  ErrorModelNetSuite errormodel = ErrorModelNetSuite();
  GetCountCompOffModel chekcount = GetCountCompOffModel();
  List<String> leavetypelist = [];

  String? alterleavetypecode = "";
  String? alterleavetypename = "";
  double? balancetakenleave = 0;
  String? isairticketrequired = "No";

  DateFormat customdateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  TextEditingController frmdatecontroller = TextEditingController();
  TextEditingController todatecontroller = TextEditingController();

  TextEditingController subfrmdatecontroller = TextEditingController();
  TextEditingController subtodatecontroller = TextEditingController();

  TextEditingController attachcontroller = TextEditingController();
  TextEditingController airticketamountcontroller = TextEditingController();
  TextEditingController reasoncontroller = TextEditingController();
  TextEditingController airticketattachmentcontroller = TextEditingController();

  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();
  final picker = ImagePicker();
  File? imagefile;
  int? selection = 0;

  DateTime? startDate;
  DateTime? endDate;
  List<AttachModel> attachlist = [];

  String attachmentID = "";
  String attachmentURL = "";
  bool isHalfday = false;
  bool isAmPm = false;
  bool isEditable = true;
  String iscompoffid = "";

  bool isValidatefailed = false;
  bool isEndDateEnabled = false;
  @override
  void initState() {
    //loadLeaveData();

    super.initState();
  }

  @override
  void dispose() {
    frmdatecontroller.clear();
    textEditingController.clear();
    todatecontroller.clear();
    attachcontroller.clear();
    subfrmdatecontroller.clear();
    subtodatecontroller.clear();
    airticketamountcontroller.clear();
    airticketattachmentcontroller.clear();
    reasoncontroller.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 20,
        shadowColor: Colors.black54,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AppUtils.buildNormalText(
            text: "Leave Application", color: Colors.black, fontSize: 20),
        centerTitle: true,
      ),
      body: !loading
          ? SingleChildScrollView(
              child: Column(
                children: [getdetails()],
              ),
            )
          : const Center(
              child: CupertinoActivityIndicator(
                  radius: 30.0, color: Appcolor.black),
            ),
    );
  }

  Widget getdetails() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          AppUtils.buildNormalText(text: "LEAVE TYPE"),
          const SizedBox(height: 5),
          DropdownSearch<LeaveTypeModel>(
            key: leaveTypekey,
            selectedItem: selectedLeaveType,
            popupProps: const PopupProps.menu(
              showSearchBox: true,
              interceptCallBacks: true,
            ),
            asyncItems: (String filter) =>
                ApiService.getleaveType(filter: filter, type: "normal"),
            itemAsString: (LeaveTypeModel item) =>
                item.leaveTypeName.toString(),
            onChanged: (LeaveTypeModel? item) async {
              selectedLeaveType = item;

              setState(() {
                loading = true;
              });
              leaveBalances = await ApiService.getleavebalance();
              setState(() {
                loading = false;
              });

              /// ✅ Apply validation
              checkLeaveBalanceSection();

              setState(() {});
            },
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                hintText: 'Leave Type *',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 14),

                // ✅ RECTANGLE border
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero, // <-- No curve
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero, // <-- No curve
                  borderSide: BorderSide(color: Colors.black, width: 1.2),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: AppUtils.buildNormalText(
                  text: selectedLeaveType != null
                      ? '${balancetakenleave!.toStringAsFixed(2).toString()} days Available'
                      : "0 days Available",
                  fontSize: 14,
                  color:
                      balancetakenleave! > 0 ? Colors.green : Colors.redAccent,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 20,
          ),
          Visibility(
            visible: true,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: TextField(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate:
                              DateTime.now().subtract(const Duration(days: 30)),
                          lastDate: DateTime(2100));

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);

                        var dateFormate = DateFormat("dd/MM/yyyy")
                            .format(DateTime.parse(formattedDate));

                        frmdatecontroller.text = dateFormate;
                        subfrmdatecontroller.text = formattedDate;

                        // ✅ Enable end date
                        setState(() {
                          isEndDateEnabled = true;
                        });
                        validatedate(subfrmdatecontroller.text,
                            subtodatecontroller.text);
                      }
                    },
                    controller: frmdatecontroller,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'START DATE ',
                      contentPadding: const EdgeInsets.only(left: 5, right: 5),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            const BorderSide(color: Colors.black26, width: 1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Appcolor.primarycolor,
                          border: Border.all(),
                        ),
                        child: Center(
                          child: AppUtils.buildNormalText(
                              text:
                                  "${noofdays.toString()} ${noofdays == 1.00 ? "day" : "days"}",
                              fontSize: 14,
                              color: Colors.white),
                        ))),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 4,
                  child: TextField(
                    onTap: () async {
                      if (!isEndDateEnabled) {
                        AppUtils.showSingleDialogPopup(
                            context,
                            "Please choose Start Date first",
                            "Ok",
                            onexitpopup,
                            AssetsImageWidget.warningimage);
                        return;
                      }

                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate:
                            startDate, // ✅ Calendar opens from start date
                        firstDate: subfrmdatecontroller.text == ""
                            ? DateTime.now()
                            : DateTime.parse(subfrmdatecontroller
                                .text), // ✅ Cannot pick before start date
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);

                        var dateFormate = DateFormat("dd/MM/yyyy")
                            .format(DateTime.parse(formattedDate));

                        todatecontroller.text = dateFormate;
                        subtodatecontroller.text = formattedDate;

                        validatedate(subfrmdatecontroller.text,
                            subtodatecontroller.text);
                      }
                    },
                    readOnly: true,
                    controller: todatecontroller,
                    decoration: InputDecoration(
                      labelText: 'END DATE',
                      contentPadding: const EdgeInsets.only(left: 5, right: 5),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            const BorderSide(color: Colors.black26, width: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 2,
                child: CupertinoSwitch(
                  value: isHalfday,
                  onChanged: isEditable
                      ? (value) {
                          setState(() {
                            if (noofdays! > 1.0 && value) {
                              AppUtils.showSingleDialogPopup(
                                  context,
                                  "You cannot select half day for more than one day leave",
                                  "Ok",
                                  onexitpopup,
                                  AssetsImageWidget.warningimage);
                              return;
                            }

                            isHalfday = value;
                            noofdays = value ? 0.5 : 1.0;
                          });
                        }
                      : null,
                ),
              ),
              Expanded(
                  flex: 3, child: AppUtils.buildNormalText(text: "Half day")),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: CupertinoSwitch(
                  value: isAmPm,
                  onChanged: isEditable
                      ? (value) {
                          setState(() {
                            isAmPm = value;
                          });
                        }
                      : null,
                ),
              ),
              Expanded(
                  flex: 3,
                  child: AppUtils.buildNormalText(
                      text: isAmPm ? "Forward Noon" : "Afternoon")),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
              visible: isValidatefailed ? true : false,
              child: const Text(
                  'You cannot request leave for holidays or weekly offs.',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold))),
          const SizedBox(
            height: 10,
          ),
          AppUtils.buildNormalText(text: "Leave Reason", fontSize: 15),
          const SizedBox(
            height: 10,
          ),
          Container(
              //padding: EdgeInsets.all(20),
              child: TextField(
            controller: reasoncontroller,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Enter Reason",
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.grey)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.black26, width: 1),
              ),
            ),
          )),
          const SizedBox(height: 20),
          AppUtils.buildNormalText(text: "Attachment", fontSize: 15),
          const SizedBox(
            height: 10,
          ),
          TextField(
            readOnly: true,
            controller: attachcontroller,
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              hintText: "Click here to Attach file (file Size Max 2 MB)",
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.attach_file,
                  color: Colors.black,
                ),
                onPressed: () async {
                  AppUtils.showBottomCupertinoDialog(context,
                      title: "Choose any one option", btn1function: () async {
                    AppUtils.pop(context);
                    _captureCameraImage();
                  }, btn2function: () {
                    AppUtils.pop(context);
                    _pickFile();
                  });
                },
              ),
            ),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(
            height: 30,
          ),
          Visibility(
            visible: isairticketrequired.toString() == "Yes" ? true : false,
            child: Column(
              children: [
                AppUtils.buildNormalText(
                    text: "AirTicket Details",
                    fontSize: 20,
                    color: Appcolor.twitterBlue),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                          fillColor:
                              WidgetStateProperty.all(Appcolor.twitterBlue),
                          checkColor: Colors.white,
                          value: check1,
                          shape: const CircleBorder(),
                          onChanged: (bool? value) {
                            setState(() {
                              check1 = value!;
                            });
                          },
                        )),
                    AppUtils.buildNormalText(
                        text: "Air Ticket Required", fontSize: 15),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: airticketamountcontroller,
                    decoration: const InputDecoration(
                      labelText: 'Air Ticket Amount ',
                    ),
                    keyboardType: TextInputType.number),
                const SizedBox(height: 20),
                TextField(
                  readOnly: true,
                  controller: airticketattachmentcontroller,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText:
                        "Click here to Air Ticket Attach file(file Size Max 2 MB)",
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.attach_file_sharp,
                        color: Colors.black,
                      ),
                      onPressed: () async {
                        Map<Permission, PermissionStatus> statuses = await [
                          Permission.camera,
                        ].request();
                        statuses.values.forEach((element) async {
                          if (element.isDenied || element.isPermanentlyDenied) {
                            await openAppSettings();
                          }
                        });
                        AppUtils.showBottomCupertinoDialog(context,
                            title: "Choose any one option",
                            btn1function: () async {
                          AppUtils.pop(context);
                          // getImageFromCameraAirticket(
                          //     airticketattachmentcontroller);
                        }, btn2function: () {
                          AppUtils.pop(context);
                          // pickFilesairticket(airticketattachmentcontroller);
                        });
                      },
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            onPressed: () {
              if (alterleavetypecode!.isEmpty) {
                AppUtils.showSingleDialogPopup(
                    context,
                    "Please Select Leave Type",
                    "Ok",
                    onexitpopup,
                    AssetsImageWidget.warningimage);
              } else if (frmdatecontroller.text.isEmpty) {
                AppUtils.showSingleDialogPopup(
                    context,
                    "Please  Choose from date",
                    "Ok",
                    onexitpopup,
                    AssetsImageWidget.warningimage);
              } else if (todatecontroller.text.isEmpty) {
                AppUtils.showSingleDialogPopup(context, "Please  Choose todate",
                    "Ok", onexitpopup, AssetsImageWidget.warningimage);
              } else if (reasoncontroller.text.isEmpty) {
                AppUtils.showSingleDialogPopup(context, "Please  Enter Reason",
                    "Ok", onexitpopup, AssetsImageWidget.warningimage);
              } else if (attachlist.isEmpty) {
                attachlist.clear();
                onpostleave();
              } else {
                onUpload();
              }
            },
            name: "Submit",
            circularvalue: 30,
            fontSize: 14,
          )
        ],
      ),
    );
  }

  Future<void> _captureCameraImage() async {
    final attach = await CameraImageService.instance.getImageFromCamera();
    if (attach != null) {
      setState(() {
        attachlist.clear();
        attachlist.add(attach);
        attachcontroller.text = attach.fileName ?? '';
      });
      //upload
    }
  }

  Future<void> _pickFile() async {
    final attach = await CameraImageService.instance.pickFile();
    if (attach != null) {
      setState(() {
        attachlist.clear();
        attachlist.add(attach);
        attachcontroller.text = attach.fileName ?? '';
      });
    }
  }

  void onUpload() async {
    setState(() => loading = true);

    final result =
        await UploadService.instance.uploadAttachment(context, attachlist);

    setState(() => loading = false);

    if (result != null && result['status'] == true) {
      attachmentID = result['fileId'];
      attachmentURL = result['url'];
      onpostleave(); // your existing next step
    }
  }

  void showdaterange() {
    showCustomDateRangePicker(
      context,
      dismissible: true,
      minimumDate: DateTime.now(),
      //maximumDate: DateTime.now().add(const Duration(days: 90)),
      maximumDate: DateTime(DateTime.now().year, 12, 31),
      endDate: endDate,
      startDate: startDate,
      backgroundColor: Colors.white,
      primaryColor: Appcolor.black,
      onApplyClick: (start, end) {
        setState(() {
          endDate = end;
          startDate = start;
          frmdatecontroller.text = "";
          todatecontroller.text = "";
          subfrmdatecontroller.text = "";
          subtodatecontroller.text = "";

          String formattedDate = DateFormat('yyyy-MM-dd').format(start);
          var dateFormate =
              DateFormat("dd-MM-yyyy").format(DateTime.parse(formattedDate));
          frmdatecontroller.text = dateFormate;
          subfrmdatecontroller.text = formattedDate;

          String formattedDate1 = DateFormat('yyyy-MM-dd').format(end);
          var dateFormate1 =
              DateFormat("dd-MM-yyyy").format(DateTime.parse(formattedDate1));
          todatecontroller.text = dateFormate1;
          subtodatecontroller.text = formattedDate1;
          validatedate(subfrmdatecontroller.text, subtodatecontroller.text);
          setState(() {
            selection = 3;
          });
        });
      },
      onCancelClick: () {
        setState(() {
          endDate = null;
          startDate = null;
        });
      },
    );
  }

  void validatedate(from, to) {
    if (from.toString().isNotEmpty && to.toString().isNotEmpty) {
      String concatefrom = '${subfrmdatecontroller.text} 00:00:00';
      String concateto = '${subtodatecontroller.text} 00:00:00';

      DateTime dt1 = DateTime.parse(concatefrom);
      DateTime dt2 = DateTime.parse(concateto);

      Duration diff = dt2.difference(dt1);

      if (diff.inDays >= 0) {
        print(from);
        print(to);
        if (alterleavetypecode.toString().isNotEmpty &&
            from.toString().isNotEmpty &&
            to.toString().isNotEmpty) {
          validationfromandtodate(
              AppConstants.formatDateleave(from),
              AppConstants.formatDateleave(to),
              alterleavetypecode!.toString(),
              Prefs.getEmpID(SharefprefConstants.sharednsid).toString());
        }
      } else {
        frmdatecontroller.clear();
        todatecontroller.clear();
        subfrmdatecontroller.clear();
        subtodatecontroller.clear();
        from = "";
        to = "";
        AppUtils.showSingleDialogPopup(
            context,
            'From date and To Date is Mismatched!',
            "Ok",
            onexitpopup,
            AssetsImageWidget.errorimage);
      }
    } else {}
  }

  void oncleardate() {
    AppUtils.pop(context);
    frmdatecontroller.clear();
    todatecontroller.clear();
    subfrmdatecontroller.clear();
    subtodatecontroller.clear();

    frmdatecontroller.text = "";
    todatecontroller.text = "";
    subfrmdatecontroller.text = "";
    subtodatecontroller.text = "";
    noofdays = 0;
    selection = 0;
    startDate = null;
    endDate = null;
    setState(() {});
  }

  void onexitpopup() {
    Navigator.of(context).pop();
  }

  void checkLeaveBalanceSection() {
    final item = selectedLeaveType;

    if (item == null) return;

    /// ✅ Half-day allowed?
    isEditable = item.allowhalfday == "T";

    /// ✅ Match leave balance for that type
    final match = leaveBalances.firstWhere(
      (e) => e.leaveTypeId.toString() == item.leaveTypeId.toString(),
      orElse: () => LeaveBalanceModel(
        internalId: "",
        empId: "",
        employeeName: "",
        leaveTypeId: "",
        leaveTypeName: "",
        yearlyLeaveBalance: "0",
        leaveBalanceCredited: "0",
        leaveBalanceTaken: "0",
        totalAppliedDays: "0",
        availableLeaveBalance: "0",
      ),
    );

    balancetakenleave = double.tryParse(match.availableLeaveBalance) ?? 0;

    alterleavetypecode = item.leaveTypeId.toString();
    alterleavetypename = item.leaveTypeName.toString();

    /// ✅ Clear date fields
    frmdatecontroller.clear();
    todatecontroller.clear();
    subfrmdatecontroller.clear();
    subtodatecontroller.clear();
  }

  void onrefreshscreen() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void onpostleave() async {
    DateTime now = DateTime.now();
    //DateTime currentyear = DateTime(now.year);
    var currentyear = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
    var json = {
      "leaveapplicationno":
          "${"Mob"}-Leave-${Prefs.getEmpID('empID').toString()}-$currentyear",
      "date": ApiService.mobilecurrentdate,
      "leavetypecode": alterleavetypecode,
      "leavetypename": alterleavetypename,
      "leavebalance": balancetakenleave,
      "fromdate": subfrmdatecontroller.text,
      "todate": subtodatecontroller.text,
      "total_no_of_days": noofdays ?? 0,
      "halfday": isHalfday ? "Y" : "N",
      "halfdaysession": isAmPm ? "AN" : "FN",
      "attachment": attachlist.isEmpty ? "" : attachlist,
      "reason": reasoncontroller.text,
      "airticketrequired": isairticketrequired,
      "airticketamount": airticketamountcontroller.text.isEmpty
          ? 0
          : airticketamountcontroller.text,
      "airticketattachment": airticketattachmentcontroller.text.isEmpty
          ? ""
          : 'public/${attachcontroller.text.toString()}',
      "iscancelled": "N",
      "iscancelledreason": "",
      "iscancelleddate": "",
      "isstatus": "Pending Approval",
      "createdby": Prefs.getNsID('nsid'),
      "createdByEmpName": Prefs.getFullName('Name'),
      "createdDate": ApiService.mobilecurrentdate,
      "toEmpID": Prefs.getNsID('nsid'),
      "toEmpCode": Prefs.getEmpID(
        SharefprefConstants.sharedempId,
      ),
      "toEmpName": Prefs.getFullName('Name'),
      "isSync": 0,
      "NetsuiteRefNo": "",
      "NetsuiteRemarks": "",
      "Source": "Mob",
      "attachDocument": attachlist.isEmpty ? "F" : "T",
      "imageUrl": attachmentURL,
      "supervisorId": "",
      "linemanagerId": "",
      "hodId": "",
    };
    log.log('data: ${jsonEncode(json)}');
    setState(() {
      loading = true;
    });
    ApiService.postleave(json).then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              onrefreshscreen,
              AssetsImageWidget.successimage);

          setState(() {});
        } else {
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              onexitpopup,
              AssetsImageWidget.warningimage);
        }
      } else {
        AppUtils.showSingleDialogPopup(
            context,
            jsonDecode(response.body)['message'],
            "Ok",
            onexitpopup,
            AssetsImageWidget.warningimage);
      }
    }).catchError((e) {
      setState(() {
        loading = false;
      });
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", onexitpopup,
          AssetsImageWidget.errorimage);
    });
  }

  void validationfromandtodate(
      String fromdate, String todate, String leavetypeId, String nsId) async {
    if (!mounted) return;

    setState(() => loading = true);

    try {
      final response =
          await ApiService.validatedate(fromdate, todate, leavetypeId, nsId);

      setState(() => loading = false);

      if (response.statusCode != 200) {
        throw Exception("Server Error");
      }

      final responseBody = jsonDecode(response.body);

      // ✅ Your Node returns "success"
      if (responseBody['success'] != true) {
        AppUtils.showSingleDialogPopup(
          context,
          responseBody['message'] ?? "Something went wrong",
          "Ok",
          onexitpopup,
          AssetsImageWidget.errorimage,
        );
        return;
      }

      // ✅ Extract messages list safely
      final messages = responseBody["payload"];
      List<String> msgList = [];

      if (messages is List) {
        msgList = messages.map((e) => e.toString()).toList();
      }

      // ✅ CASE 1: No messages → Normal day → success
      if (msgList.isEmpty) {
        final finalDaysValue = responseBody['finaldays'] ?? 0;
        setState(() {
          noofdays = finalDaysValue.toDouble();
          isValidatefailed = false;
        });
        return;
      }

      // ✅ CASE 2: Parse status lines
      String? fromStatus;
      String? toStatus;

      for (var line in msgList) {
        if (line.startsWith(fromdate)) {
          fromStatus = line.split(" - ").last.trim().toLowerCase();
        }
        if (line.startsWith(todate)) {
          toStatus = line.split(" - ").last.trim().toLowerCase();
        }
      }

      fromStatus ??= "invalid";
      toStatus ??= "invalid";

      // ✅ CASE 3: Fail condition
      if (fromStatus != "normal" || toStatus != "normal") {
        setState(() {
          noofdays = 0.00;
          isValidatefailed = true;
        });

        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Leave Validation"),
            content: Text(
              "You cannot apply leave on:\n\n"
              "• $fromdate → ${fromStatus.toString().toUpperCase()}\n"
              "• $todate → ${toStatus.toString().toUpperCase()}",
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text("OK"))
            ],
          ),
        );

        return;
      }

      // ✅ CASE 4: Success
      final finalDaysValue = responseBody['finaldays'] ?? 0;
      setState(() {
        noofdays = finalDaysValue.toDouble();
        isValidatefailed = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => loading = false);
        AppUtils.showSingleDialogPopup(
          context,
          e.toString(),
          "Ok",
          onexitpopup,
          AssetsImageWidget.errorimage,
        );
      }
    }
  }

  void exitalert() {
    Navigator.of(context).pop();
  }
}
