import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:sjs/views/leave/homepage.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sjs/models/empinfomodel.dart';
import 'package:sjs/models/filemodel.dart';
import 'package:sjs/domain/ApiService.dart';
import 'package:sjs/services/pref.dart';
import 'package:sjs/utils/app_utils.dart';
import 'package:sjs/utils/constants.dart';
import 'package:sjs/utils/custom_indicatoronly.dart';
import 'package:sjs/utils/netsuite/netsuiteservice.dart';
import 'package:sjs/utils/sharedprefconstants.dart';
import 'package:sjs/views/profilepage/empskillsmodel.dart';
import 'package:sjs/views/widgets/assets_image_widget.dart';
import 'package:sjs/views/widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class EditSkills extends StatefulWidget {
  final EmpInfoModel model;
  final bool? iseditable;
  final int? position;
  const EditSkills(
      {super.key,
      required this.model,
      required this.iseditable,
      required this.position});

  @override
  State<EditSkills> createState() => _EditSkillsState();
}

class _EditSkillsState extends State<EditSkills> {
  TextEditingController skillnamecontroller = TextEditingController();
  TextEditingController skillexpcontroller = TextEditingController();
  TextEditingController skillcertificatecontroller = TextEditingController();
  bool loading = false;

  SkillMasterModel? selectedSkillMaster;

  String getskillsname = "";
  String getyearofexp = "";
  String getskillcode = "";

  List<AttachModel> attachlist = [];
  String attachmentID = "";
  String attachmentURL = "";

  final picker = ImagePicker();
  File? imagefile;

  String internalid = "";

  @override
  void initState() {
    if (widget.iseditable == true) {
      internalid = widget
          .model.message!.skill![widget.position!.toInt()].internalid
          .toString();
      getskillsname = widget
          .model.message!.skill![widget.position!.toInt()].skillName
          .toString();
      getskillcode = widget
          .model.message!.skill![widget.position!.toInt()].skillCode
          .toString();

      skillcertificatecontroller.text = widget
          .model.message!.skill![widget.position!.toInt()].skillCertificate
          .toString();
      skillexpcontroller.text = widget
          .model.message!.skill![widget.position!.toInt()].skillexperience
          .toString();
      attachmentURL = widget
          .model.message!.skill![widget.position!.toInt()].skillCertificate
          .toString();
      attachmentID = widget
          .model.message!.skill![widget.position!.toInt()].skillCertificateID
          .toString();
    } else {
      skillnamecontroller.text = "";
      skillcertificatecontroller.text = "";
      skillexpcontroller.text = "";
    }
    super.initState();
  }

  @override
  void dispose() {
    skillnamecontroller.clear();
    skillcertificatecontroller.clear();
    skillexpcontroller.clear();

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
            text: "Skills", color: Colors.black, fontSize: 20),
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

