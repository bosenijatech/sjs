import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:winstar/views/leave/homepage.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winstar/models/documentmodel.dart';
import 'package:winstar/models/empinfomodel.dart';
import 'package:winstar/models/filemodel.dart';
import 'package:winstar/models/relationmodel.dart';
import 'package:winstar/domain/ApiService.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/appcolor.dart';
import 'package:winstar/utils/constants.dart';
import 'package:winstar/utils/netsuite/netsuiteservice.dart';
import 'package:winstar/utils/sharedprefconstants.dart';
import 'package:winstar/views/widgets/assets_image_widget.dart';
import 'package:winstar/views/widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class EditDependsIdDetails extends StatefulWidget {
  final EmpInfoModel model;
  final bool? iseditable;
  final int? position;
  const EditDependsIdDetails(
      {super.key,
      required this.model,
      required this.iseditable,
      required this.position});

  @override
  State<EditDependsIdDetails> createState() => _EditDependsIdDetailsState();
}

class _EditDependsIdDetailsState extends State<EditDependsIdDetails> {
  TextEditingController controllertypeid = TextEditingController();
  TextEditingController controllertypename = TextEditingController();
  TextEditingController idnumbercontroller = TextEditingController();
  TextEditingController controllerrelationname = TextEditingController();
  TextEditingController controllercompanyname = TextEditingController();
  TextEditingController controllercountryissue = TextEditingController();
  TextEditingController controllerissuedate = TextEditingController();
  TextEditingController controllerexpirydate = TextEditingController();
  TextEditingController controllerdesignation = TextEditingController();
  TextEditingController remarks = TextEditingController();
  TextEditingController controllerremainderdate = TextEditingController();
  TextEditingController attachmentcontroller = TextEditingController();

  List<String> dependentslist = [];

  String? remainderval;
  bool loading = false;
  String? typeNo;
  String? typeName;

  List<AttachModel> attachlist = [];
  String attachmentID = "";
  String attachmentURL = "";

  final picker = ImagePicker();
  File? imagefile;
  String internalid = "";
  DocumentTypeModel? selectedDocument;
  @override
  void initState() {
    if (widget.iseditable == true) {
      internalid = widget.model.message!
          .dependantIdDetails![widget.position!.toInt()].internalid
          .toString();

      typeName = widget
          .model.message!.dependantIdDetails![widget.position!.toInt()].idType;

      typeNo = widget.model.message!
          .dependantIdDetails![widget.position!.toInt()].idTypeNo;

      controllertypeid.text = widget
          .model.message!.dependantIdDetails![widget.position!.toInt()].idTypeNo
          .toString();

      controllertypename.text = widget
          .model.message!.dependantIdDetails![widget.position!.toInt()].idType
          .toString();

      idnumbercontroller.text = widget
          .model.message!.dependantIdDetails![widget.position!.toInt()].idNo
          .toString();

      controllerrelationname.text = widget.model.message!
          .dependantIdDetails![widget.position!.toInt()].dependantIdName
          .toString();

      controllercompanyname.text = widget.model.message!
          .dependantIdDetails![widget.position!.toInt()].companyName
          .toString();
      controllercountryissue.text = widget.model.message!
          .dependantIdDetails![widget.position!.toInt()].countryOfIssue
          .toString();

      controllerissuedate.text = widget.model.message!
          .dependantIdDetails![widget.position!.toInt()].issueDate
          .toString();
      controllerexpirydate.text = widget.model.message!
          .dependantIdDetails![widget.position!.toInt()].expiryDate
          .toString();

      controllerdesignation.text = widget.model.message!
          .dependantIdDetails![widget.position!.toInt()].designation
          .toString();

      remarks.text = widget
          .model.message!.dependantIdDetails![widget.position!.toInt()].remarks
          .toString();

      remainderval = widget.model.message!
          .dependantIdDetails![widget.position!.toInt()].remainder
          .toString();

      controllerremainderdate.text = widget.model.message!
          .dependantIdDetails![widget.position!.toInt()].remainderDate
          .toString();

      attachmentcontroller.text = widget.model.message!
          .dependantIdDetails![widget.position!.toInt()].attachment
          .toString();
      attachmentURL = widget.model.message!
          .dependantIdDetails![widget.position!.toInt()].attachment
          .toString();
      attachmentID = widget.model.message!
          .dependantIdDetails![widget.position!.toInt()].attachmentID
          .toString();
    } else {
      controllertypeid.text = "";
      controllertypename.text = "";
      controllercompanyname.text = "";
      controllercountryissue.text = "";
      controllerissuedate.text = "";
      controllerexpirydate.text = "";
      controllerdesignation.text = "";
      remarks.text = "";
      controllerrelationname.text = "";
      controllerremainderdate.text = "";
      attachmentcontroller.text = "";
      idnumbercontroller.text = "";
    }

    super.initState();
  }

