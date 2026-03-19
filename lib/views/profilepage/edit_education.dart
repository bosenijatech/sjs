import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;
import 'dart:typed_data';
import 'package:sjs/routenames.dart';
import 'package:sjs/views/leave/homepage.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sjs/models/empinfomodel.dart';
import 'package:sjs/models/filemodel.dart';
import 'package:sjs/domain/ApiService.dart';
import 'package:sjs/services/pref.dart';
import 'package:sjs/utils/app_utils.dart';
import 'package:sjs/utils/constants.dart';
import 'package:sjs/utils/custom_indicatoronly.dart';
import 'package:sjs/utils/netsuite/netsuiteservice.dart';
import 'package:sjs/utils/sharedprefconstants.dart';
import 'package:sjs/views/profilepage/educationmodel.dart';
import 'package:sjs/views/widgets/assets_image_widget.dart';
import 'package:sjs/views/widgets/custom_button.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class EditEducation extends StatefulWidget {
  final EmpInfoModel model;
  final bool? iseditable;
  final int? position;
  const EditEducation(
      {super.key,
      required this.model,
      required this.iseditable,
      required this.position});

  @override
  State<EditEducation> createState() => _EditEducationState();
}

class _EditEducationState extends State<EditEducation> {
  TextEditingController educationcontroller = TextEditingController();
  TextEditingController passingYearcontroller = TextEditingController();
  TextEditingController percentagecontroller = TextEditingController();
  TextEditingController certificatecontroller = TextEditingController();
  TextEditingController collegecontroller = TextEditingController();
  TextEditingController levelofeducation = TextEditingController();
  bool loading = false;
  EducationModel educationModel = EducationModel();
  List<String> educationlist = [];
  List<String> idList = [];

  String geteductionname = "";
  String geteductionid = "";

  List<AttachModel> attachlist = [];
  String attachmentID = "";
  String attachmentURL = "";

  final picker = ImagePicker();
  File? imagefile;

  String showYear = 'Select Year';
  DateTime _selectedYear = DateTime.now();
  String internalId = "";
  @override
  void initState() {
    if (widget.iseditable == true) {
      internalId = widget
          .model.message!.qualification![widget.position!.toInt()].education
          .toString();
      geteductionname = widget
          .model.message!.qualification![widget.position!.toInt()].education
          .toString();

      geteductionid = widget.model.message!
          .qualification![widget.position!.toInt()].qualificationId
          .toString();

      passingYearcontroller.text = widget
          .model.message!.qualification![widget.position!.toInt()].passingYear
          .toString();

      percentagecontroller.text = widget
          .model.message!.qualification![widget.position!.toInt()].percentage
          .toString();

      collegecontroller.text = widget
          .model.message!.qualification![widget.position!.toInt()].college
          .toString();

      attachmentURL = widget
          .model.message!.qualification![widget.position!.toInt()].certificate
          .toString();

      attachmentID = widget
          .model.message!.qualification![widget.position!.toInt()].certificateID
          .toString();
      certificatecontroller.text = widget
          .model.message!.qualification![widget.position!.toInt()].certificate
          .toString();
      levelofeducation.text = widget.model.message!
          .qualification![widget.position!.toInt()].levelofeducation
          .toString();
    } else {
      certificatecontroller.text = "";
      educationcontroller.text = "";
      collegecontroller.text = "";
      passingYearcontroller.text = "";
      levelofeducation.text = "";
    }

    geteducationdetailsdata();

    super.initState();
  }

  String getEducationId(String educationName) {
    int index = educationlist.indexOf(educationName);
    return (index != -1) ? idList[index] : "Not Found"; // Ensure valid index
  }

