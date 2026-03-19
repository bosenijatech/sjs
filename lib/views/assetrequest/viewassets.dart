import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sjs/models/viewassetmodel.dart';
import 'package:sjs/routenames.dart';
import 'package:sjs/domain/ApiService.dart';
import 'package:sjs/utils/app_utils.dart';
import 'package:sjs/utils/constants.dart';
import 'package:sjs/utils/custom_indicatoronly.dart';
import 'package:sjs/views/widgets/assets_image_widget.dart';
import 'package:sjs/views/widgets/colorstatus.dart';
import 'package:sjs/views/widgets/custom_button.dart';

class AssetDetailPage extends StatefulWidget {
  const AssetDetailPage({super.key});

  @override
  State<AssetDetailPage> createState() => _AssetDetailPageState();
}

class _AssetDetailPageState extends State<AssetDetailPage> {
  bool loading = false;
  bool isSearching = false; // ✅ toggles AppBar search mode
  TextEditingController searchController = TextEditingController();

  ViewAssetModel assetModel = ViewAssetModel();
  List<Message> filteredList = [];

  @override
  void initState() {
    super.initState();
    getdetailsdata();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
                filteredList = assetModel.message ?? [];
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: !isSearching
            ? AppUtils.buildNormalText(
                text: "Asset Details",
                fontSize: 20,
                color: Colors.black,
              )
            : TextField(
                controller: searchController,
                autofocus: true,
                onChanged: onSearchTextChanged,
                style: const TextStyle(color: Colors.black, fontSize: 18),
                decoration: const InputDecoration(
                  hintText: "Search asset...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
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
                  filteredList = assetModel.message ?? [];
                }
                isSearching = !isSearching;
              });
            },
          ),
        ],
      ),
      body: !loading
          ? (filteredList.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(children: [assetDetailsList()]),
                )
              : Center(
                  child: Text("No asset requests found!",
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                ))
          : const CustomIndicator(),
      persistentFooterButtons: [
        CustomButton(
          onPressed: () {
            Navigator.pushNamed(context, RouteNames.applyasset).then((_) {
              setState(() {
                getdetailsdata();
              });
            });
          },
          name: "Click to Apply Asset Request",
          fontSize: 14,
          circularvalue: 30,
        )
      ],
    );
  }

  // 🔍 Real-time search logic
  void onSearchTextChanged(String query) {
    if (query.isEmpty) {
      setState(() => filteredList = assetModel.message ?? []);
      return;
    }

    final q = query.toLowerCase();

    setState(() {
      filteredList = (assetModel.message ?? []).where((msg) {
        bool match(String? text) {
          return text?.toLowerCase().contains(q) ?? false;
        }

        return match(msg.assetname) ||
            match(msg.assettypename) ||
            match(msg.assetcode) ||
            match(msg.toEmpName) ||
            match(msg.remarks) ||
            match(msg.internalid) ||
            match(msg.date) ||
            match(msg.isstatus);
      }).toList();
    });
  }

  Widget assetDetailsList() {
    return ListView.builder(
      itemCount: filteredList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = filteredList[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    CupertinoIcons.person_circle_fill,
                    size: 40,
                    color: AppConstants.containercolorArray[index
                        .remainder(AppConstants.containercolorArray.length)],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.internalid ?? '',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(
                          AppConstants.convertdateformat(
                              item.createdDate?.substring(0, 10) ?? ''),
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  statusPendingColor(text: item.isstatus ?? ''),
                ],
              ),
              const SizedBox(height: 12),

              // 🔹 Asset type and name
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppUtils.buildNormalText(
                            text: "ASSET TYPE", color: Colors.black54),
                        const SizedBox(height: 5),
                        Text(item.assettypename ?? '',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ]),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    AppUtils.buildNormalText(
                        text: "ASSET NAME", color: Colors.black54),
                    const SizedBox(height: 5),
                    Text(item.assetname ?? '',
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ]),
                ],
              ),

              const SizedBox(height: 6),
              Divider(height: 0.5, color: Colors.grey.shade300),

              // 🔹 Remarks
              if (item.remarks != null && item.remarks!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: AppUtils.buildNormalText(
                    text: item.remarks!.toUpperCase(),
                    fontSize: 12,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              // 🔹 Approval History (eye icon)
              if (item.approvalHistory?.isNotEmpty ?? false) ...[
                const SizedBox(height: 5),
                const Divider(),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  onTap: () => showSheet(context, index),
                  trailing: const Icon(Icons.remove_red_eye),
                  title: const Text("Approval History",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                )
              ],
            ],
          ),
        );
      },
    );
  }

  void showSheet(context, index) {
    final item = filteredList[index];
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                AppUtils.gethanger(context),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: item.approvalHistory?.length ?? 0,
                    itemBuilder: (context, index1) {
                      final hist = item.approvalHistory![index1];
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                appovalPending(text: hist.status ?? ''),
                                const SizedBox(width: 10),
                                AppUtils.buildNormalText(
                                  text: hist.status == "Approved"
                                      ? "Approved By"
                                      : hist.status == "Rejected"
                                          ? "Rejected"
                                          : "Pending",
                                  fontSize: 14,
                                ),
                                const SizedBox(width: 10),
                                AppUtils.buildNormalText(
                                    text: hist.approvername ?? '',
                                    fontSize: 14),
                              ]),
                              const SizedBox(height: 6),
                              AppUtils.buildNormalText(
                                  text: hist.approveddate ?? ''),
                              const SizedBox(height: 6),
                              AppUtils.buildNormalText(
                                  text: hist.remarks ?? ''),
                              const Divider(),
                            ]),
                      );
                    }),
              ],
            ),
          );
        });
  }

  void getdetailsdata() async {
    setState(() => loading = true);
    ApiService.viewpostassetrequest().then((response) {
      setState(() => loading = false);
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        if (jsonBody['status'].toString() == "true") {
          assetModel = ViewAssetModel.fromJson(jsonBody);
          filteredList = assetModel.message ?? [];
        } else {
          assetModel.message = [];
          filteredList = [];
        }
      }
    }).catchError((e) {
      setState(() => loading = false);
      AppUtils.showSingleDialogPopup(
        context,
        e.toString(),
        "Ok",
        onexitpopup,
        AssetsImageWidget.errorimage,
      );
    });
  }

  void onexitpopup() => Navigator.of(context).pop();
}
