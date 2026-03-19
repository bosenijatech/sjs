import 'dart:convert';
import 'dart:io';

import 'package:winstar/services/filepickerservice.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winstar/models/approveleavemodel.dart';
import 'package:winstar/models/filemodel.dart';
import 'package:winstar/domain/ApiService.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/appcolor.dart';
import 'package:winstar/utils/sharedprefconstants.dart';
import 'package:winstar/views/widgets/assets_image_widget.dart';
import 'package:winstar/views/widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class DutyResumption extends StatefulWidget {
  ViewLeaveApproveModel model;
  int position = 0;
  DutyResumption({super.key, required this.model, required this.position});

  @override
  State<DutyResumption> createState() => _DutyResumptionState();
}

TextEditingController _resumptiondatecontroller = TextEditingController();
TextEditingController _actualresumptiondatecontroller = TextEditingController();
TextEditingController _tempresumptiondatecontroller = TextEditingController();
TextEditingController _tempactualresumptiondatecontroller =
    TextEditingController();
TextEditingController _reasoncontroller = TextEditingController();
TextEditingController _totalnoofdayscontroller = TextEditingController();
TextEditingController _attachcontroller = TextEditingController();
int noofdays = 0;
String isLeaveExtended = "No";

class _DutyResumptionState extends State<DutyResumption>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 4));
  bool loading = false;
  bool isworkResume = false;
  bool isresumptionisdone = false;
  List<AttachModel> attachlist = [];
  final picker = ImagePicker();
  File? imagefile;

  String attachmentID = "";
  String attachmentURL = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(CupertinoIcons.back, color: Colors.black),
            onPressed: () {
              clearvalus();
              Navigator.of(context).pop();
            }),
        title: AppUtils.buildNormalText(
            text: "Duty Resumption", color: Colors.black, fontSize: 20),
        centerTitle: true,
      ),
      body: !loading
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [headerLayout(), buildlayout()],
              ),
            )
          : const Center(
              child: CupertinoActivityIndicator(
                  radius: 30.0, color: Color.fromARGB(255, 14, 14, 17)),
            ),
      persistentFooterButtons: [
        CustomButton(
          onPressed: () {
            if (_resumptiondatecontroller.text.isEmpty) {
              AppUtils.showSingleDialogPopup(
                  context,
                  "Date Should not Left Empty!",
                  "OK",
                  onexitpopup,
                  AssetsImageWidget.warningimage);
            } else if (_actualresumptiondatecontroller.text.isEmpty) {
              AppUtils.showSingleDialogPopup(
                  context,
                  "Actual Date Should not Left Empty!",
                  "OK",
                  onexitpopup,
                  AssetsImageWidget.warningimage);
            } else if (attachmentID.isNotEmpty && attachmentURL.isNotEmpty) {
              onpostdutyresumption();
            } else if (attachlist.isEmpty) {
              onpostdutyresumption();
            } else {
              onupload();
            }
          },
          name: "Submit",
          circularvalue: 30,
          fontSize: 16,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _resumptiondatecontroller.dispose();
    _actualresumptiondatecontroller.dispose();
    _tempresumptiondatecontroller.dispose();
    _tempactualresumptiondatecontroller.dispose();
    _reasoncontroller.dispose();
    _totalnoofdayscontroller.dispose();
    _attachcontroller.dispose();
    loading = false;
  }

  clearvalus() {
    _resumptiondatecontroller.dispose();
    _actualresumptiondatecontroller.dispose();
  }

  void pickerdate(controller, type) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(
            "${widget.model.data![widget.position].todate.toString()} 00:00:00"),
        // firstDate: DateTime.parse(
        //     "${widget.model.message![widget.position].todate.toString()} 00:00:00"), //.subtract(Duration(days: 1)),
        firstDate: DateTime.parse(
            "${widget.model.data![widget.position].todate.toString()} 00:00:00"),
        lastDate: DateTime(2100));

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      var dateFormate =
          DateFormat("dd/MM/yyyy").format(DateTime.parse(formattedDate));

      controller.text = dateFormate;

      if (type == "1") {
        _tempresumptiondatecontroller.text = formattedDate;
      } else {
        _tempactualresumptiondatecontroller.text = formattedDate;
      }
      if (_tempresumptiondatecontroller.text.isNotEmpty &&
          _tempactualresumptiondatecontroller.text.isNotEmpty) {
        validatedate(_tempresumptiondatecontroller.text.isNotEmpty,
            _tempactualresumptiondatecontroller.text);
      }
    }
  }

  Widget headerLayout() {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppUtils.buildNormalText(text: "Internal ID ", fontSize: 14),
                AppUtils.buildNormalText(
                    text: widget.model.data![widget.position].internalid,
                    fontSize: 14),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppUtils.buildNormalText(text: "Leave Type", fontSize: 14),
                AppUtils.buildNormalText(
                    text: widget.model.data![widget.position].leavetypename,
                    fontSize: 14),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppUtils.buildNormalText(
                    text: "Total No.of.Days", fontSize: 14),
                AppUtils.buildNormalText(
                    text: widget.model.data![widget.position].totalNoOfDays
                        .toString(),
                    fontSize: 14)
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppUtils.buildNormalText(text: "Leave Balance", fontSize: 14),
                AppUtils.buildNormalText(
                    text: widget.model.data![widget.position].leavebalance
                        .toString(),
                    fontSize: 14)
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppUtils.buildNormalText(text: "From Date", fontSize: 14),
                AppUtils.buildNormalText(text: "To Date", fontSize: 14)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppUtils.buildNormalText(
                    text:
                        widget.model.data![widget.position].fromdate.toString(),
                    fontSize: 14),
                AppUtils.buildNormalText(
                    text: widget.model.data![widget.position].todate.toString(),
                    fontSize: 14)
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppUtils.buildNormalText(text: "Leave Reason", fontSize: 14),
                AppUtils.buildNormalText(
                    text: widget.model.data![widget.position].reason.toString(),
                    fontSize: 14)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildlayout() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          AppUtils.buildNormalText(text: "Expected Resume Back Date"),
          const SizedBox(height: 5),
          TextFormField(
            readOnly: true,
            controller: _resumptiondatecontroller,
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            onTap: () {
              // FocusScope.of(context).requestFocus(FocusNode());
              // showDemoDialog(context: context);
              pickerdate(_resumptiondatecontroller, "1");
            },
            decoration: InputDecoration(
              hintText: "Date",
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.grey)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:
                      const BorderSide(color: Colors.black26, width: 1)),
            ),
          ),
          const SizedBox(height: 10),
          CheckboxListTile(
              dense: true,
              contentPadding: const EdgeInsets.all(0),
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Work Resume?'),
              autofocus: false,
              activeColor: Colors.black,
              checkColor: Colors.white,
              selected: isworkResume,
              value: isworkResume,
              onChanged: (value) {
                setState(() {
                  isworkResume = value!;
                });
              }),
          AppUtils.buildNormalText(text: "Is Leave Extended?", fontSize: 14),
          const SizedBox(
            height: 10,
          ),
          DropdownSearch<String>(
            popupProps: const PopupProps.menu(
              showSearchBox: true,
              showSelectedItems: true,
            ),
            items: const ['Yes', 'No'],
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                hintText: '',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: Appcolor.primarycolor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: Appcolor.primarycolor, width: 1),
                ),
              ),
            ),
            onChanged: (val) {
              setState(() {
                isLeaveExtended = val.toString();
              });
            },
            selectedItem: isLeaveExtended,
          ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
              visible: isLeaveExtended.toString() == "Yes" ? true : false,
              child:
                  AppUtils.buildNormalText(text: "Actual Work Resume date?")),
          const SizedBox(height: 5),
          Visibility(
            visible: isLeaveExtended.toString() == "Yes" ? true : false,
            child: TextFormField(
              readOnly: true,
              controller: _actualresumptiondatecontroller,
              keyboardType: TextInputType.multiline,
              maxLines: 1,
              onTap: () {
                // FocusScope.of(context).requestFocus(FocusNode());
                // showDemoDialog(context: context);
                pickerdate(_actualresumptiondatecontroller, "2");
              },
              decoration: InputDecoration(
                hintText: "Date",
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.grey)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.black26, width: 1),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
              visible: isLeaveExtended.toString() == "Yes" ? true : false,
              child: AppUtils.buildNormalText(text: "No of Days")),
          const SizedBox(height: 5),
          Visibility(
            visible: isLeaveExtended.toString() == "Yes" ? true : false,
            child: TextFormField(
              readOnly: true,
              controller: _totalnoofdayscontroller,
              keyboardType: TextInputType.multiline,
              maxLines: 1,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                hintText: "No Of Days",
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.grey)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.black26, width: 1),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          CheckboxListTile(
              dense: true,
              contentPadding: const EdgeInsets.all(0),
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Work Resumption Done?'),
              autofocus: false,
              activeColor: Colors.black,
              checkColor: Colors.white,
              selected: isresumptionisdone,
              value: isresumptionisdone,
              onChanged: (value) {
                setState(() {
                  isresumptionisdone = value!;
                });
              }),
          const SizedBox(
            height: 10,
          ),
          AppUtils.buildNormalText(text: "Attachment", fontSize: 14),
          const SizedBox(
            height: 5,
          ),
          TextField(
            readOnly: true,
            controller: _attachcontroller,
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
        _attachcontroller.text = attach.fileName ?? '';
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
        _attachcontroller.text = attach.fileName ?? '';
      });
    }
  }

  void validatedate(from, to) {
    if (from.toString().isNotEmpty && to.toString().isNotEmpty) {
      String concatefrom = '${_tempresumptiondatecontroller.text} 00:00:00';
      String concateto = '${_tempactualresumptiondatecontroller.text} 00:00:00';

      DateTime dt1 = DateTime.parse(concatefrom);
      DateTime dt2 = DateTime.parse(concateto);

      Duration diff = dt2.difference(dt1);

      if (diff.inDays >= 0) {
        setState(() {
          noofdays = diff.inDays;
          _totalnoofdayscontroller.text = noofdays.toString();
        });
      } else {
        _tempresumptiondatecontroller.clear();
        _tempactualresumptiondatecontroller.clear();
        _resumptiondatecontroller.clear();
        _actualresumptiondatecontroller.clear();
        AppUtils.showSingleDialogPopup(
            context,
            'From date and To Date is Mismatched!',
            "Ok",
            onexitpopup,
            AssetsImageWidget.errorimage);
      }
    } else {}
  }

  void onpostdutyresumption() async {
    DateTime now = DateTime.now();
    DateTime currentyear = DateTime(now.year);

    var json = {
      "Leaveinternalid": widget.model.data![widget.position].internalid,
      "date": ApiService.mobilecurrentdate,
      "employeenumber": Prefs.getNsID(
        SharefprefConstants.sharednsid,
      ),
      "employeename": Prefs.getFirstName(
        SharefprefConstants.shareFirstName,
      ),
      "designation": Prefs.getDesignation(
        SharefprefConstants.shareddesignation,
      ),
      "location": "",
      "dept": Prefs.getDept(
        SharefprefConstants.shareddept,
      ),
      "resumptiondate": _resumptiondatecontroller.text.toString(),
      "actualresumptiondate": _actualresumptiondatecontroller.text.toString(),
      "expectedResumeBackDate": _resumptiondatecontroller.text,
      "workResume": isworkResume == true ? "Yes" : "No",
      "isLeaveExtended": isLeaveExtended,
      "actualWorkResumeDate": _actualresumptiondatecontroller.text,
      "actualTotalResumeDelayDays": _totalnoofdayscontroller.text,
      "workResumptionDone": isresumptionisdone == true ? "Yes" : "No",
      "createdby": Prefs.getNsID('nsid'),
      "createdbyName": Prefs.getFullName('Name'),
      "createdDate": ApiService.mobilecurrentdate,
      "Source": "Mob",
      "leaveType": widget.model.data![widget.position].leavetypecode,
      attachmentURL.isEmpty ? "" : "attachmentURL": attachmentURL,
      attachmentID.isEmpty ? "" : "attachmentID": attachmentID
    };

    setState(() {
      loading = true;
    });
    ApiService.onpostdutyresumption(json).then((response) {
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
        throw Exception(jsonDecode(response.body)['message'].toString());
      }
    }).catchError((e) {
      setState(() {
        loading = false;
      });
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", onexitpopup,
          AssetsImageWidget.errorimage);
    });
  }

  dateTimeFormet(date) {
    return DateFormat('dd-MM-yyyy').format(date); // you can set your formet
  }

  void onexitpopup() {
    Navigator.of(context).pop();
  }

  void onrefreshscreen() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void onupload() async {
    var body = {
      "attachment": [
        {
          "FileData": attachlist[0].fileData.toString(),
          "FileType": attachlist[0].fileType.toString(),
          "FileName": attachlist[0].fileName.toString()
        }
      ]
    };
    setState(() {
      loading = true;
    });
    ApiService.postattachment(body).then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          attachmentID = jsonDecode(response.body)['fileId'].toString();
          attachmentURL = jsonDecode(response.body)['url'].toString();
          attachlist[0].fileData = attachmentID;
          onpostdutyresumption();
        } else {
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              onexitpopup,
              AssetsImageWidget.warningimage);
        }
      } else {
        throw Exception(jsonDecode(response.body)['message'].toString());
      }
    }).catchError((e) {
      setState(() {
        loading = false;
      });
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", onexitpopup,
          AssetsImageWidget.errorimage);
    });
  }
}
