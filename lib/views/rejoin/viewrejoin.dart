import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:winstar/models/error_model.dart';
import 'package:winstar/models/viewrejoinmodel.dart';
import 'package:winstar/domain/ApiService.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/custom_indicatoronly.dart';
import 'package:winstar/views/widgets/assets_image_widget.dart';

class ViewRejoin extends StatefulWidget {
  const ViewRejoin({super.key});

  @override
  State<ViewRejoin> createState() => _ViewRejoinState();
}

class _ViewRejoinState extends State<ViewRejoin> {
  ViewRejoinModel historymodel = ViewRejoinModel();
  ErrorModelNetSuite errormodel = ErrorModelNetSuite();
  bool loading = true;
  @override
  void initState() {
    getdetailsdata();
    super.initState();
  }

  @override
  void dispose() {
    loading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !loading
          ? historymodel.message != null
              ? SingleChildScrollView(
                  child: Column(children: [getdetails()]),
                )
              : const Center(child: Text('No Data!'))
          : const CustomIndicator(),
    );
  }

  Widget getdetails() {
    return historymodel.message != null
        ? ListView.builder(
            itemCount: historymodel.message!.length ?? 0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 3),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 0.5,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.white),
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppUtils.buildNormalText(
                                      text: "Expected Resume Date",
                                      fontSize: 12,
                                      color: Colors.grey.shade600),
                                  const SizedBox(height: 5),
                                  AppUtils.buildNormalText(
                                      text: historymodel.message![index]
                                          .expectedresumebackdate
                                          .toString(),
                                      fontSize: 14,
                                      color: Colors.black),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  AppUtils.buildNormalText(
                                      text: "Work Resume",
                                      fontSize: 12,
                                      color: Colors.grey.shade600),
                                  const SizedBox(height: 5),
                                  AppUtils.buildNormalText(
                                      text: historymodel
                                          .message![index].isworkresume
                                          .toString(),
                                      fontSize: 14,
                                      color: Colors.black),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  AppUtils.buildNormalText(
                                      text: "Is Leave Extended?",
                                      fontSize: 12,
                                      color: Colors.grey.shade600),
                                  const SizedBox(height: 5),
                                  AppUtils.buildNormalText(
                                      text: historymodel
                                          .message![index].isleaveextended
                                          .toString(),
                                      fontSize: 14,
                                      color: Colors.black),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                flex: 5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppUtils.buildNormalText(
                                        text: "Act Total Resume Delay Date",
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                    const SizedBox(height: 5),
                                    AppUtils.buildNormalText(
                                        text: historymodel
                                            .message![index].noofdaysdelay
                                            .toString(),
                                        fontSize: 14,
                                        color: Colors.black),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: "Work Resumption Done?",
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                    const SizedBox(height: 5),
                                    AppUtils.buildNormalText(
                                        text: "",
                                        fontSize: 12,
                                        color: Colors.black),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: "Act.Work Resume Date",
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                    const SizedBox(height: 5),
                                    AppUtils.buildNormalText(
                                        text: historymodel.message![index]
                                            .actualworkresumedate
                                            .toString(),
                                        fontSize: 14,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Colors.grey.shade300,
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : const Center(child: Text('No Data!'));
  }

  void getdetailsdata() async {
    setState(() {
      loading = true;
    });
    ApiService.viewrejoin().then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          historymodel = ViewRejoinModel.fromJson(jsonDecode(response.body));
        } else {
          // AppUtils.showSingleDialogPopup(
          //     context, jsonDecode(response.body)['message'], "Ok", onexitpopup);
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
