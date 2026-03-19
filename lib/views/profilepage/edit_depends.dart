import 'dart:convert';

import 'package:winstar/views/leave/homepage.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winstar/models/empinfomodel.dart';
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

import 'package:intl/intl.dart';

class EditDepends extends StatefulWidget {
  final EmpInfoModel model;
  final bool? iseditable;
  final int? position;
  const EditDepends(
      {super.key,
      required this.model,
      required this.iseditable,
      required this.position});

  @override
  State<EditDepends> createState() => _EditDependsState();
}

class _EditDependsState extends State<EditDepends> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController dobcontroller = TextEditingController();
  TextEditingController phonenumbercontroller = TextEditingController();
  TextEditingController relationshipcontroller = TextEditingController();
  TextEditingController insurancecontroller = TextEditingController();
  TextEditingController airTicketcontroller = TextEditingController();
  TextEditingController educationAllowancecontroller = TextEditingController();

  RelationShipModel? selectedRelationship;

  String? airticketEligible;
  String? insuranceEligiable;
  String? educationallowance;
  bool loading = false;
  String? relationName;
  String? relationId;
  @override
  void initState() {
    if (widget.iseditable == true) {
      namecontroller.text = widget.model.message!
          .dependantDetails![widget.position!.toInt()].dependantName
          .toString();
      dobcontroller.text = widget
          .model.message!.dependantDetails![widget.position!.toInt()].dob
          .toString();
      phonenumbercontroller.text = widget
          .model.message!.dependantDetails![widget.position!.toInt()].phoneNo
          .toString();
      relationshipcontroller.text = widget.model.message!
          .dependantDetails![widget.position!.toInt()].relationship
          .toString();
      insurancecontroller.text = widget
          .model.message!.dependantDetails![widget.position!.toInt()].insurance
          .toString();
      airTicketcontroller.text = widget
          .model.message!.dependantDetails![widget.position!.toInt()].airTicket
          .toString();

      educationAllowancecontroller.text = widget.model.message!
          .dependantDetails![widget.position!.toInt()].educationAllowance
          .toString();

      insuranceEligiable = widget
          .model.message!.dependantDetails![widget.position!.toInt()].insurance
          .toString();
      airticketEligible = widget
          .model.message!.dependantDetails![widget.position!.toInt()].airTicket
          .toString();

      selectedRelationship = RelationShipModel(
          id: widget.model.message!.dependantDetails![widget.position!.toInt()]
              .relationshipId
              .toString(),
          name: widget.model.message!
              .dependantDetails![widget.position!.toInt()].relationship
              .toString(),
          inactive: false);

      relationName = widget.model.message!
          .dependantDetails![widget.position!.toInt()].relationship
          .toString();

      relationId = widget.model.message!
          .dependantDetails![widget.position!.toInt()].relationshipId
          .toString();

      educationallowance = widget.model.message!
          .dependantDetails![widget.position!.toInt()].educationAllowance
          .toString();
    } else {
      namecontroller.text = "";
      dobcontroller.text = "";
      phonenumbercontroller.text = "";
      relationshipcontroller.text = "";
      insurancecontroller.text = "";
      airTicketcontroller.text = "";
      educationAllowancecontroller.text = "";
      insuranceEligiable = "";
      airticketEligible = "";
      relationName = "";
      educationallowance = "";
    }
    super.initState();
  }

  @override
  void dispose() {
    namecontroller.dispose();
    dobcontroller.dispose();
    phonenumbercontroller.dispose();
    relationshipcontroller.dispose();
    insurancecontroller.dispose();
    airTicketcontroller.dispose();
    educationAllowancecontroller = TextEditingController();
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
            text: "Dependents", color: Colors.black, fontSize: 20),
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
            if (namecontroller.text.isEmpty) {
              AppUtils.showSingleDialogPopup(context, "Please Enter Name", "Ok",
                  onexitpopup, AssetsImageWidget.warningimage);
            } else if (dobcontroller.text.isEmpty) {
              AppUtils.showSingleDialogPopup(context, "Please Choose DOB ",
                  "Ok", onexitpopup, AssetsImageWidget.warningimage);
            } else if (relationName.toString().isEmpty ||
                relationName.toString() == "null") {
              AppUtils.showSingleDialogPopup(context, "Please Choose Relation ",
                  "Ok", onexitpopup, AssetsImageWidget.warningimage);
            } else if (phonenumbercontroller.text.toString().isEmpty) {
              AppUtils.showSingleDialogPopup(
                  context,
                  "Please Enter Mobile No. ",
                  "Ok",
                  onexitpopup,
                  AssetsImageWidget.warningimage);
            } else if (insuranceEligiable.toString() == "null" ||
                insuranceEligiable.toString().isEmpty) {
              AppUtils.showSingleDialogPopup(
                  context,
                  "Please Choose Insurance ",
                  "Ok",
                  onexitpopup,
                  AssetsImageWidget.warningimage);
            } else if (airticketEligible.toString() == "null" ||
                airticketEligible.toString().isEmpty) {
              AppUtils.showSingleDialogPopup(
                  context,
                  "Please Choose AirTicket ",
                  "Ok",
                  onexitpopup,
                  AssetsImageWidget.warningimage);
            } else if (educationallowance.toString() == "null" ||
                educationallowance.toString().isEmpty) {
              AppUtils.showSingleDialogPopup(
                  context,
                  "Please Choose Education Allowance ",
                  "Ok",
                  onexitpopup,
                  AssetsImageWidget.warningimage);
            } else if (widget.iseditable == true) {
              updatedocuments(widget.model.message!
                  .dependantDetails![widget.position!.toInt()].sId
                  .toString());
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

  Widget getwidget() {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              textCapitalization: TextCapitalization.characters,
              controller: namecontroller,
              maxLength: 100,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Name',
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
              controller: dobcontroller,
              maxLength: 100,
              readOnly: true,
              onTap: () {
                pickerdate(dobcontroller);
              },
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Date Of Birth',
                icon: Icon(Icons.join_full, color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 35,
              ),
              child: DropdownSearch<RelationShipModel>(
                selectedItem: selectedRelationship,
                validator: (value) {
                  if (value == null) {
                    return 'Please select relationship';
                  }
                  return null;
                },
                asyncItems: (String filter) =>
                    ApiService.getrelationshiplist(filter: filter),
                itemAsString: (RelationShipModel item) => item.name,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      relationName = value.name;
                      relationId = value.id;
                    });
                  }
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Select Relationship",
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
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: phonenumbercontroller,
              maxLength: 100,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Phone No',
                icon: Icon(Icons.join_full, color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(
              height: 10,
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
                        labelText: "Insurance Eligiblity",
                        hintText: "country in menu mode",
                      ),
                    ),
                    onChanged: (values) {
                      insuranceEligiable = values;
                    },
                    selectedItem: insuranceEligiable)),
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
                        labelText: "Airticket Eligiblity",
                      ),
                    ),
                    onChanged: (values) {
                      airticketEligible = values;
                    },
                    selectedItem: airticketEligible)),
            const SizedBox(
              height: 10,
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
                        labelText: "Education Allowance",
                      ),
                    ),
                    onChanged: (values) {
                      educationallowance = values;
                      print(educationallowance);
                    },
                    selectedItem: educationallowance)),
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
      "type": "dependantDetails",
      "dependantName": namecontroller.text.toString(),
      "dob": dobcontroller.text,
      "phoneNo": phonenumbercontroller.text,
      "relationship": relationName,
      "relationshipId": relationId,
      "insurance": insuranceEligiable.toString() == "true" ? true : false,
      "airTicket": airticketEligible.toString() == "true" ? true : false,
      "address": "",
      "educationAllowance":
          educationallowance.toString() == "true" ? true : false,
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
      "type": "dependantDetails",
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
      "internalid": widget
          .model.message!.dependantDetails![widget.position!.toInt()].internalid
          .toString(),
      "dependantName": namecontroller.text.toString(),
      "dob": dobcontroller.text,
      "phoneNo": phonenumbercontroller.text,
      "relationship": relationName,
      "relationshipId": relationId,
      "insurance": insuranceEligiable.toString() == "true" ? true : false,
      "airTicket": airticketEligible.toString() == "true" ? true : false,
      "address": "",
      "educationAllowance":
          educationallowance.toString() == "true" ? true : false
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
}
