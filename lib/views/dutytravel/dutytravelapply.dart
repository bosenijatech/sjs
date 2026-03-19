import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:winstar/models/travelrequesttypemodel.dart';
import 'package:winstar/models/traveltypemodel.dart';
import 'package:winstar/domain/ApiService.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/appcolor.dart';
import 'package:winstar/utils/constants.dart';
import 'package:winstar/utils/custom_indicatoronly.dart';
import 'package:winstar/utils/netsuite/netsuiteservice.dart';
import 'package:winstar/utils/sharedprefconstants.dart';
import 'package:winstar/views/widgets/assets_image_widget.dart';
import 'package:winstar/views/widgets/custom_button.dart';
import 'package:intl/intl.dart';

class DutyTravelApplyPage extends StatefulWidget {
  const DutyTravelApplyPage({super.key});

  @override
  State<DutyTravelApplyPage> createState() => _DutyTravelApplyPageState();
}

class _DutyTravelApplyPageState extends State<DutyTravelApplyPage> {
  List<String> travelpurposelist = [];

  List<String> travelmodelist = [];

  bool? hotelroomrequired = false;
  bool? traveladvancerequired = false;
  bool? airporttransferrequired = false;
  bool? visarequired = false;
  bool? iscarrentalrequired = false;

  bool loading = false;
  String gettravelrpurposename = "";
  String gettravelpurposeid = "";

  String getmodeoftravelname = "";
  String getmodeoftravelid = "";

  TextEditingController proposedtraveldatecontroller = TextEditingController();
  TextEditingController depaturedatecontroller = TextEditingController();
  TextEditingController returndatecontroller = TextEditingController();
  TextEditingController destinationsectorcontroller = TextEditingController();
  TextEditingController citycontroller = TextEditingController();
  TextEditingController expensecontroller = TextEditingController();
  TextEditingController commentscontroller = TextEditingController();

  TextEditingController subproposedtraveldatecontroller =
      TextEditingController();
  TextEditingController subdepaturedatecontroller = TextEditingController();

  TextEditingController subreturndatecontroller = TextEditingController();
  TravelRequestModel travelRequestModel = TravelRequestModel();
  TravelTypeModel travelTypeModeModel = TravelTypeModel();
  TextEditingController durationcontroller = TextEditingController();
  TextEditingController accomdationcontroller = TextEditingController();
  @override
  void initState() {
    gettravelpurpose();
    gettravelmode();
    super.initState();
  }

