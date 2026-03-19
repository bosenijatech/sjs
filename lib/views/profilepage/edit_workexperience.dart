// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:sjs/models/empinfomodel.dart';
// import 'package:sjs/services/ApiService.dart';
// import 'package:sjs/services/pref.dart';
// import 'package:sjs/utils/app_utils.dart';
// import 'package:sjs/utils/appcolor.dart';
// import 'package:sjs/views/widgets/custom_button.dart';
// import 'package:intl/intl.dart';

// class EditWorkExperience extends StatefulWidget {
//   final EmpInfoModel model;
//   final bool? iseditable;
//   final int? position;
//   const EditWorkExperience(
//       {super.key,
//       required this.model,
//       required this.iseditable,
//       required this.position});

//   @override
//   State<EditWorkExperience> createState() => _EditWorkExperienceState();
// }

// class _EditWorkExperienceState extends State<EditWorkExperience> {
//   TextEditingController workcompanycontroller = TextEditingController();
//   TextEditingController workjobtitlecontroller = TextEditingController();
//   TextEditingController workfromdatecontroller = TextEditingController();
//   TextEditingController worktodatecontroller = TextEditingController();
//   TextEditingController workremarkscontroller = TextEditingController();
//   bool loading = false;

//   @override
//   void initState() {
//     if (widget.iseditable == true) {
//       workcompanycontroller.text = widget
//           .model.message!.workExperience![widget.position!.toInt()].company
//           .toString();
//       workjobtitlecontroller.text = widget
//           .model.message!.workExperience![widget.position!.toInt()].jobTitle
//           .toString();
//       workfromdatecontroller.text = widget
//           .model.message!.workExperience![widget.position!.toInt()].fromDate
//           .toString();
//       worktodatecontroller.text = widget
//           .model.message!.workExperience![widget.position!.toInt()].toDate
//           .toString();
//       workremarkscontroller.text = widget
//           .model.message!.workExperience![widget.position!.toInt()].comments
//           .toString();
//     } else {
//       workcompanycontroller.text = "";
//       workjobtitlecontroller.text = "";
//       workfromdatecontroller.text = "";
//       worktodatecontroller.text = "";
//       workremarkscontroller.text = "";
//     }
//     super.initState();
//   }

//   @override
//   void dispose() {
//     workcompanycontroller.clear();
//     workjobtitlecontroller.clear();
//     workfromdatecontroller.clear();
//     worktodatecontroller.clear();
//     workremarkscontroller.clear();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(CupertinoIcons.clear, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: AppUtils.buildNormalText(
//             text: "Work Experience", color: Colors.white, fontSize: 20),
//         centerTitle: true,
//       ),
//       body: !loading
//           ? Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Expanded(
//                     child: SingleChildScrollView(
//                   child: Column(
//                     children: [getwidget()],
//                   ),
//                 ))
//               ],
//             )
//           : const Center(
//               child: CupertinoActivityIndicator(
//                   radius: 30.0, color: Appcolor.twitterBlue),
//             ),
//     );
//   }

