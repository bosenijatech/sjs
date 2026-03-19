import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winstar/models/viewdutytravelmodel.dart';
import 'package:winstar/routenames.dart';
import 'package:winstar/domain/ApiService.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/constants.dart';
import 'package:winstar/utils/custom_indicatoronly.dart';
import 'package:winstar/views/widgets/assets_image_widget.dart';
import 'package:winstar/views/widgets/colorstatus.dart';
import 'package:winstar/views/widgets/custom_button.dart';

class DutyTravelDetailsPage extends StatefulWidget {
  const DutyTravelDetailsPage({super.key});

  @override
  State<DutyTravelDetailsPage> createState() => _DutyTravelDetailsPageState();
}

class _DutyTravelDetailsPageState extends State<DutyTravelDetailsPage> {
  bool loading = false;
  ViewDutytravelModel dutytravelModel = ViewDutytravelModel();

  @override
  void initState() {
    getdetailsdata();
    super.initState();
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
            text: "Duty Travel Details", color: Colors.black, fontSize: 20),
        centerTitle: true,
      ),
      body: !loading
          ? dutytravelModel.message!.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    children: [builderwidget()],
                  ),
                )
              : Center(
                  child: Image.asset(
                  'assets/images/nodata1.png',
                  height: 200,
                  width: 200,
                ))
          : const CustomIndicator(),
      persistentFooterButtons: [
        CustomButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.dutytravelapply)
                  .then((_) {
                setState(() {
                  getdetailsdata();
                });
              });
            },
            name: "Click to Apply Duty Travel Request",
            fontSize: 14,
            circularvalue: 30)
      ],
    );
  }

  Widget builderwidget() {
    return dutytravelModel.message!.isNotEmpty
        ? ListView.builder(
            itemCount: dutytravelModel.message!.length ?? 0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 0.5,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Theme(
                  data: ThemeData(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    iconColor: Colors.black,
                    initiallyExpanded: false,
                    // leading: Container(
                    //   decoration: BoxDecoration(
                    //       color: Appcolor.twitterBlue.withOpacity(0.2),
                    //       borderRadius: BorderRadius.circular(50)),
                    //   child: IconButton(
                    //     onPressed: () {},
                    //     icon: const Icon(
                    //       CupertinoIcons.person_alt,
                    //       color: Appcolor.twitterBlue,
                    //       size: 14,
                    //     ),
                    //   ),
                    // ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppUtils.buildNormalText(
                            text: dutytravelModel.message![index].createdbyName
                                .toString(),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        statusPendingColor(
                            text: dutytravelModel.message![index].isstatus
                                .toString())
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                text: AppConstants.convertdateformat(
                                    dutytravelModel.message![index].createdDate
                                        .toString()
                                        .substring(0, 10)),
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                                children: <InlineSpan>[
                                  const WidgetSpan(
                                      alignment: PlaceholderAlignment.baseline,
                                      baseline: TextBaseline.alphabetic,
                                      child: SizedBox(width: 10)),
                                  TextSpan(
                                      text: dutytravelModel
                                          .message![index].internalid
                                          .toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue)),
                                ],
                              ),
                            )
                          ],
                        ),
                        // AppUtils.buildNormalText(
                        //     text:
                        //         "Requested on  ${AppConstants.convertdateformat(dutytravelModel.message![index].createdDate.toString())}"),
                        dutytravelModel
                                .message![index].approvalHistory!.isNotEmpty
                            ? ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 0.0),
                                dense: true,
                                onTap: () {
                                  showSheet(context, index);
                                },
                                trailing: const Icon(Icons.remove_red_eye),
                                title: const Text("Approved History",
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500)),
                              )
                            : Container(),
                      ],
                    ),
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppUtils.buildNormalText(
                                        text: 'Travel Type'),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: dutytravelModel
                                            .message![index].travelrequestname
                                            .toString(),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ],
                                ),
                              ),
                              Container(
                                width: 0.5,
                                height: 40,
                                color: Colors.black.withOpacity(0.3),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    AppUtils.buildNormalText(
                                        text: 'Travel Mode'),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: dutytravelModel
                                            .message![index].travelmodename
                                            .toString(),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ],
                                ),
                              ),
                              Container(
                                width: 0.5,
                                height: 40,
                                color: Colors.black.withOpacity(0.3),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    AppUtils.buildNormalText(
                                        text: 'Esimated Expenses'),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: dutytravelModel.message![index]
                                            .estimateexpenseamount
                                            .toString(),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppUtils.buildNormalText(
                                        text: 'Proposed  Travel date'),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: AppConstants.changeddmmyyformat(
                                            dutytravelModel.message![index]
                                                .proposedtraveldate
                                                .toString()
                                                .substring(0, 10)),
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ],
                                ),
                              ),
                              Container(
                                width: 0.5,
                                height: 40,
                                color: Colors.black.withOpacity(0.3),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    AppUtils.buildNormalText(
                                        text: 'Depature Date'),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: AppConstants.changeddmmyyformat(
                                            dutytravelModel
                                                .message![index].depaturedate
                                                .toString()
                                                .substring(0, 10)),
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ],
                                ),
                              ),
                              Container(
                                width: 0.5,
                                height: 40,
                                color: Colors.black.withOpacity(0.3),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    AppUtils.buildNormalText(
                                        text: 'Return Date'),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: AppConstants.changeddmmyyformat(
                                            dutytravelModel
                                                .message![index].returneddate
                                                .toString()
                                                .substring(0, 10)),
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppUtils.buildNormalText(text: 'Duration'),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: dutytravelModel
                                            .message![index].duration
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ],
                                ),
                              ),
                              Container(
                                width: 0.5,
                                height: 40,
                                color: Colors.black.withOpacity(0.3),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    AppUtils.buildNormalText(
                                        text: 'Travel Advance'),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: dutytravelModel.message![index]
                                                    .advancerequired
                                                    .toString() ==
                                                "false"
                                            ? "No"
                                            : "Yes",
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ],
                                ),
                              ),
                              Container(
                                width: 0.5,
                                height: 40,
                                color: Colors.black.withOpacity(0.3),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    AppUtils.buildNormalText(
                                        text: 'Desitnation ',
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: dutytravelModel
                                            .message![index].destination
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppUtils.buildNormalText(
                              text: dutytravelModel
                                  .message![index].accomptationDetails,
                              maxLines: 2,
                              fontSize: 14),
                          const SizedBox(
                            height: 15,
                          ),
                          AppUtils.buildNormalText(
                              text: dutytravelModel.message![index].remarks,
                              maxLines: 2,
                              fontSize: 14)
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            })
        : Center(
            child: Image.asset(
            'assets/images/nodata1.png',
            height: 200,
            width: 200,
          ));
  }

  void showSheet(context, index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                AppUtils.gethanger(context),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        dutytravelModel.message![index].approvalHistory!.length,
                    itemBuilder: (BuildContext context, int index1) {
                      return Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 3),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade50,
                            width: 0.5,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                appovalPending(
                                    text: dutytravelModel.message![index]
                                        .approvalHistory![index1].status
                                        .toString()),
                                const SizedBox(width: 10),
                                AppUtils.buildNormalText(
                                    text: dutytravelModel.message![index]
                                                .approvalHistory![index1].status
                                                .toString() ==
                                            "Approved"
                                        ? "Approved By"
                                        : dutytravelModel
                                                    .message![index]
                                                    .approvalHistory![index1]
                                                    .status
                                                    .toString() ==
                                                "Rejected"
                                            ? "Rejected"
                                            : "Pending"),
                                const SizedBox(width: 10),
                                AppUtils.buildNormalText(
                                    text: dutytravelModel.message![index]
                                        .approvalHistory![index1].approvername
                                        .toString(),
                                    fontSize: 14),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AppUtils.buildNormalText(
                                text: dutytravelModel.message![index]
                                    .approvalHistory![index1].approveddate
                                    .toString()),
                            const SizedBox(
                              height: 10,
                            ),
                            AppUtils.buildNormalText(
                                text: dutytravelModel.message![index]
                                    .approvalHistory![index1].remarks
                                    .toString()),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          );
        });
  }

  void getdetailsdata() async {
    setState(() {
      loading = true;
    });
    ApiService.viewtravelduty().then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          dutytravelModel =
              ViewDutytravelModel.fromJson(jsonDecode(response.body));
        } else {
          // AppUtils.showSingleDialogPopup(
          //     context, jsonDecode(response.body)['message'], "Ok", onexitpopup);
          dutytravelModel.message = [];
        }
      } else {
        throw Exception(jsonDecode(response.body).toString()).toString();
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
}