  @override
  void dispose() {
    proposedtraveldatecontroller.clear();
    depaturedatecontroller.clear();
    returndatecontroller.clear();
    destinationsectorcontroller.clear();
    citycontroller.clear();
    expensecontroller.clear();
    commentscontroller.clear();
    subproposedtraveldatecontroller.clear();
    subdepaturedatecontroller.clear();
    subreturndatecontroller.clear();
    durationcontroller.clear();
    accomdationcontroller.clear();
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
            text: "Duty Travel", color: Colors.black, fontSize: 20),
        centerTitle: false,
      ),
      body: !loading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [getwidgetdetails()],
                    ),
                  ),
                ),
              ],
            )
          : const CustomIndicator(),
      persistentFooterButtons: [
        CustomButton(
          onPressed: () {
            if (proposedtraveldatecontroller.text.isEmpty) {
              AppUtils.showSingleDialogPopup(
                  context,
                  "Please Choose Proposed Travel Date!.",
                  "Ok",
                  onexitpopup,
                  AssetsImageWidget.warningimage);
            } else if (depaturedatecontroller.text.isEmpty) {
              AppUtils.showSingleDialogPopup(
                  context,
                  "Please Choose Depature Date!.",
                  "Ok",
                  onexitpopup,
                  AssetsImageWidget.warningimage);
            } else if (depaturedatecontroller.text.isEmpty) {
              AppUtils.showSingleDialogPopup(context, "Proposed Travel Date!.",
                  "Ok", onexitpopup, AssetsImageWidget.warningimage);
            } else {
              onpostdutytravel();
            }
          },
          name: "Submit Duty Travel",
          circularvalue: 30,
          fontSize: 14,
        )
      ],
    );
  }

  Widget getwidgetdetails() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),

          AppUtils.buildNormalText(text: "Travel Purpose", fontSize: 15),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DropdownSearch<String>(
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                showSelectedItems: true,
              ),
              items: travelpurposelist,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  labelText: '',
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
                for (int kk = 0;
                    kk < travelRequestModel.records!.length;
                    kk++) {
                  if (travelRequestModel.records![kk].name.toString() == val) {
                    gettravelrpurposename =
                        travelRequestModel.records![kk].name.toString();
                    gettravelpurposeid =
                        travelRequestModel.records![kk].id.toString();
                    setState(() {});
                  }
                }
              },
              selectedItem: gettravelrpurposename,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          AppUtils.buildNormalText(text: "Travel Mode", fontSize: 15),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DropdownSearch<String>(
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                showSelectedItems: true,
              ),
              items: travelmodelist,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  labelText: '',
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
                for (int kk = 0;
                    kk < travelTypeModeModel.records!.length;
                    kk++) {
                  if (travelTypeModeModel.records![kk].name.toString() == val) {
                    getmodeoftravelname =
                        travelTypeModeModel.records![kk].name.toString();
                    getmodeoftravelid =
                        travelTypeModeModel.records![kk].id.toString();
                    setState(() {});
                  }
                }
              },
              selectedItem: getmodeoftravelname,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          AppUtils.buildNormalText(text: "Proposed Travel Date", fontSize: 15),
          const SizedBox(
            height: 5,
          ),
          TextField(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(), //.subtract(Duration(days: 1)),
                  lastDate: DateTime(2100));

              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);

                var dateFormate = DateFormat("dd-MM-yyyy")
                    .format(DateTime.parse(formattedDate));

                proposedtraveldatecontroller.text = dateFormate;

                subproposedtraveldatecontroller.text = formattedDate;
              }
            },
            controller: proposedtraveldatecontroller,
            readOnly: true,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              labelText: '',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Appcolor.primarycolor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Appcolor.primarycolor, width: 1),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          AppUtils.buildNormalText(text: "Depature Date", fontSize: 15),
          const SizedBox(
            height: 5,
          ),
          TextField(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(), //.subtract(Duration(days: 1)),
                  lastDate: DateTime(2100));

              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);

                var dateFormate = DateFormat("dd-MM-yyyy")
                    .format(DateTime.parse(formattedDate));

                depaturedatecontroller.text = dateFormate;

                subdepaturedatecontroller.text = formattedDate;
                if (depaturedatecontroller.text.isEmpty &&
                    returndatecontroller.text.isEmpty) {
                } else {
                  durationcontroller.text = AppConstants.daysBetween(
                          subdepaturedatecontroller.text.toString(),
                          subreturndatecontroller.text.toString())
                      .toString();
                }
              }
            },
            controller: depaturedatecontroller,
            readOnly: true,
            decoration: InputDecoration(
              labelText: '',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Appcolor.primarycolor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Appcolor.primarycolor, width: 1),
              ),
            ),
          ),

          const SizedBox(
            height: 10,
          ),
          AppUtils.buildNormalText(text: "Returned Date", fontSize: 15),
          const SizedBox(
            height: 5,
          ),
          TextField(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(), //.subtract(Duration(days: 1)),
                  lastDate: DateTime(2100));
              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                var dateFormate = DateFormat("dd-MM-yyyy")
                    .format(DateTime.parse(formattedDate));
                returndatecontroller.text = dateFormate;
                subreturndatecontroller.text = formattedDate;
                if (depaturedatecontroller.text.isEmpty &&
                    returndatecontroller.text.isEmpty) {
                } else {
                  durationcontroller.text = AppConstants.daysBetween(
                          subdepaturedatecontroller.text.toString(),
                          subreturndatecontroller.text.toString())
                      .toString();
                }
              }
            },
            controller: returndatecontroller,
            readOnly: true,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              labelText: '',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Appcolor.primarycolor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Appcolor.primarycolor, width: 1),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // CheckboxListTile(
          //   contentPadding: const EdgeInsets.all(0),
          //   shape: const CircleBorder(),
          //   title: AppUtils.buildNormalText(
          //       text: 'Hotel Room Required',
          //       fontSize: 14,
          //       overflow: TextOverflow.ellipsis),
          //   value: hotelroomrequired,
          //   onChanged: (bool? value) {
          //     setState(() {
          //       hotelroomrequired = value;
          //     });
          //   },
          //   controlAffinity: ListTileControlAffinity.leading,
          //   activeColor: Appcolor.primarycolor,
          //   checkboxShape:
          //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          // ),
          // const SizedBox(
          //   height: 5,
          // ),
          AppUtils.buildNormalText(text: "Duration", fontSize: 15),
          const SizedBox(
            height: 5,
          ),
          TextField(
            controller: durationcontroller,
            readOnly: true,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              labelText: '',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Appcolor.primarycolor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Appcolor.primarycolor, width: 1),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          CheckboxListTile(
            contentPadding: const EdgeInsets.all(0),
            shape: const CircleBorder(),
            title: AppUtils.buildNormalText(
                text: 'Advance Required',
                fontSize: 14,
                overflow: TextOverflow.ellipsis),
            value: traveladvancerequired,
            onChanged: (bool? value) {
              setState(() {
                traveladvancerequired = value;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Appcolor.primarycolor,
            checkboxShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          const SizedBox(
            height: 5,
          ),
          AppUtils.buildNormalText(text: "Destination", fontSize: 15),
          const SizedBox(
            height: 5,
          ),
          TextField(
            maxLength: 100,
            controller: destinationsectorcontroller,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              labelText: '',
              counterText: "",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Appcolor.primarycolor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Appcolor.primarycolor, width: 1),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          AppUtils.buildNormalText(text: "Flight Details", fontSize: 15),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: citycontroller,
            maxLength: 100,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              labelText: '',
              counterText: "",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Appcolor.primarycolor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Appcolor.primarycolor, width: 1),
              ),
            ),
          ),
          AppUtils.buildNormalText(text: "Accomdation Details", fontSize: 15),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: accomdationcontroller,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            maxLength: 500,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              counterText: '',
              labelText: '',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Appcolor.primarycolor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Appcolor.primarycolor, width: 1),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 5,
          ),
          AppUtils.buildNormalText(text: "Estimated Total Cost", fontSize: 15),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            maxLength: 10,
            controller: expensecontroller,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true, signed: false),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
            ],
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              counterText: '',
              labelText: '',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Appcolor.primarycolor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Appcolor.primarycolor, width: 1),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),

          AppUtils.buildNormalText(text: "Remarks", fontSize: 15),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: commentscontroller,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: "Enter Remarks",
              counterText: '',
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.grey)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.black26, width: 1),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void gettravelpurpose() async {
    setState(() {
      loading = true;
    });
    try {
      Uri baseUri = Uri.parse(
          '${AppConstants.netSuiteapiBaseUrl}script=${AppConstants.travelpurposcriptid}&deploy=${AppConstants.travelpurposedeployid}');
      await NetSuiteApiService.client.get(baseUri).then((response) {
        setState(() {
          loading = false;
        });
        if (response.statusCode == 200) {
          travelRequestModel = TravelRequestModel.fromJson(
              json.decode(json.decode(response.body)));
          travelpurposelist.clear();
          for (int i = 0; i < travelRequestModel.records!.length; i++) {
            if (travelRequestModel.records![i].inactive.toString() == "false") {
              travelpurposelist
                  .add(travelRequestModel.records![i].name.toString());
            }
          }
        } else {
          AppUtils.showSingleDialogPopup(
              context,
              json.decode(json.decode(response.body)),
              "Ok",
              onexitpopup,
              AssetsImageWidget.warningimage);
        }
      });
    } on Exception catch (_) {
      setState(() {
        loading = false;
      });
      rethrow;
    }
  }

  void gettravelmode() async {
    setState(() {
      loading = true;
    });
    try {
      Uri baseUri = Uri.parse(
          '${AppConstants.netSuiteapiBaseUrl}script=${AppConstants.travelmodesciptid}&deploy=${AppConstants.travelmodedeployid}');
      await NetSuiteApiService.client.get(baseUri).then((response) {
        setState(() {
          loading = false;
        });
        if (response.statusCode == 200) {
          travelTypeModeModel =
              TravelTypeModel.fromJson(json.decode(json.decode(response.body)));

          travelmodelist.clear();
          for (int i = 0; i < travelTypeModeModel.records!.length; i++) {
            if (travelTypeModeModel.records![i].inactive.toString() ==
                "false") {
              travelmodelist
                  .add(travelTypeModeModel.records![i].name.toString());
            }
          }
        } else {
          AppUtils.showSingleDialogPopup(
              context,
              json.decode(json.decode(response.body)),
              "Ok",
              onexitpopup,
              AssetsImageWidget.warningimage);
        }
      });
    } on Exception catch (_) {
      setState(() {
        loading = false;
      });
      rethrow;
    }
  }

  void onpostdutytravel() async {
    DateTime now = DateTime.now();
    DateTime currentyear = DateTime(now.year);

    var json = {
      "leaveapplicaitonno":
          "MDUTY-${Prefs.getEmpID('empID').toString()}-${Prefs.getUserName('username').toString()}-${currentyear.year}",
      "date": ApiService.mobilecurrentdate,
      "travelrequestcode": gettravelpurposeid,
      "travelrequestname": gettravelrpurposename.toString(),
      "travelmodecode": getmodeoftravelid.toString(),
      "travelmodename": getmodeoftravelname.toString(),
      "proposedtraveldate": subproposedtraveldatecontroller.text,
      "depaturedate": subdepaturedatecontroller.text,
      "returneddate": subreturndatecontroller.text,
      "duration": durationcontroller.text,
      "advancerequired": traveladvancerequired,
      "destination": destinationsectorcontroller.text.toString(),
      "flight_details": citycontroller.text,
      "accomptation_details": accomdationcontroller.text.toString(),
      "estimateexpenseamount": expensecontroller.text ?? 0,
      "remarks": commentscontroller.text,
      "attachment": "",
      "iscancelled": "N",
      "iscancelledreason": "",
      "iscancelleddate": "",
      "isstatus": "Pending",
      "createdby": Prefs.getNsID('nsid'),
      "createdbyName": Prefs.getFullName(SharefprefConstants.shareFullName),
      "createdDate": ApiService.mobilecurrentdate,
      "isSync": 1,
    };
    setState(() {
      loading = true;
    });
    ApiService.postdutytravelrequest(json).then((response) {
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

  void onexitpopup() {
    Navigator.of(context).pop();
  }

  void onrefreshscreen() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}
