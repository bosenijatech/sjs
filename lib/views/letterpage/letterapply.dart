import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:winstar/models/copymodel.dart';
import 'package:winstar/domain/ApiService.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/appcolor.dart';
import 'package:winstar/utils/sharedprefconstants.dart';
import 'package:winstar/views/letterpage/lettertypemodel.dart';
import 'package:winstar/views/widgets/assets_image_widget.dart';
import 'package:winstar/views/widgets/custom_button.dart';

class LetterApplyPage extends StatefulWidget {
  const LetterApplyPage({super.key});

  @override
  State<LetterApplyPage> createState() => _LetterApplyPageState();
}

class _LetterApplyPageState extends State<LetterApplyPage> {
  final letterTypekey = GlobalKey<DropdownSearchState<LetterTypeModel>>();
  final copyTypekey = GlobalKey<DropdownSearchState<CopyTypeModel>>();

  TextEditingController reasoncontroller = TextEditingController();
  TextEditingController otherscontroller = TextEditingController();

  bool loading = false;
  LetterTypeModel? selectedType;

  CopyTypeModel? selectedCopyType;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    otherscontroller.dispose();
    reasoncontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AppUtils.buildNormalText(
            text: "Letter Request Application",
            color: Colors.black,
            fontSize: 20),
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child:
                  CupertinoActivityIndicator(radius: 30, color: Appcolor.black),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                buildDropdown(),
                const SizedBox(height: 15),
                buildTextField(
                  controller: otherscontroller,
                  label: "Address to *",
                  hint: "Address to*",
                  maxLines: 2,
                ),
                const SizedBox(height: 15),
                buildTextField(
                  controller: reasoncontroller,
                  label: "Purpose of letter",
                  hint: "Purpose of letter",
                  maxLines: 4,
                ),
                const SizedBox(height: 25),
                CustomButton(
                  onPressed: () {
                    if (selectedType == null) {
                      AppUtils.showSingleDialogPopup(
                          context, "Please choose a letter type", "Ok", () {
                        AppUtils.pop(context);
                      }, null);
                    }
                    if (selectedCopyType == null) {
                      AppUtils.showSingleDialogPopup(
                          context, "Please choose a copy to", "Ok", () {
                        AppUtils.pop(context);
                      }, null);
                    } else if (otherscontroller.text.isEmpty) {
                      AppUtils.showSingleDialogPopup(
                          context, "Please Enter ", "Ok", () {
                        AppUtils.pop(context);
                      }, null);
                    } else {
                      onpostletterrequest();
                    }
                  },
                  name: "Apply Letter Request",
                  circularvalue: 30,
                  fontSize: 14,
                ),
              ],
            ),
    );
  }

  Widget buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppUtils.buildNormalText(text: "Letter Type *", fontSize: 15),
        const SizedBox(height: 8),
        DropdownSearch<LetterTypeModel>(
          key: letterTypekey,
          selectedItem: selectedType,
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            interceptCallBacks: true,
          ),
          asyncItems: (String filter) =>
              ApiService.getLetterType(filter: filter),
          itemAsString: (LetterTypeModel item) => item.name.toString(),
          onChanged: (LetterTypeModel? item) {
            setState(() {
              selectedType = item;
            });
            print("Selected ID: ${selectedType?.id}");
          },
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              hintText: 'Letter Type *',
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
        const SizedBox(height: 10),
        AppUtils.buildNormalText(text: "Copy Type *", fontSize: 15),
        const SizedBox(height: 8),
        DropdownSearch<CopyTypeModel>(
          key: copyTypekey,
          selectedItem: selectedCopyType,
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            interceptCallBacks: true,
          ),
          asyncItems: (String filter) =>
              ApiService.getcopyTypeList(filter: filter),
          itemAsString: (CopyTypeModel item) => item.name.toString(),
          onChanged: (CopyTypeModel? item) {
            setState(() {
              selectedCopyType = item;
            });
            print("Selected ID: ${selectedCopyType?.id}");
          },
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              hintText: 'Copy To *',
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
      ],
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppUtils.buildNormalText(text: label, fontSize: 15),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.multiline,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xFF002B5B)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black26, width: 1),
            ),
          ),
        ),
      ],
    );
  }

  void onpostletterrequest() async {
    final currentyear =
        DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
    final currentdate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    var json = {
      "requestapplicationno":
          "Mob-Letter ${Prefs.getEmpID('empID')}-$currentyear",
      "date": currentdate,
      "lettertypecode": selectedType?.id ?? "",
      "lettertypename": selectedType?.name ?? "",
      "letteraddresstocode": otherscontroller.text,
      "letteraddresstoname": otherscontroller.text,
      "purpose": reasoncontroller.text,
      "attachment": "",
      "iscancelled": "N",
      "iscancelledreason": "",
      "iscancelleddate": "",
      "isstatus": "Pending",
      "createdby": Prefs.getNsID('nsid'),
      "createdDate": ApiService.mobilecurrentdate,
      "toEmpID": Prefs.getNsID('nsid'),
      "toEmpName": Prefs.getFullName('Name'),
      "isSync": 0,
      "NetsuiteRefNo": "",
      "NetsuiteRemarks": otherscontroller.text,
      "lineManagerId":
          Prefs.getLineManagerID(SharefprefConstants.sharedLinemanagerID),
      "copyTypeName": selectedCopyType?.name ?? "",
      "copyTypeId": selectedCopyType?.id ?? "",
    };

    setState(() => loading = true);
    ApiService.postletterrequest(json).then((response) {
      setState(() => loading = false);
      final res = jsonDecode(response.body);
      if (response.statusCode == 200 && res['status'].toString() == "true") {
        AppUtils.showSingleDialogPopup(context, res['message'], "Ok",
            onrefreshscreen, AssetsImageWidget.successimage);
      } else {
        AppUtils.showSingleDialogPopup(context, res['message'], "Ok",
            onexitpopup, AssetsImageWidget.warningimage);
      }
    }).catchError((e) {
      setState(() => loading = false);
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", onexitpopup,
          AssetsImageWidget.errorimage);
    });
  }

  void onexitpopup() {
    Navigator.of(context).pop();
  }

  void onrefreshscreen() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}
