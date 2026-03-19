import 'dart:convert';
import 'dart:io';
import 'package:sjs/views/payslip/viewallfiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sjs/models/viewlettermodel.dart';
import 'package:sjs/routenames.dart';
import 'package:sjs/domain/ApiService.dart';
import 'package:sjs/utils/app_utils.dart';
import 'package:sjs/utils/constants.dart';
import 'package:sjs/utils/custom_indicatoronly.dart';
import 'package:sjs/views/widgets/assets_image_widget.dart';
import 'package:sjs/views/widgets/colorstatus.dart';
import 'package:sjs/views/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewLetterDetailsPage extends StatefulWidget {
  const ViewLetterDetailsPage({super.key});

  @override
  State<ViewLetterDetailsPage> createState() => _ViewLetterDetailsPageState();
}

class _ViewLetterDetailsPageState extends State<ViewLetterDetailsPage> {
  bool loading = false;
  bool isSearching = false; // ✅ search mode toggle
  TextEditingController searchController = TextEditingController();

  ViewletterModel lettermodel = ViewletterModel();
  List<Message> filteredList = [];

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
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () {
            if (isSearching) {
              setState(() {
                isSearching = false;
                searchController.clear();
                filteredList = List.from(lettermodel.message ?? []);
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: !isSearching
            ? AppUtils.buildNormalText(
                text: "Letter Details",
                color: Colors.black,
                fontSize: 20,
              )
            : TextField(
                controller: searchController,
                autofocus: true,
                onChanged: (value) => onSearchTextChanged(value),
                style: const TextStyle(color: Colors.black, fontSize: 18),
                decoration: const InputDecoration(
                  hintText: "Search letter...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  searchController.clear();
                  filteredList = lettermodel.message ?? [];
                }
                isSearching = !isSearching;
              });
            },
          ),
        ],
      ),

      // 🔹 Body
      body: !loading
          ? (filteredList.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    children: [letterDetails()],
                  ),
                )
              : Center(
                  child: Text('No Letter Request Found!',
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade900)),
                ))
          : const CustomIndicator(),

      // 🔹 Footer Button
      persistentFooterButtons: [
        CustomButton(
          onPressed: () {
            Navigator.pushNamed(context, RouteNames.addletter).then((_) {
              setState(() {
                getdetailsdata();
              });
            });
          },
          name: "Click to Apply Letter Request",
          fontSize: 14,
          circularvalue: 30,
        )
      ],
    );
  }

  // 🔍 Search logic
  void onSearchTextChanged(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        filteredList = List.from(lettermodel.message ?? []);
      });
      return;
    }

    final lowerQuery = query.toLowerCase();

    setState(() {
      filteredList = (lettermodel.message ?? []).where((msg) {
        return (msg.lettertypename ?? "").toLowerCase().contains(lowerQuery) ||
            (msg.letteraddresstoname ?? "")
                .toLowerCase()
                .contains(lowerQuery) ||
            (msg.toEmpName ?? "").toLowerCase().contains(lowerQuery) ||
            (msg.isstatus ?? "").toLowerCase().contains(lowerQuery) ||
            (msg.internalid ?? "").toLowerCase().contains(lowerQuery) ||
            (msg.copyTypeName ?? "").toLowerCase().contains(lowerQuery) ||
            (msg.createdDate ?? "").toLowerCase().contains(lowerQuery) ||
            (msg.purpose ?? "").toLowerCase().contains(lowerQuery) ||
            (msg.letteraddresstocode ?? "")
                .toLowerCase()
                .contains(lowerQuery) ||
            (msg.purpose ?? "").toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  Widget letterDetails() {
    return ListView.builder(
      itemCount: filteredList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return getWidget(index);
      },
    );
  }

  Widget getWidget(int index) {
    final item = filteredList[index];
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header Row (Avatar + Name + Status + More)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.person_crop_circle,
                      size: 30,
                      color: AppConstants.containercolorArray[index
                          .remainder(AppConstants.containercolorArray.length)],
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          item.internalid ?? "-",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          "${AppConstants.changeddmmyyformat(item.createdDate.toString().substring(0, 10)) ?? ""}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    statusPendingColor(text: item.isstatus.toString()),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            Divider(
              color: Colors.grey.shade300,
              height: 1,
            ),
            const SizedBox(height: 5),
            _infoRow("Letter Type", item.lettertypename ?? "-"),
            const SizedBox(height: 5),
            _infoRow("Address To", item.letteraddresstoname ?? "-"),
            const SizedBox(height: 5),
            _infoRow("Copy To", item.copyTypeName ?? "-"),
            const SizedBox(height: 5),
            if (item.purpose != null && item.purpose!.isNotEmpty) ...[
              const Text("Purpose",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              Text(
                item.purpose!.toUpperCase(),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 5),
            ],

            /// Attachment
            if (item.attachment != null &&
                item.attachment != "null" &&
                item.attachment!.isNotEmpty)
              GestureDetector(
                //onTap: () => _launchUrl(leave.imageUrl!),
                onTap: () async {
                  if (item.attachment!.isEmpty) return;

                  final mime = await AppConstants.getMimeType(item.attachment!);
                  final ext = AppConstants.getExtensionFromMime(mime);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewFiles(
                        fileUrl: item.attachment!,
                        fileName: 'file.$ext',
                        mimeType: mime,
                      ),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.attachment, size: 16, color: Colors.blue),
                    SizedBox(width: 5),
                    Text("View Attachment",
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 12)),
                  ],
                ),
              ),

            const SizedBox(height: 5),
          ],
        ),
      ),
    );
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
                        lettermodel.message![index].approvalHistory!.length,
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
                                    text: lettermodel.message![index]
                                        .approvalHistory![index1].status
                                        .toString()),
                                const SizedBox(width: 10),
                                AppUtils.buildNormalText(
                                    text: lettermodel.message![index]
                                                .approvalHistory![index1].status
                                                .toString() ==
                                            "Approved"
                                        ? "Approved By"
                                        : lettermodel
                                                    .message![index]
                                                    .approvalHistory![index1]
                                                    .status
                                                    .toString() ==
                                                "Rejected"
                                            ? "Rejected"
                                            : "Pending"),
                                const SizedBox(width: 10),
                                AppUtils.buildNormalText(
                                    text: lettermodel.message![index]
                                        .approvalHistory![index1].approvername
                                        .toString(),
                                    fontSize: 14),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AppUtils.buildNormalText(
                                text: lettermodel.message![index]
                                    .approvalHistory![index1].approveddate
                                    .toString()),
                            const SizedBox(
                              height: 10,
                            ),
                            AppUtils.buildNormalText(
                                text: lettermodel.message![index]
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

  Widget _infoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
        Text(value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: Colors.grey,
      ),
    );
  }

  void getdetailsdata() async {
    if (!mounted) return;
    setState(() {
      loading = true;
    });
    ApiService.getletterrequest().then((response) {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          lettermodel = ViewletterModel.fromJson(jsonDecode(response.body));

          lettermodel.message?.sort(
            (a, b) => b.internalid!.compareTo(a.internalid!),
          );

          filteredList = List.from(lettermodel.message ?? []);
        } else {
          lettermodel.message = [];
          filteredList = [];
        }
      } else {
        throw Exception(jsonDecode(response.body).toString()).toString();
      }
    }).catchError((e) {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
      AppUtils.showSingleDialogPopup(
        context,
        e.toString(),
        "Ok",
        onexitpopup,
        AssetsImageWidget.errorimage,
      );
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
