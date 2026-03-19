import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winstar/models/assetnamemodel.dart';
import 'package:winstar/models/assettypemodel.dart';
import 'package:winstar/domain/ApiService.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/appcolor.dart';
import 'package:winstar/utils/constants.dart';
import 'package:winstar/utils/netsuite/netsuiteservice.dart';
import 'package:winstar/views/widgets/assets_image_widget.dart';
import 'package:winstar/views/widgets/custom_button.dart';
import 'package:intl/intl.dart';

class AssetApplyPage extends StatefulWidget {
  const AssetApplyPage({super.key});

  @override
  State<AssetApplyPage> createState() => _AssetApplyPageState();
}

class _AssetApplyPageState extends State<AssetApplyPage> {
  final assetTypekey = GlobalKey<DropdownSearchState<AssetTypeModel>>();
  final assetnamekey = GlobalKey<DropdownSearchState<AssetNameModel>>();

  AssetTypeModel? selectedAssetType;
  AssetNameModel? selectedName;

  bool? check1 = false;
  bool loading = false;
  TextEditingController remarkscontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    remarkscontroller.clear();
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
            text: "Asset Request Application",
            color: Colors.black,
            fontSize: 20),
        centerTitle: false,
      ),
      body: !loading
          ? SingleChildScrollView(
              child: Column(
                children: [getdetails()],
              ),
            )
          : const Center(
              child: CupertinoActivityIndicator(
                  radius: 30.0, color: Appcolor.twitterBlue),
            ),
    );
  }

  Widget getdetails() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppUtils.buildNormalText(text: "ASSET TYPE"),
          const SizedBox(
            height: 5,
          ),
          DropdownSearch<AssetTypeModel>(
            key: assetTypekey,
            selectedItem: selectedAssetType,
            popupProps: const PopupProps.menu(
              showSearchBox: true,
              interceptCallBacks: true,
            ),
            asyncItems: (String filter) =>
                ApiService.getAssetTypelist(filter: filter),
            itemAsString: (AssetTypeModel item) => item.name.toString(),
            onChanged: (AssetTypeModel? item) {
              setState(() {
                selectedAssetType = item;
              });
              print("Selected ID: ${selectedAssetType?.id}");
            },
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                hintText: 'Asset Type *',
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
          AppUtils.buildNormalText(text: "ASSET NAME"),
          const SizedBox(height: 10),
          DropdownSearch<AssetNameModel>(
            key: assetnamekey,
            selectedItem: selectedName,
            popupProps: const PopupProps.menu(
              showSearchBox: true,
              interceptCallBacks: true,
            ),
            asyncItems: (String filter) =>
                ApiService.getAssetNamelist(filter: filter),
            itemAsString: (AssetNameModel item) => item.name.toString(),
            onChanged: (AssetNameModel? item) {
              setState(() {
                selectedName = item;
              });
              print("Selected Name ID: ${selectedName?.id}");
            },
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                hintText: 'Asset Name *',
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
          AppUtils.buildNormalText(text: "REMARKS", fontSize: 15),
          const SizedBox(
            height: 20,
          ),
          Container(
              //padding: EdgeInsets.all(20),
              child: TextField(
            controller: remarkscontroller,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Enter Remarks",
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.grey)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.black26, width: 1),
              ),
            ),
          )),
          const SizedBox(
            height: 20,
          ),
          CustomButton(
            onPressed: () {
              onpostletterrequest();
            },
            name: "Apply Asset Request",
            circularvalue: 30,
            fontSize: 16,
          )
        ],
      ),
    );
  }

  void onpostletterrequest() async {
    DateTime now = DateTime.now();
    DateTime currentyear = DateTime(now.year);
    var currentdate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var json = {
      "assetrequestapplicationno":
          "MASSET-${Prefs.getEmpID('empID').toString()}-${Prefs.getUserName('username').toString()}-$currentdate",
      "date": ApiService.mobilecurrentdate,
      "assettypecode": selectedAssetType?.id ?? "",
      "assettypename": selectedAssetType?.name ?? "",
      "assetcode": selectedName?.id ?? "",
      "assetname": selectedName?.name ?? "",
      "remarks": remarkscontroller.text,
      "attachment": "",
      "iscancelled": "N",
      "iscancelledreason": "",
      "iscancelleddate": "",
      "isstatus": "Pending",
      "createdby": Prefs.getNsID('nsid'),
      "createdByEmpName": Prefs.getFullName('Name'),
      "createdDate": ApiService.mobilecurrentdate,
      "toEmpID": Prefs.getNsID('nsid'),
      "toEmpName": Prefs.getFullName('Name'),
      "isSync": 0,
    };
    print(jsonEncode(json));
    setState(() {
      loading = true;
    });
    ApiService.postassetrequest(json).then((response) {
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
          if (!mounted) return;
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

  void onexitpopup() {
    Navigator.of(context).pop();
  }

  void onrefreshscreen() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}