//   Widget getwidget() {
//     return Column(children: [
//       Padding(
//           padding: const EdgeInsets.all(15),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(
//                 height: 10,
//               ),
//               TextField(
//                 controller: workcompanycontroller,
//                 maxLength: 100,
//                 decoration: InputDecoration(
//                   counterText: '',
//                   labelText: 'Company Name',
//                   icon: Icon(
//                     Icons.home,
//                     color: Colors.grey.shade300,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               TextField(
//                 controller: workjobtitlecontroller,
//                 maxLength: 100,
//                 decoration: InputDecoration(
//                   counterText: '',
//                   labelText: 'Job title',
//                   icon: Icon(Icons.join_full, color: Colors.grey.shade300),
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               InkWell(
//                 onTap: () {
//                   pickerdate(workfromdatecontroller);
//                 },
//                 child: TextField(
//                   enabled: false,
//                   controller: workfromdatecontroller,
//                   maxLength: 100,
//                   decoration: InputDecoration(
//                     counterText: '',
//                     labelText: 'From Date',
//                     icon: Icon(Icons.date_range, color: Colors.grey.shade300),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               InkWell(
//                 onTap: () async {
//                   pickerdate(worktodatecontroller);
//                 },
//                 child: TextField(
//                   enabled: false,
//                   controller: worktodatecontroller,
//                   maxLength: 100,
//                   decoration: InputDecoration(
//                     counterText: '',
//                     labelText: 'To Date',
//                     icon: Icon(Icons.date_range, color: Colors.grey.shade300),
//                   ),
//                 ),
//               ),
//               TextField(
//                 controller: workremarkscontroller,
//                 maxLength: 200,
//                 decoration: InputDecoration(
//                   counterText: '',
//                   labelText: 'Remarks',
//                   icon: Icon(Icons.message, color: Colors.grey.shade300),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               CustomButton(
//                 onPressed: () {
//                   if (widget.iseditable == true) {
//                     insertandupdateskills(widget.model.message!
//                         .workExperience![widget.position!.toInt()].sId
//                         .toString());
//                   } else {
//                     addexperience();
//                   }
//                 },
//                 name: "Submit",
//                 circularvalue: 5,
//                 fontSize: 14,
//               )
//             ],
//           )),
//     ]);
//   }

//   void addexperience() {
//     var json = {
//       "nsId": Prefs.getNsID('nsid'),
//       "type": "experience",
//       "company": workcompanycontroller.text,
//       "jobTitle": workjobtitlecontroller.text,
//       "fromDate": workfromdatecontroller.text,
//       "toDate": worktodatecontroller.text,
//       "comments": workremarkscontroller.text,
//     };
//     setState(() {
//       loading = true;
//     });
//     ApiService.updateprofiles(json).then((response) {
//       setState(() {
//         loading = false;
//       });
//       if (response.statusCode == 200) {
//         if (jsonDecode(response.body)['status'].toString() == "true") {
//           Navigator.pop(context);
//         } else {
//           AppUtils.showSingleDialogPopup(context,
//               jsonDecode(response.body)['message'], "Ok", onexitpopup, null);
//         }
//       } else {
//         throw Exception(jsonDecode(response.body)['message'].toString());
//       }
//     }).catchError((e) {
//       setState(() {
//         loading = false;
//       });
//       AppUtils.showSingleDialogPopup(
//           context, e.toString(), "Ok", onexitpopup, null);
//     });
//   }

//   void pickerdate(controller) async {
//     DateTime? pickedDate = await showDatePicker(
//         context: context,
//         initialDate: DateTime.now(),
//         firstDate: DateTime(1900), //.subtract(Duration(days: 1)),
//         lastDate: DateTime(2100));
//     if (pickedDate != null) {
//       String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
//       var dateFormate =
//           DateFormat("dd/MM/yyyy").format(DateTime.parse(formattedDate));
//       controller.text = dateFormate;
//     }
//   }

//   void insertandupdateskills(String sid) {
//     var json = {
//       "type": "workExperience",
//       "_id": sid,
//       "company": workcompanycontroller.text,
//       "jobTitle": workjobtitlecontroller.text,
//       "fromDate": workfromdatecontroller.text,
//       "toDate": worktodatecontroller.text,
//       "comments": workremarkscontroller.text
//     };
//     setState(() {
//       loading = true;
//     });
//     ApiService.updatemaster(json).then((response) {
//       setState(() {
//         loading = false;
//       });
//       if (response.statusCode == 200) {
//         if (jsonDecode(response.body)['status'].toString() == "true") {
//           Navigator.pop(context);
//         } else {
//           AppUtils.showSingleDialogPopup(context,
//               jsonDecode(response.body)['message'], "Ok", onexitpopup, null);
//         }
//       } else {
//         throw Exception(jsonDecode(response.body)['message'].toString());
//       }
//     }).catchError((e) {
//       setState(() {
//         loading = false;
//       });
//       AppUtils.showSingleDialogPopup(
//           context, e.toString(), "Ok", onexitpopup, null);
//     });
//   }

//   void onexitpopup() {
//     Navigator.of(context).pop();
//   }
// }
