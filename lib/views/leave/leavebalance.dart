// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:winstar/models/error_model.dart';
// import 'package:winstar/models/leavebalancemodel.dart';
// import 'package:winstar/services/pref.dart';
// import 'package:winstar/utils/app_utils.dart';
// import 'package:winstar/utils/appcolor.dart';
// import 'package:winstar/utils/constants.dart';
// import 'package:winstar/utils/custom_indicatoronly.dart';
// import 'package:winstar/utils/netsuite/netsuiteservice.dart';
// import 'package:winstar/utils/sharedprefconstants.dart';

// class LeaveBalancePage extends StatefulWidget {
//   const LeaveBalancePage({super.key});

//   @override
//   State<LeaveBalancePage> createState() => _LeaveBalancePageState();
// }

// class _LeaveBalancePageState extends State<LeaveBalancePage> {
//   bool loading = false;
//   LeaveBalanceModel leaveTypeModel = LeaveBalanceModel();

//   ErrorModelNetSuite errormodel = ErrorModelNetSuite();
//   @override
//   void initState() {
//     getdetailsdata();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: !loading
//           ? leaveTypeModel. != null
//               ? Column(
//                   children: [
//                     Expanded(
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.vertical,
//                         child: Column(children: [getdetails()]),
//                       ),
//                     )
//                   ],
//                 )
//               : const Center(child: Text('No Data!'))
//           : const CustomIndicator(),
//     );
//   }

//   Widget getdetails() {
//     return leaveTypeModel.employees != null
//         ? ListView.builder(
//             itemCount: leaveTypeModel.employees!.length ?? 0,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//               return Container(
//                 margin: const EdgeInsets.all(10),
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.grey.shade400,
//                     width: 0.5,
//                   ),
//                   borderRadius: const BorderRadius.all(
//                     Radius.circular(10),
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 2,
//                           child: CircleAvatar(
//                               maxRadius: 20,
//                               backgroundColor: AppConstants.colorArray[index
//                                   .remainder(AppConstants.colorArray.length)],
//                               child: AppUtils.buildNormalText(
//                                   text: leaveTypeModel
//                                       .employees![index].leaveBalanceTaken
//                                       .toString(),
//                                   color: Colors.white,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold)),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Expanded(
//                           flex: 5,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               AppUtils.buildNormalText(
//                                   text: leaveTypeModel
//                                       .employees![index].leaveName
//                                       .toString(),
//                                   fontSize: 14),
//                               AppUtils.buildNormalText(
//                                   text: "days Available", fontSize: 12)
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 20),
//                         Expanded(
//                           flex: 3,
//                           child: InkWell(
//                             onTap: () {
//                               Navigator.pushNamed(context, '/leaveapply');
//                             },
//                             child: AppUtils.buildNormalText(
//                                 text: "Apply Leave",
//                                 fontSize: 15,
//                                 color: Appcolor.primarycolor),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 3),
//                     Divider(
//                       thickness: 0.3,
//                       color: Colors.grey.shade400,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             AppUtils.buildNormalText(text: "", fontSize: 12),
//                             const SizedBox(height: 5),
//                             AppUtils.buildNormalText(text: "", fontSize: 12)
//                           ],
//                         ),
//                         Column(
//                           children: [
//                             AppUtils.buildNormalText(
//                                 text: leaveTypeModel
//                                     .employees![index].availableLeaveBalance
//                                     .toString(),
//                                 fontSize: 15),
//                             const SizedBox(height: 5),
//                             AppUtils.buildNormalText(
//                                 text: "Available Leave", fontSize: 12)
//                           ],
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               );
//             },
//           )
//         : const Center(child: Text('No Data!'));
//   }

//   getdetailsdata() async {
//     setState(() {
//       loading = true;
//     });
//     try {
//       Uri baseUri = Uri.parse(
//           '${AppConstants.netSuiteapiBaseUrl}script=${AppConstants.leavescriptid}&deploy=${AppConstants.leavedeployid}&empId=${Prefs.getNsID(SharefprefConstants.sharednsid)}');
//       await NetSuiteApiService.client.get(baseUri).then((response) {
//         setState(() {
//           loading = false;
//         });

//         if (response.statusCode == 200) {
//           leaveTypeModel = LeaveBalanceModel.fromJson(
//               json.decode(json.decode(response.body)));
//           print(json.decode(json.decode(response.body)));
//           print(Prefs.getNsID(SharefprefConstants.sharednsid));
//         } else {
//           errormodel = ErrorModelNetSuite.fromJson(jsonDecode(response.body));
//           throw Exception(errormodel.error!.message);
//         }
//       });
//     } on Exception catch (_) {
//       setState(() {
//         loading = false;
//       });
//       rethrow;
//     }
//   }

//   // void getdetailsdata() async {
//   //   setState(() {
//   //     loading = true;
//   //   });
//   //   ApiService.getleavestypesdata().then((response) {
//   //     setState(() {
//   //       loading = false;
//   //     });
//   //     if (response.statusCode == 200) {
//   //       if (jsonDecode(response.body)['status'].toString() == "true") {
//   //         leaveTypeModel = LeaveTypeModel.fromJson(jsonDecode(response.body));
//   //       } else {
//   //         // AppUtils.showSingleDialogPopup(
//   //         //     context, jsonDecode(response.body)['message'], "Ok", onexitpopup);
//   //       }
//   //     } else {
//   //       errormodel = ErrorModelNetSuite.fromJson(jsonDecode(response.body));
//   //       throw Exception(errormodel.error!.message);
//   //     }
//   //   }).catchError((e) {
//   //     setState(() {
//   //       loading = false;
//   //     });
//   //     AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", onexitpopup);
//   //   });
//   // }

//   void onexitpopup() {
//     Navigator.of(context).pop();
//   }
// }