  @override
  void dispose() {
    educationcontroller.clear();
    passingYearcontroller.clear();
    percentagecontroller.clear();
    collegecontroller.clear();
    certificatecontroller.dispose();
    levelofeducation.dispose();
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
            text: "Education Details", color: Colors.black, fontSize: 20),
        centerTitle: true,
      ),
      body: !loading
          ? SingleChildScrollView(
              child: Column(
                children: [getwidget()],
              ),
            )
          : const Center(
              child: CustomIndicator(),
            ),
    );
  }

  Widget getwidget() {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                DropdownSearch<String>(
                  popupProps: const PopupProps.menu(
                    showSearchBox: true,
                    showSelectedItems: true,
                  ),
                  items: educationlist,
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                        icon: Icon(Icons.school),
                        hintText: "Select Education",
                        label: Text("Select Education")),
                  ),
                  onChanged: (val) {
                    for (int kk = 0;
                        kk < educationModel.records!.length;
                        kk++) {
                      if (educationModel.records![kk].name.toString() == val) {
                        geteductionname =
                            educationModel.records![kk].name.toString();
                        geteductionid =
                            educationModel.records![kk].id.toString();
                        print(geteductionid);
                        if (!mounted) return;
                        setState(() {});
                      }
                    }
                  },
                  selectedItem: geteductionname,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: collegecontroller,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    counterText: '',
                    labelText: 'College',
                    icon: Icon(Icons.message),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  onTap: () {
                    // pickerdate(passingYearcontroller);
                    selectYear(context);
                  },
                  readOnly: true,
                  controller: passingYearcontroller,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    counterText: '',
                    labelText: 'Passing year',
                    icon: Icon(Icons.date_range),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: percentagecontroller,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    counterText: '',
                    labelText: 'Percentage',
                    icon: Icon(Icons.date_range),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: levelofeducation,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    counterText: '',
                    labelText: 'Level of Education',
                    icon: Icon(Icons.date_range),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  readOnly: true,
                  controller: certificatecontroller,
                  maxLength: 250,
                  decoration: InputDecoration(
                      counterText: '',
                      border: const UnderlineInputBorder(),
                      icon: InkWell(
                          onTap: () {
                            if (widget
                                    .model
                                    .message!
                                    .documents![widget.position!.toInt()]
                                    .attachment
                                    .toString()
                                    .isEmpty ||
                                widget
                                        .model
                                        .message!
                                        .documents![widget.position!.toInt()]
                                        .attachment
                                        .toString() ==
                                    "null") {
                            } else {
                              _launchUrl(
                                  widget
                                      .model
                                      .message!
                                      .qualification![widget.position!.toInt()]
                                      .certificate
                                      .toString(),
                                  isNewTab: true);
                            }
                          },
                          child: Icon(Icons.visibility,
                              color: (widget.iseditable == true &&
                                      widget
                                          .model
                                          .message!
                                          .qualification![
                                              widget.position!.toInt()]
                                          .certificate
                                          .toString()
                                          .isEmpty)
                                  ? Colors.grey.shade300
                                  : Colors.black)),
                      hintText: "Click here to Attach file",
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.attach_file,
                          color: Colors.black,
                        ),
                        onPressed: () async {
                          Map<Permission, PermissionStatus> statuses = await [
                            Permission.camera,
                          ].request();
                          statuses.values.forEach((element) async {
                            if (element.isDenied ||
                                element.isPermanentlyDenied) {
                              await openAppSettings();
                            }
                          });
                          AppUtils.showBottomCupertinoDialog(context,
                              title: "Choose any one option",
                              btn1function: () async {
                            AppUtils.pop(context);
                            getImageFromCamera();
                          }, btn2function: () {
                            AppUtils.pop(context);
                            _pickFile();
                          });
                        },
                      )),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  onPressed: () {
                    if (geteductionname.isEmpty) {
                      AppUtils.showSingleDialogPopup(
                          context,
                          "Please Choose Education",
                          "Ok",
                          onexitpopup,
                          AssetsImageWidget.warningimage);
                    } else if (collegecontroller.text.isEmpty) {
                      AppUtils.showSingleDialogPopup(
                          context,
                          "Please Enter College",
                          "Ok",
                          onexitpopup,
                          AssetsImageWidget.warningimage);
                    } else if (passingYearcontroller.text.isEmpty) {
                      AppUtils.showSingleDialogPopup(
                          context,
                          "Please Enter passing year",
                          "Ok",
                          onexitpopup,
                          AssetsImageWidget.warningimage);
                    } else if (levelofeducation.text.isEmpty) {
                      AppUtils.showSingleDialogPopup(
                          context,
                          "Please Enter Level Of Education",
                          "Ok",
                          onexitpopup,
                          AssetsImageWidget.warningimage);
                    } else if (attachlist.isEmpty &&
                        widget.iseditable == true &&
                        internalId.isNotEmpty) {
                      insertandupdateeducation(widget.model.message!
                          .qualification![widget.position!.toInt()].sId
                          .toString());
                      // if (widget.iseditable == true ) {
                      //   insertandupdateeducation(widget.model.message!
                      //       .qualification![widget.position!.toInt()].sId
                      //       .toString());
                      // } else {
                      //   addeducation();
                      // }
                    } else if (attachlist.isNotEmpty &&
                        widget.iseditable == true) {
                      uploadfiles(widget.model.message!
                          .qualification![widget.position!.toInt()].sId
                          .toString());
                    } else if (attachmentID.isNotEmpty &&
                        attachmentURL.isNotEmpty &&
                        internalId.isEmpty) {
                      addeducation();
                    } else if (widget.iseditable == false &&
                        attachlist.isEmpty &&
                        internalId.isEmpty) {
                      addeducation();
                    } else if (widget.iseditable == false &&
                        attachlist.isNotEmpty) {
                      uploadfiles("");
                    }
                  },
                  name: "Submit",
                  circularvalue: 5,
                  fontSize: 14,
                )
              ],
            )),
      ]),
    );
  }

  void uploadfiles(sid) async {
    var body = {
      "attachment": [
        {
          "FileData": attachlist[0].fileData.toString(),
          "FileType": attachlist[0].fileType.toString(),
          "FileName": attachlist[0].fileName.toString()
        }
      ]
    };
    if (!mounted) return;
    setState(() {
      loading = true;
    });
    dev.log(jsonEncode(body));

    ApiService.postattachment(body).then((response) {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          attachmentID = jsonDecode(response.body)['fileId'].toString();
          attachmentURL = jsonDecode(response.body)['url'].toString();
          attachlist[0].fileData = attachmentID;
          if (widget.iseditable == true) {
            insertandupdateeducation(sid);
          } else {
            addeducation();
          }
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
      if (!mounted) return;
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
      certificatecontroller.text = pickedFile.path.toString().split("/").last;
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
      allowMultiple: false,
      allowCompression: true,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'doc', 'docx', 'xls', 'pdf'],
    );

    if (result != null && result.files.single.path != null) {
      PlatformFile file = result.files.first;
      File file0 = File(file.path!);

      // Calculate size (in MB like camera flow)
      final bytesCount = await file0.length();
      final kb = bytesCount / 1024;
      final mb = kb / 1024;

      // Convert to base64
      Uint8List bytes0 = await file0.readAsBytes();
      String file64 = base64Encode(bytes0);

      // Ensure consistent fileName
      String fileName = file0.path.split("/").last;

      certificatecontroller.text = file0.path.toString().split("/").last;
      String extension = AppConstants.getFileTypeExtension(file0.path);
      print("extension $extension");
      Random random = Random();
      int randomnumber = random.nextInt(100);
      if (!mounted) return;
      setState(() {
        attachlist.clear();
        attachlist.add(
          AttachModel(
            randomnumber.toString(),
            file64,
            extension.replaceAll(".", ""), // same format as camera
            fileName,
            mb.toStringAsFixed(3), // same format as camera
          ),
        );
      });
    }
  }

  void pickerdate(controller) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000), //.subtract(Duration(days: 1)),
        lastDate: DateTime(2100));

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      var dateFormate =
          DateFormat("dd/MM/yyyy").format(DateTime.parse(formattedDate));

      controller.text = dateFormate;
    }
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

  // geteducationdetailsdata() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   try {
  //     ApiService.getEducation().then((response) {
  //       setState(() {
  //         loading = false;
  //       });
  //       if (response.statusCode == 200) {
  //         educationModel =
  //             EducationModel.fromJson(json.decode(json.decode(response.body)));
  //         educationlist.clear();
  //         for (int i = 0; i < educationModel.empEducationList!.length; i++) {
  //           educationlist
  //               .add(educationModel.empEducationList![i].name.toString());
  //         }
  //         //log(b['currentPage'].toString());
  //       } else {
  //         AppUtils.showSingleDialogPopup(
  //             context,
  //             json.decode(json.decode(response.body)),
  //             "Ok",
  //             onexitpopup,
  //             AssetsImageWidget.errorimage);
  //       }
  //     });
  //   } on Exception catch (_) {
  //     setState(() {
  //       loading = false;
  //     });
  //     rethrow;
  //   }
  // }
  void geteducationdetailsdata() async {
    if (!mounted) return;
    setState(() {
      loading = true;
    });
    try {
      Uri baseUri = Uri.parse(
          '${AppConstants.netSuiteapiBaseUrl}script=${AppConstants.empeducationscriptid}&deploy=${AppConstants.empeducationdeployid}');
      await NetSuiteApiService.client.get(baseUri).then((response) {
        if (!mounted) return;
        setState(() {
          loading = false;
        });
        if (response.statusCode == 200) {
          educationModel =
              EducationModel.fromJson(json.decode(json.decode(response.body)));
          educationlist.clear();
          idList.clear();
          for (int i = 0; i < educationModel.records!.length; i++) {
            educationlist.add(educationModel.records![i].name.toString());
            //idList.add(educationModel.records![i].id.toString());
          }
          // if (educationlist.isNotEmpty) {
          //   geteductionid = getEducationId(geteductionname);
          //   print(geteductionid);
          // }
        } else {
          educationlist.clear();
          idList.clear();
          AppUtils.showSingleDialogPopup(context,
              json.decode(json.decode(response.body)), "Ok", onexitpopup, null);
        }
      });
    } on Exception catch (_) {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
      rethrow;
    }
  }

  void insertandupdateeducation(String sid) {
    var json = {
      "type": "qualification",
      "nsId": Prefs.getNsID(
        SharefprefConstants.sharednsid,
      ),
      "firstName": Prefs.getFirstName(
        SharefprefConstants.shareFirstName,
      ),
      "middleName": Prefs.getMiddleName(
        SharefprefConstants.shareMiddleName,
      ),
      "lastName": Prefs.getLastName(
        SharefprefConstants.sharedLastName,
      ),
      "_id": sid,
      "internalid": widget
          .model.message!.qualification![widget.position!.toInt()].internalid
          .toString(),
      "qualificationId": geteductionid,
      "education": geteductionname,
      "college": collegecontroller.text,
      "passingYear": passingYearcontroller.text,
      "percentage": percentagecontroller.text,
      "attachmentUrl": attachmentURL,
      "levelofeducation": levelofeducation.text,
      "attachmentID": attachmentID,
    };
    if (!mounted) return;
    setState(() {
      loading = true;
    });
    ApiService.updatemaster(json).then((response) {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
        } else {
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              onexitpopup,
              AssetsImageWidget.errorimage);
        }
      } else {
        throw Exception(jsonDecode(response.body)['message'].toString());
      }
    }).catchError((e) {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", onexitpopup,
          AssetsImageWidget.errorimage);
    });
  }

  void addeducation() {
    var json = {
      "nsId": Prefs.getNsID('nsid'),
      "firstName": Prefs.getFirstName(
        SharefprefConstants.shareFirstName,
      ),
      "middleName": Prefs.getMiddleName(
        SharefprefConstants.shareMiddleName,
      ),
      "lastName": Prefs.getLastName(
        SharefprefConstants.sharedLastName,
      ),
      "type": "qualification",
      "qualificationId": geteductionid,
      "education": geteductionname,
      "college": collegecontroller.text,
      "passingYear": passingYearcontroller.text,
      "percentage": percentagecontroller.text,
      "attachmentUrl": attachmentURL,
      "levelofeducation": levelofeducation.text,
      "attachmentID": attachmentID
    };
    if (!mounted) return;
    setState(() {
      loading = true;
    });
    ApiService.addprofiles(json).then((response) {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
        } else {
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              onexitpopup,
              AssetsImageWidget.errorimage);
        }
      } else {
        throw Exception(jsonDecode(response.body)['message'].toString());
      }
    }).catchError((e) {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", onexitpopup,
          AssetsImageWidget.errorimage);
    });
  }

  void onexitpopup() {
    Navigator.of(context).pop();
  }

  selectYear(context) async {
    print("Calling date picker");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Year"),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year - 20, 1),
              lastDate: DateTime.now(),
              //lastDate: DateTime(2025),
              initialDate: DateTime.now(),
              selectedDate: _selectedYear,
              onChanged: (DateTime dateTime) {
                print(dateTime.year);
                setState(() {
                  _selectedYear = dateTime;
                  showYear = "${dateTime.year}";
                });
                Navigator.pop(context);
                passingYearcontroller.text = showYear;
              },
            ),
          ),
        );
      },
    );
  }
}
