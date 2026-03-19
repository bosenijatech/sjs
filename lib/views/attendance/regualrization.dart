import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:sjs/models/filemodel.dart';
import 'package:sjs/domain/ApiService.dart';
import 'package:sjs/services/pref.dart';
import 'package:sjs/utils/app_utils.dart';
import 'package:sjs/utils/appcolor.dart';
import 'package:sjs/utils/constants.dart';
import 'package:sjs/views/widgets/assets_image_widget.dart';
import 'package:sjs/views/widgets/custom_button.dart';

class ApplyReqularization extends StatefulWidget {
  final String id;
  final String docdate;
  final String checkIn;
  final String checkOut;
  const ApplyReqularization(
      {super.key,
      required this.id,
      required this.docdate,
      required this.checkIn,
      required this.checkOut});

  @override
  State<ApplyReqularization> createState() => _ApplyReqularizationState();
}

class _ApplyReqularizationState extends State<ApplyReqularization> {
  TextEditingController fromtimeController = TextEditingController();
  TextEditingController totimeController = TextEditingController();

  TextEditingController reginController = TextEditingController();
  TextEditingController reqoutController = TextEditingController();

  TextEditingController attachcontroller = TextEditingController();
  TextEditingController reasoncontroller = TextEditingController();
  TextEditingController datepickercontroller = TextEditingController();

  List<String> files = [];
  List<File> filelist = [];
  List<PlatformFile>? _paths;

  String attachmentID = "";
  String attachmentURL = "";

  File? imagefile;
  bool loading = false;
  List<AttachModel> attachlist = [];
  final picker = ImagePicker();

  @override
  void initState() {
    if (widget.id.toString().isEmpty) {
      fromtimeController.text = "";
      totimeController.text = "";
      reginController.text = "";
      reqoutController.text = "";
      datepickercontroller.text = widget.docdate;
    } else {
      fromtimeController.text = widget.checkIn.toString();
      totimeController.text = widget.checkOut.toString();
      print(widget.checkIn);
      print(widget.checkOut);
      datepickercontroller.text = widget.docdate;
      reginController.text = "";
      reqoutController.text = "";
    }
    super.initState();
  }

  @override
  void dispose() {
    fromtimeController.clear();
    totimeController.clear();
    attachcontroller.clear();
    reasoncontroller.clear();
    reginController.clear();
    reqoutController.clear();
    datepickercontroller.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.clear, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AppUtils.buildNormalText(
          text: widget.id.toString().isNotEmpty
              ? "Reqularization Request \n  Req Date : ${widget.docdate}"
              : "Reqularization Request",
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: !loading
          ? SingleChildScrollView(
              child: Column(
                children: [getregularization()],
              ),
            )
          : Center(
              child: CupertinoActivityIndicator(
                  radius: 30.0, color: Appcolor.primarycolor),
            ),
    );
  }