  @override
  void dispose() {
    controllertypeid.dispose();
    controllertypename.dispose();
    controllercompanyname.dispose();
    controllercountryissue.dispose();
    controllerissuedate.dispose();
    controllerexpirydate.dispose();
    controllerdesignation.dispose();
    controllerrelationname.dispose();
    remarks.dispose();
    controllerremainderdate.dispose();
    attachmentcontroller.dispose();
    idnumbercontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(CupertinoIcons.clear, color: Colors.black),
            onPressed: () {
              AppUtils.hideKeyboard(context);
              Navigator.of(context).pop();
            }),
        title: AppUtils.buildNormalText(
            text: "Dependents ID", color: Colors.black, fontSize: 20),
        centerTitle: true,
      ),
      body: !loading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [getwidget()],
                  ),
                ))
              ],
            )
          : const Center(
              child: CupertinoActivityIndicator(
                  radius: 30.0, color: Appcolor.twitterBlue),
            ),
      persistentFooterButtons: [
        CustomButton(
          onPressed: () {
            if (typeNo.toString().isEmpty) {
              AppUtils.showSingleDialogPopup(
                  context,
                  "Please Choose Dependent Type",
                  "OK",
                  onexitpopup,
                  AssetsImageWidget.errorimage);
            }
            if (idnumbercontroller.text.toString().isEmpty) {
              AppUtils.showSingleDialogPopup(context, "Please Enter ID No",
                  "OK", onexitpopup, AssetsImageWidget.errorimage);
            } else if (controllerrelationname.text.toString().isEmpty) {
              AppUtils.showSingleDialogPopup(
                  context,
                  "Please Enter Relation Name",
                  "OK",
                  onexitpopup,
                  AssetsImageWidget.errorimage);
            } else if (controllercompanyname.text.toString().isEmpty) {
              AppUtils.showSingleDialogPopup(
                  context,
                  "Please Enter Company Name",
                  "OK",
                  onexitpopup,
                  AssetsImageWidget.errorimage);
            } else if (controllercountryissue.text.toString().isEmpty) {
              AppUtils.showSingleDialogPopup(
                  context,
                  "Please Enter Country Name",
                  "OK",
                  onexitpopup,
                  AssetsImageWidget.errorimage);
            } else if (controllerissuedate.text.toString().isEmpty) {
              AppUtils.showSingleDialogPopup(context, "Please Enter Issue Date",
                  "OK", onexitpopup, AssetsImageWidget.errorimage);
            } else if (controllerexpirydate.text.toString().isEmpty) {
              AppUtils.showSingleDialogPopup(context, "Please Enter Exp Date",
                  "OK", onexitpopup, AssetsImageWidget.errorimage);
            } else if (controllerdesignation.text.toString().isEmpty) {
              AppUtils.showSingleDialogPopup(
                  context,
                  "Please Enter Designation",
                  "OK",
                  onexitpopup,
                  AssetsImageWidget.errorimage);
            } else if (remainderval.toString().isEmpty ||
                remainderval.toString() == "null") {
              AppUtils.showSingleDialogPopup(context, "Please Choose Remainder",
                  "OK", onexitpopup, AssetsImageWidget.errorimage);
            } else if (widget.iseditable == true &&
                attachlist.isEmpty &&
                internalid.isNotEmpty) {
              updatedocuments(widget.model.message!
                  .dependantIdDetails![widget.position!.toInt()].sId
                  .toString());
            } else if (attachmentID.isNotEmpty &&
                attachmentURL.isNotEmpty &&
                internalid.isEmpty) {
              adddocuments();
            } else if (widget.iseditable == true && attachlist.isNotEmpty) {
              uploadfiles(widget.model.message!
                  .dependantIdDetails![widget.position!.toInt()].sId
                  .toString());
            } else if (widget.iseditable == false && attachlist.isNotEmpty) {
              uploadfiles("");
            } else {
              adddocuments();
            }
          },
          name: "Submit",
          circularvalue: 30,
          fontSize: 14,
        )
      ],
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
      attachmentcontroller.text = pickedFile.path.toString().split("/").last;
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

      attachmentcontroller.text = file0.path.toString().split("/").last;
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
    setState(() {
      if (!mounted) return;
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
            updatedocuments(sid);
          } else {
            adddocuments();
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

  Widget getwidget() {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownSearch<DocumentTypeModel>(
              selectedItem: selectedDocument,
              validator: (value) {
                if (value == null) {
                  return 'Please select relationship';
                }
                return null;
              },
              asyncItems: (String filter) =>
                  ApiService.getDocuemntlist(filter: filter),
              itemAsString: (DocumentTypeModel item) => item.name,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedDocument = value;
                    typeNo = value.id;
                    typeName = value.name;
                  });
                }
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Select ID",
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
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.characters,
              controller: idnumbercontroller,
              maxLength: 100,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'ID Number',
                icon: Icon(
                  Icons.home,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.characters,
              controller: controllerrelationname,
              maxLength: 100,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Relation Name',
                icon: Icon(
                  Icons.home,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.characters,
              controller: controllercompanyname,
              maxLength: 100,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Company Name',
                icon: Icon(
                  Icons.home,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.characters,
              controller: controllercountryissue,
              maxLength: 100,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Country Of Issue',
                icon: Icon(
                  Icons.home,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: controllerissuedate,
              maxLength: 100,
              readOnly: true,
              onTap: () {
                pickerdate(controllerissuedate);
              },
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Issue Date',
                icon: Icon(Icons.join_full, color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: controllerexpirydate,
              maxLength: 100,
              readOnly: true,
              onTap: () {
                pickerdate(controllerexpirydate);
              },
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Exp Date',
                icon: Icon(Icons.join_full, color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: controllerdesignation,
              maxLength: 100,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Designation',
                icon: Icon(Icons.join_full, color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: remarks,
              maxLength: 100,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Remarks',
                icon: Icon(Icons.join_full, color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                margin: const EdgeInsets.only(
                  left: 35,
                ),
                width: double.infinity,
                child: DropdownSearch<String>(
                    popupProps: const PopupProps.modalBottomSheet(
                      showSelectedItems: true,
                    ),
                    items: const ["true", "false"],
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Remainder ",
                        hintText: "Remainder",
                      ),
                    ),
                    onChanged: (values) {
                      remainderval = values;
                      print(remainderval);
                    },
                    selectedItem: remainderval)),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: controllerremainderdate,
              maxLength: 100,
              readOnly: true,
              onTap: () {
                pickerdate(controllerremainderdate);
              },
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Remainder Date',
                icon: Icon(Icons.join_full, color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              readOnly: true,
              controller: attachmentcontroller,
              maxLength: 250,
              decoration: InputDecoration(
                  counterText: '',
                  border: const UnderlineInputBorder(),
                  icon: InkWell(
                      onTap: () {
                        if (widget
                                .model
                                .message!
                                .dependantIdDetails![widget.position!.toInt()]
                                .attachment
                                .toString()
                                .isEmpty ||
                            widget
                                    .model
                                    .message!
                                    .dependantIdDetails![
                                        widget.position!.toInt()]
                                    .attachment
                                    .toString() ==
                                "null") {
                        } else {
                          _launchUrl(
                              widget
                                  .model
                                  .message!
                                  .dependantIdDetails![widget.position!.toInt()]
                                  .attachment
                                  .toString(),
                              isNewTab: true);
                        }
                      },
                      child: Icon(Icons.visibility,
                          color: (widget.iseditable == true &&
                                  widget
                                      .model
                                      .message!
                                      .dependantIdDetails![
                                          widget.position!.toInt()]
                                      .attachment
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
                        if (element.isDenied || element.isPermanentlyDenied) {
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
            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }

  void adddocuments() {
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
      "type": "dependantIdDetails",
      "idTypeNo": typeNo,
      "idType": typeName,
      "idNo": idnumbercontroller.text,
      "dependantIdName": controllerrelationname.text,
      "companyName": controllercompanyname.text,
      "countryOfIssue": controllercountryissue.text,
      "issueDate": controllerissuedate.text,
      "expiryDate": controllerexpirydate.text,
      "designation": controllerdesignation.text,
      "remarks": remarks.text,
      "remainder": remainderval.toString() == "true" ? true : false,
      "remainderDate": controllerremainderdate.text,
      "attachmentUrl": attachmentURL,
      "attachmentID": attachmentID,
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
          AppUtils.showSingleDialogPopup(context,
              jsonDecode(response.body)['message'], "Ok", onexitpopup, null);
        }
      } else {
        throw Exception(jsonDecode(response.body)['message'].toString());
      }
    }).catchError((e) {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
      AppUtils.showSingleDialogPopup(
          context, e.toString(), "Ok", onexitpopup, null);
    });
  }

  void pickerdate(controller) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900), //.subtract(Duration(days: 1)),
        lastDate: DateTime(2100));
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      var dateFormate =
          DateFormat("dd/MM/yyyy").format(DateTime.parse(formattedDate));
      controller.text = dateFormate;
    }
  }

  void updatedocuments(String sid) {
    var json = {
      "type": "dependantIdDetails",
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
      "_id": sid,
      "internalid": widget.model.message!
          .dependantIdDetails![widget.position!.toInt()].internalid
          .toString(),
      "idTypeNo": typeNo,
      "idType": typeName,
      "idNo": idnumbercontroller.text,
      "dependantIdName": controllerrelationname.text,
      "companyName": controllercompanyname.text,
      "countryOfIssue": controllercountryissue.text,
      "issueDate": controllerissuedate.text,
      "expiryDate": controllerexpirydate.text,
      "designation": controllerdesignation.text,
      "remarks": remarks.text,
      "remainder": remainderval.toString() == "true" ? true : false,
      "remainderDate": controllerremainderdate.text,
      "attachmentUrl": attachmentURL,
      "attachmentID": attachmentID,
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
          AppUtils.showSingleDialogPopup(context,
              jsonDecode(response.body)['message'], "Ok", onexitpopup, null);
        }
      } else {
        throw Exception(jsonDecode(response.body)['message'].toString());
      }
    }).catchError((e) {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
      AppUtils.showSingleDialogPopup(
          context, e.toString(), "Ok", onexitpopup, null);
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
