import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:winstar/models/viewleavemodel.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/constants.dart';
import 'package:winstar/utils/custom_indicatoronly.dart';
import 'package:winstar/views/widgets/colorstatus.dart';
import 'package:path_provider/path_provider.dart';

class SingleViewLeavePage extends StatefulWidget {
  ViewLeaveModel leavemodel;
  int position = 0;
  SingleViewLeavePage(
      {super.key, required this.leavemodel, required this.position});

  @override
  State<SingleViewLeavePage> createState() => _SingleViewLeavePageState();
}

class _SingleViewLeavePageState extends State<SingleViewLeavePage> {
  Uint8List? bytesImage;
  String? filePath;
  bool loading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppUtils.buildNormalText(
            text: "Leave Application Details",
            fontSize: 16,
            color: Colors.black),
      ),
      body: !loading
          ? const SingleChildScrollView(
              child: Column(
                children: [],
              ),
            )
          : const CustomIndicator(),
    );
  }

  Widget ticketheadertop1() {
    return widget.leavemodel.message != null
        ? Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0xFFD4CEFE),
                      offset: Offset(0, 7),
                      blurRadius: 15)
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                widget.leavemodel.message![widget.position].attachment!.first
                        .fileType
                        .toString()
                        .contains("pdf")
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 400,
                        child: PDFView(
                          filePath: filePath,
                          enableSwipe: true,
                          swipeHorizontal: true,
                          autoSpacing: false,
                          pageFling: false,
                          onRender: (pages) {
                            setState(() {
                              pages = pages;
                            });
                          },
                          onError: (error) {
                            print(error.toString());
                          },
                          onPageError: (page, error) {
                            print('$page: ${error.toString()}');
                          },
                          onPageChanged: (page, total) {
                            print('page change: $page/$total');
                          },
                        ),
                      )
                    : AspectRatio(
                        aspectRatio: 2, child: Image.memory(bytesImage!)),
              ],
            ),
          )
        : Container();
  }

  Widget headerdetails() {
    return widget.leavemodel.message != null
        ? Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0xFFD4CEFE),
                      offset: Offset(0, 7),
                      blurRadius: 15)
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: statusPendingColor(
                      text: widget.leavemodel.message![widget.position].isstatus
                          .toString()),
                ),
                Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppUtils.buildNormalText(
                            text: "Leave Application No", color: Colors.grey),
                        const SizedBox(
                          height: 5,
                        ),
                        AppUtils.buildNormalText(
                            text: "Leave Application Date", color: Colors.grey),
                        const SizedBox(
                          height: 5,
                        ),
                        AppUtils.buildNormalText(
                            text: "Leave From and To", color: Colors.grey),
                        const SizedBox(
                          height: 5,
                        ),
                        AppUtils.buildNormalText(
                            text: "No of Days Leave", color: Colors.grey),
                        const SizedBox(
                          height: 5,
                        ),
                        AppUtils.buildNormalText(
                            text: "Applied By", color: Colors.grey),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppUtils.buildNormalText(
                            text: widget.leavemodel.message![widget.position]
                                .leaveapplicationno
                                .toString()),
                        const SizedBox(
                          height: 5,
                        ),
                        AppUtils.buildNormalText(
                            text: widget
                                .leavemodel.message![widget.position].date
                                .toString()),
                        const SizedBox(
                          height: 5,
                        ),
                        AppUtils.buildNormalText(
                            text:
                                "${AppConstants.changeddmmyyformat(widget.leavemodel.message![widget.position].fromdate.toString())}-${AppConstants.changeddmmyyformat(widget.leavemodel.message![widget.position].todate)}"),
                        const SizedBox(
                          height: 5,
                        ),
                        AppUtils.buildNormalText(
                          text:
                              '${widget.leavemodel.message![widget.position].totalNoOfDays.toString()} ${widget.leavemodel.message![widget.position].totalNoOfDays == 1 ? "day" : "days"}',
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        AppUtils.buildNormalText(
                            text: widget
                                .leavemodel.message![widget.position].toEmpName
                                .toString()),
                      ],
                    ))
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                AppUtils.buildNormalText(
                    text: widget.leavemodel.message![widget.position].reason
                        .toString()),
              ],
            ))
        : Container();
  }

  Widget approveddetails() {
    return widget
            .leavemodel.message![widget.position].approvalHistory!.isNotEmpty
        ? Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0xFFD4CEFE),
                      offset: Offset(0, 7),
                      blurRadius: 15)
                ]),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                AppUtils.gethanger(context),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.leavemodel.message![widget.position]
                        .approvalHistory!.length,
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
                                    text: widget
                                        .leavemodel
                                        .message![widget.position]
                                        .approvalHistory![index1]
                                        .status
                                        .toString()),
                                const SizedBox(width: 10),
                                AppUtils.buildNormalText(
                                    text: widget
                                                .leavemodel
                                                .message![widget.position]
                                                .approvalHistory![index1]
                                                .status
                                                .toString() ==
                                            "Approved"
                                        ? "Approved By"
                                        : widget
                                                    .leavemodel
                                                    .message![widget.position]
                                                    .approvalHistory![index1]
                                                    .status
                                                    .toString() ==
                                                "Rejected"
                                            ? "Rejected"
                                            : "Pending"),
                                const SizedBox(width: 10),
                                AppUtils.buildNormalText(
                                    text: widget
                                        .leavemodel
                                        .message![widget.position]
                                        .approvalHistory![index1]
                                        .approvername
                                        .toString(),
                                    fontSize: 14),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AppUtils.buildNormalText(
                                text: widget
                                    .leavemodel
                                    .message![widget.position]
                                    .approvalHistory![index1]
                                    .approveddate
                                    .toString()),
                            AppUtils.buildNormalText(
                                text: widget
                                    .leavemodel
                                    .message![widget.position]
                                    .approvalHistory![index1]
                                    .remarks
                                    .toString()),
                          ],
                        ),
                      );
                    }),
              ],
            ))
        : Container();
  }

  Future<void> _preparePdf() async {
    setState(() {
      loading = true;
    });
    final Uint8List bytes = base64.decode(widget
        .leavemodel.message![widget.position].attachment!.first.fileData
        .toString());
    final String dir = (await getTemporaryDirectory()).path;
    final String path = '$dir/temp.pdf';

    final File file = File(path);
    await file.writeAsBytes(bytes);

    if (mounted) {
      setState(() {
        filePath = path;
      });
    }
    setState(() {
      loading = false;
    });
  }

  _prepareImage() {
    return bytesImage = const Base64Decoder().convert(widget
        .leavemodel.message![widget.position].attachment!.first.fileData
        .toString());
  }
}