  Widget getregularization() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  enabled: widget.id.toString().isEmpty ? true : false,
                  readOnly: true,
                  controller: datepickercontroller,
                  maxLength: 100,
                  onTap: () async {
                    pickerdate(datepickercontroller);
                  },
                  decoration: const InputDecoration(
                    counterText: '',
                    labelText: 'Choose Date',
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: TextField(
                  readOnly: true,
                  enabled: false,
                  controller: fromtimeController,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    counterText: '',
                    labelText: 'From Time',
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: TextField(
                  readOnly: true,
                  enabled: false,
                  controller: totimeController,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    counterText: '',
                    labelText: 'To Time',
                  ),
                ),
              )
            ],
          ),
          TextField(
            readOnly: true,
            controller: reginController,
            maxLength: 100,
            onTap: () async {
              pickertime(reginController);
            },
            decoration: const InputDecoration(
              counterText: '',
              labelText: 'From Time',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            readOnly: true,
            controller: reqoutController,
            maxLength: 100,
            onTap: () {
              pickertime(reqoutController);
            },
            decoration: const InputDecoration(
              counterText: '',
              labelText: 'To Time',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          AppUtils.buildNormalText(text: "Reason", fontSize: 15),
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
                borderRadius: BorderRadius.circular(1.0),
                borderSide: const BorderSide(color: Colors.black26, width: 1),
              ),
            ),
          )),
          const SizedBox(
            height: 20,
          ),
          CustomButton(
            onPressed: () {
              if (reginController.text.isEmpty) {
                AppUtils.showSingleDialogPopup(context,
                    "Please Select From Time", "Ok", onexitpopup, null);
              } else if (reqoutController.text.isEmpty) {
                AppUtils.showSingleDialogPopup(
                    context, "Please Select To Time", "Ok", onexitpopup, null);
              } else {
                onApplyRegularization();
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

  void onexitpopup() {
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
          onApplyRegularization();
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

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      imagefile = File(pickedFile.path);

      final bytes = imagefile!.readAsBytesSync().lengthInBytes;
      final kb = bytes / 1024;
      final mb = kb / 1024;

      Random random = Random();
      int randomnumber = random.nextInt(100);

      File imageFile = File(pickedFile.path);

      Uint8List bytes0 = await imageFile.readAsBytes();
      String base64String = base64Encode(bytes0);
      attachcontroller.text = pickedFile.path.toString().split("/").last;
      attachlist.clear();
      print(AppConstants.getFileTypeExtension(pickedFile.path.toString()));
      attachlist.add(AttachModel(
          randomnumber.toString(),
          base64String,
          AppConstants.getFileTypeExtension(pickedFile.path.toString()) ==
                  ".jpg"
              ? "jpg"
              : AppConstants.getFileTypeExtension(pickedFile.path.toString()) ==
                      ".jpeg"
                  ? "jpeg"
                  : AppConstants.getFileTypeExtension(
                      pickedFile.path.toString()),
          pickedFile.path.toString().split("/").last,
          mb.toStringAsFixed(3).toString()));

      setState(() {});
    } else {
      attachlist.clear();
      print('No image selected.');
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: true,
      allowMultiple: false,
      allowCompression: true,
      allowedExtensions: [
        'png',
        'jpg',
        'jpeg',
        'pdf',
        // 'doc',
        // 'docx',
        // 'xls',
      ],
    );
    Random random = Random();
    int randomnumber = random.nextInt(100);
    if (result != null && result.files.single.path != null) {
      PlatformFile file = result.files.first;

      File file0 = File(result.files.single.path!);
      String file64 = "";
      setState(() async {
        if (file.extension.toString() == "pdf") {
          attachcontroller.text = file0.path;
          final bytes = File(file0.path).readAsBytesSync();
          file64 = base64Encode(bytes);
        } else {
          //Image
          attachcontroller.text = file0.path.toString();
          Uint8List bytes0 = await file0.readAsBytes();
          file64 = base64Encode(bytes0);
        }

        attachlist.clear();

        attachlist.add(AttachModel(randomnumber.toString(), file64,
            file.extension, file.name, file.size.toString()));
      });
    } else {
      /// User canceled the picker
    }
  }

  void pickerdate(controller) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        //Current month only show uptodate
        firstDate: DateTime(DateTime.now().year, DateTime.now().month,
            1), //.subtract(const Duration(days: 30)),
        lastDate: DateTime.now());

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      // var dateFormate =
      //     DateFormat("dd/MM/yyyy").format(DateTime.parse(formattedDate));

      controller.text = formattedDate;
    }
  }

  void pickertime(controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (pickedTime != null) {
      setState(() {
        final now = DateTime.now();
        final dt = DateTime(
          now.year,
          now.month,
          now.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        final formatted = DateFormat('hh:mm a').format(dt);
        print(formatted);
        controller.text = formatted;
        if (reginController.text.isNotEmpty ||
            reqoutController.text.isNotEmpty) {
          validatetiming(reginController.text, reqoutController.text);
        }
      });
    } else {
      print("Time is not selected");
    }
  }

  validatetiming(String starttime, String endtime) {
    var format = DateFormat("hh:mm a");
    var start = format.parse(starttime);
    var end = format.parse(endtime);

    if (start.isBefore(end)) {
      //end = end.add(Duration(days: 1));
      Duration diff = end.difference(start);
      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;
    } else {
      AppUtils.showSingleDialogPopup(
          context,
          "From Time and To Time is Mismatched!",
          "OK",
          onclearvalues,
          AssetsImageWidget.errorimage);
    }
  }

  String convertFormat(String date) {
    if (date.isEmpty) return "";

    DateTime parsedDate = DateFormat("yyyy/MM/dd").parse(date);
    return DateFormat("dd/MM/yyyy").format(parsedDate);
  }

  void onApplyRegularization() async {
    String cdate = DateFormat("dd/MM/yyyy").format(DateTime.now());
    var json = {
      "attendanceInternalId": widget.id,
      "employeeId": Prefs.getNsID('nsid'),
      "employeeName": Prefs.getFullName("Name"),
      "date": datepickercontroller.text,
      "regDate": cdate,
      "intime": widget.checkIn,
      "outtime": widget.checkOut,
      "regIn": reginController.text,
      "regOut": reqoutController.text,
      "remarks": reasoncontroller.text
    };

    setState(() {
      loading = true;
    });
    ApiService.postreqularization(json).then((response) {
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

  void onclearvalues() {
    fromtimeController.text = "";
    totimeController.text = "";
    fromtimeController.clear();
    totimeController.clear();
    Navigator.of(context).pop();
  }

  void onrefreshscreen() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}