                DropdownSearch<SkillMasterModel>(
                  validator: (value) {
                    if (value == null) {
                      return 'Please payroll component';
                    }
                    return null;
                  },
                  selectedItem: selectedSkillMaster,
                  asyncItems: (String filter) =>
                      ApiService.getSkillMaster(filter: filter),
                  itemAsString: (SkillMasterModel item) => item.skillName,
                  onChanged: (value) {
                    selectedSkillMaster = value;
                    if (value != null) {
                      getskillsname = value.skillName.toString();
                      getskillcode = value.skillCode.toString();
                    } else {
                      getskillsname = "";
                      getskillcode = "";
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
                      title: Text(item.skillName.toString()),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: false,
                  child: TextFormField(
                    controller: skillexpcontroller,
                    maxLength: 100,
                    decoration: const InputDecoration(
                      counterText: '',
                      labelText: 'Year Of Experience',
                      icon: Icon(Icons.message),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: false),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // TextFormField(
                //   controller: skillcertificatecontroller,
                //   maxLength: 100,
                //   decoration: const InputDecoration(
                //     counterText: '',
                //     labelText: 'CERTIFICATE',
                //     icon: Icon(Icons.message),
                //   ),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                TextField(
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))
                  ],
                  controller: skillexpcontroller,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    counterText: '',
                    labelText: 'YEAR OF EXPERIENCE',
                    icon: Icon(Icons.message),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  readOnly: true,
                  controller: skillcertificatecontroller,
                  maxLength: 250,
                  decoration: InputDecoration(
                      counterText: '',
                      border: const UnderlineInputBorder(),
                      icon: InkWell(
                          onTap: () {
                            if (widget
                                    .model
                                    .message!
                                    .skill![widget.position!.toInt()]
                                    .skillCertificate
                                    .toString()
                                    .isEmpty ||
                                widget
                                        .model
                                        .message!
                                        .skill![widget.position!.toInt()]
                                        .skillCertificate
                                        .toString() ==
                                    "null") {
                            } else {
                              _launchUrl(
                                  widget
                                      .model
                                      .message!
                                      .skill![widget.position!.toInt()]
                                      .skillCertificate
                                      .toString(),
                                  isNewTab: true);
                            }
                          },
                          child: Icon(Icons.visibility,
                              color: (widget.iseditable == true &&
                                      widget
                                          .model
                                          .message!
                                          .skill![widget.position!.toInt()]
                                          .skillCertificate
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
                  height: 20,
                ),
                CustomButton(
                  onPressed: () {
                    // if (widget.iseditable == true && attachlist.isEmpty) {
                    //   updateskills(widget
                    //       .model.message!.skill![widget.position!.toInt()].sId
                    //       .toString());
                    // } else if (widget.iseditable == true &&
                    //     attachlist.isNotEmpty) {
                    //   uploadfiles(widget
                    //       .model.message!.skill![widget.position!.toInt()].sId
                    //       .toString());
                    // } else {
                    //   if (getskillsname.isEmpty) {
                    //     AppUtils.buildNormalText(
                    //         text: "Please Choose one Skills");
                    //   } else if (skillexpcontroller.text.isEmpty) {
                    //     AppUtils.buildNormalText(
                    //         text: "Please Enter Year Of Experience");
                    //   } else if (skillcertificatecontroller.text.isEmpty) {
                    //     AppUtils.buildNormalText(
                    //         text: "Please Enter Certificate");
                    //   } else if (attachlist.isEmpty) {
                    //     addskills();
                    //   } else if (attachlist.isNotEmpty) {
                    //     uploadfiles("");
                    //   }
                    // }
                    if (getskillcode.isEmpty) {
                      AppUtils.showSingleDialogPopup(
                          context,
                          "Please Choose Skills",
                          "Ok",
                          onexitpopup,
                          AssetsImageWidget.warningimage);
                    } else if (skillexpcontroller.text.isEmpty) {
                      AppUtils.showSingleDialogPopup(
                          context,
                          "Please Enter Experience",
                          "Ok",
                          onexitpopup,
                          AssetsImageWidget.warningimage);
                    } else if (attachlist.isEmpty &&
                        widget.iseditable == true &&
                        internalid.isNotEmpty) {
                      updateskills(widget
                          .model.message!.skill![widget.position!.toInt()].sId
                          .toString());
                    } else if (attachmentID.isNotEmpty &&
                        attachmentURL.isNotEmpty &&
                        internalid.isEmpty) {
                      addskills();
                    } else if (attachlist.isNotEmpty &&
                        widget.iseditable == true) {
                      uploadfiles(widget
                          .model.message!.skill![widget.position!.toInt()].sId
                          .toString());
                    } else if (widget.iseditable == false &&
                        attachlist.isEmpty) {
                      addskills();
                    } else if (widget.iseditable == false) {
                      uploadfiles("");
                    }
                  },
                  name: "Submit",
                  circularvalue: 30,
                  fontSize: 14,
                )
              ],
            )),
      ]),
    );
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
      skillcertificatecontroller.text =
          pickedFile.path.toString().split("/").last;
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
      if (!mounted) return;
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

      skillcertificatecontroller.text = file0.path.toString().split("/").last;
      String extension = AppConstants.getFileTypeExtension(file0.path);

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
        firstDate: DateTime.now(), //.subtract(Duration(days: 1)),
        lastDate: DateTime(2100));

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      var dateFormate =
          DateFormat("dd/MM/yyyy").format(DateTime.parse(formattedDate));

      controller.text = dateFormate;
    }
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
            updateskills(sid);
          } else {
            addskills();
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

  void updateskills(String sid) {
    var json = {
      "type": "skill",
      "nsId": Prefs.getNsID("nsid"),
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
          .model.message!.skill![widget.position!.toInt()].internalid
          .toString(),
      "skillCode": getskillcode,
      "skillName": getskillsname,
      "yearsOfExperience": skillexpcontroller.text,
      "attachmentUrl": attachmentURL,
      "attachmentID": attachmentID,
      //"yearOfExperience": skillexpcontroller.text,
    };
    print(jsonEncode(json));
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

  void addskills() {
    var json = {
      "nsId": Prefs.getNsID("nsid"),
      "firstName": Prefs.getFirstName(
        SharefprefConstants.shareFirstName,
      ),
      "middleName": Prefs.getMiddleName(
        SharefprefConstants.shareMiddleName,
      ),
      "lastName": Prefs.getLastName(
        SharefprefConstants.sharedLastName,
      ),
      "type": "skill",
      "skillCode": getskillcode,
      "skillName": getskillsname,
      "yearsOfExperience": skillexpcontroller.text,
      "attachmentUrl": attachmentURL,
      "attachmentID": attachmentID
    };
    print(jsonEncode(json));
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
}
