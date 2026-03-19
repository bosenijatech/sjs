import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sjs/models/viewallemployeeModel.dart';
import 'package:sjs/domain/ApiService.dart';
import 'package:sjs/services/pref.dart';
import 'package:sjs/utils/app_utils.dart';
import 'package:sjs/utils/appcolor.dart';
import 'package:sjs/utils/sharedprefconstants.dart';
import 'package:sjs/views/widgets/assets_image_widget.dart';
import 'package:intl/intl.dart';

class ApplyGrievancePage extends StatefulWidget {
  const ApplyGrievancePage({super.key});

  @override
  State<ApplyGrievancePage> createState() => _ApplyGrievancePageState();
}

class _ApplyGrievancePageState extends State<ApplyGrievancePage> {
  bool loading = false;
  int currentStep = 0;
  bool isCompleted = false;
  TextEditingController empnamecontroller = TextEditingController();
  TextEditingController empworkregioncontroller = TextEditingController();
  TextEditingController dateofsubbmissioncontroller = TextEditingController();
  TextEditingController empidcontroller = TextEditingController();
  TextEditingController contactnocontroller = TextEditingController();
  TextEditingController deptcontroller = TextEditingController();
  TextEditingController designationcontroller = TextEditingController();
  TextEditingController supervisorcontroller = TextEditingController();
  TextEditingController worklocationcontroller = TextEditingController();
  TextEditingController dateofincientcontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  TextEditingController proposedreasoncontroller = TextEditingController();
  List<User> allemplist = [];
  ViewAllEmployeeModel employeeModel = ViewAllEmployeeModel();
  String? partiesId;
  String? partiesName;
  final myKey = GlobalKey<DropdownSearchState<User>>();
  List<String> selectedNames = [];
  List<String> selectedId = [];
  bool? _popupBuilderSelection = false;
  List<Step> stepList() => [
        Step(
          title: const Text('Employee Details'),
          content: employyedetailswidget(),
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
        ),
        Step(
          title: const Text('Grievance Details'),
          content: grievancedetailwidget(),
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
        ),
        Step(
          title: const Text('Employee Suggestion'),
          content: proposedwidget(),
          state: currentStep == 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
        ),
      ];

  @override
  void initState() {
    print(Prefs.getDept(SharefprefConstants.shareddept));
    empnamecontroller.text =
        Prefs.getFullName(SharefprefConstants.shareFullName).toString();
    deptcontroller.text =
        Prefs.getDept(SharefprefConstants.shareddept).toString();
    empworkregioncontroller.text =
        Prefs.getWorkRegion(SharefprefConstants.sharedWorkregion).toString();
    empidcontroller.text =
        Prefs.getEmpID(SharefprefConstants.sharedempId).toString();
    contactnocontroller.text =
        Prefs.getMobileNo(SharefprefConstants.sharedMobNo).toString();
    designationcontroller.text =
        Prefs.getDesignation(SharefprefConstants.shareddesignation).toString();

    supervisorcontroller.text =
        Prefs.getSupervisor(SharefprefConstants.sharedsupervisor).toString();

    worklocationcontroller.text =
        Prefs.getWorkRegion(SharefprefConstants.sharedWorkregion).toString();
    super.initState();

    // String dateTime = DateFormat("yyyy-MM-dd").format(DateTime.now());
    dateofsubbmissioncontroller.text =
        DateFormat("yyyy-MM-dd").format(DateTime.now());
    getallemployeedetails();
  }

  @override
  void dispose() {
    empnamecontroller.dispose();

    empworkregioncontroller.dispose();
    dateofsubbmissioncontroller.dispose();
    designationcontroller.dispose();
    empidcontroller.dispose();
    contactnocontroller.dispose();
    deptcontroller.dispose();
    supervisorcontroller.dispose();
    worklocationcontroller.dispose();
    dateofincientcontroller.dispose();
    descriptioncontroller.dispose();
    proposedreasoncontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AppUtils.buildNormalText(
            text: "Grievance Form", color: Colors.white, fontSize: 20),
        centerTitle: true,
      ),
      body: !loading
          ? Theme(
              data: Theme.of(context).copyWith(
                  colorScheme:
                      ColorScheme.light(primary: Appcolor.primarycolor)),
              child: isCompleted
                  ? successWidget()
                  : Stepper(
                      type: StepperType.vertical,
                      steps: stepList(),
                      currentStep: currentStep,
                      onStepContinue: () async {
                        final isLastStep = currentStep == stepList().length - 1;
                        if (isLastStep) {
                          if (dateofincientcontroller.text.isEmpty) {
                            AppUtils.showSingleDialogPopup(
                                context,
                                "Please Choose Dateof incient!",
                                "Ok",
                                onexitpopup,
                                AssetsImageWidget.warningimage);
                          } else if (selectedId.isEmpty) {
                            AppUtils.showSingleDialogPopup(
                                context,
                                "Please Choose Parties",
                                "Ok",
                                onexitpopup,
                                AssetsImageWidget.warningimage);
                          } else if (proposedreasoncontroller.text.isEmpty) {
                            AppUtils.showSingleDialogPopup(
                                context,
                                "Please Enter Solution",
                                "Ok",
                                onexitpopup,
                                AssetsImageWidget.warningimage);
                          } else {
                            postgrievance();
                          }
                        } else {
                          setState(() {
                            currentStep += 1;
                          });
                        }
                      },
                      onStepTapped: (step) =>
                          setState(() => currentStep = step),
                      onStepCancel: currentStep == 0
                          ? null
                          : () => setState(() => currentStep -= 1),
                      controlsBuilder: (context, details) {
                        final isLastStep = currentStep == stepList().length - 1;
                        return Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: Row(
                            children: [
                              Expanded(
                                  child: ElevatedButton(
                                      onPressed: details.onStepCancel,
                                      child: const Text('Back'))),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Appcolor.primarycolor),
                                      onPressed: details.onStepContinue,
                                      child: Text(
                                        isLastStep ? "Confirm" : 'Next',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ))),
                            ],
                          ),
                        );
                      },
                    ),
            )
          : const Center(
              child: CupertinoActivityIndicator(
                  radius: 30.0, color: Appcolor.black),
            ),
    );
  }

  Widget employyedetailswidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppUtils.buildNormalText(text: "Employee Name"),
        const SizedBox(height: 5),
        TextField(
          keyboardType: TextInputType.multiline,
          maxLines: 1,
          controller: empnamecontroller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: "Employee Name",
            icon: Icon(Icons.numbers, color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(height: 10),
        AppUtils.buildNormalText(text: "Employee Work Region"),
        const SizedBox(height: 5),
        TextField(
          controller: empworkregioncontroller,
          keyboardType: TextInputType.multiline,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: "Employee Work Region",
            icon: Icon(Icons.description, color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(height: 10),
        AppUtils.buildNormalText(text: "Date Of Submission"),
        const SizedBox(height: 5),
        TextFormField(
          onTap: () {
            // pickerdate(dateofsubbmissioncontroller);
          },
          readOnly: true,
          controller: dateofsubbmissioncontroller,
          keyboardType: TextInputType.multiline,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: "Date Of Submission",
            icon: Icon(Icons.chat_bubble_outline_rounded,
                color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(height: 10),
        AppUtils.buildNormalText(text: "Employee ID"),
        const SizedBox(height: 5),
        TextField(
          controller: empidcontroller,
          keyboardType: TextInputType.multiline,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: "Employee ID",
            icon: Icon(Icons.developer_board, color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(height: 10),
        AppUtils.buildNormalText(text: "Contact No"),
        const SizedBox(height: 5),
        TextField(
          controller: contactnocontroller,
          keyboardType: TextInputType.multiline,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: "Contact No",
            icon: Icon(Icons.developer_board, color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(height: 10),
        AppUtils.buildNormalText(text: "Department"),
        const SizedBox(height: 5),
        TextField(
          controller: deptcontroller,
          keyboardType: TextInputType.multiline,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: "Department",
            icon: Icon(Icons.developer_board, color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(height: 10),
        AppUtils.buildNormalText(text: "Designation"),
        const SizedBox(height: 5),
        TextField(
          controller: designationcontroller,
          keyboardType: TextInputType.multiline,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: "Designation",
            icon: Icon(Icons.developer_board, color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(height: 10),
        AppUtils.buildNormalText(text: "Super Visor"),
        const SizedBox(height: 5),
        TextField(
          controller: supervisorcontroller,
          keyboardType: TextInputType.multiline,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: "Super Visor",
            icon: Icon(Icons.developer_board, color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(height: 10),
        AppUtils.buildNormalText(text: "Work Location"),
        const SizedBox(height: 5),
        TextField(
          controller: worklocationcontroller,
          keyboardType: TextInputType.multiline,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: "Work Location",
            icon: Icon(Icons.developer_board, color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget grievancedetailwidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppUtils.buildNormalText(text: "Date of incident"),
        const SizedBox(height: 5),
        TextFormField(
          controller: dateofincientcontroller,
          readOnly: true,
          keyboardType: TextInputType.multiline,
          maxLines: 1,
          onTap: () {
            pickerdate(dateofincientcontroller);
          },
          decoration: InputDecoration(
            hintText: "Date",
            icon: Icon(Icons.date_range, color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(height: 10),
        AppUtils.buildNormalText(text: "Select Parties Involved * "),
        const SizedBox(height: 5),
        DropdownSearch<User>.multiSelection(
          items: allemplist,
          key: myKey,
          compareFn: (i1, i2) => i1.id == i2.id,
          dropdownButtonProps: const DropdownButtonProps(),
          onChanged: (data) {
            selectedNames.clear();
            selectedId.clear();
            for (int k = 0; k < data.length; k++) {
              //print(data[k].docEntry.toString());
              selectedId.add(data[k].id.toString());
              selectedNames.add(data[k].name.toString());
              print(jsonEncode(selectedNames));
            }
          },
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                labelText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
          ),
          popupProps: PopupPropsMultiSelection.modalBottomSheet(
              onItemAdded: (l, s) => handleCheckBoxState(),
              onItemRemoved: (l, s) => handleCheckBoxState(),
              showSearchBox: true,
              itemBuilder: (ctx, item, isSelected) {
                return ListTile(
                    selected: isSelected,
                    title: AppUtils.buildNormalText(
                      text: 'Id: ${item.id}'.toString(),
                    ),
                    subtitle: AppUtils.buildNormalText(
                        text: 'Name: ${item.name}'.toString()),
                    onTap: () {
                      myKey.currentState?.popupValidate([item]);

                      setState(() {});
                    });
              },
              showSelectedItems: true),
        ),

        // DropdownSearch<User>.multiSelection(
        //   key: myKey,
        //   compareFn: (i1, i2) => i1.id == i2.id,
        //   popupProps: PopupPropsMultiSelection.dialog(
        //     validationWidgetBuilder: (ctx, selectedItems) {
        //       return Container(
        //         color: Colors.blue[200],
        //         height: 56,
        //         child: Align(
        //           alignment: Alignment.center,
        //           child: MaterialButton(
        //             child: const Text('OK'),
        //             onPressed: () {
        //               print(selectedItems);
        //               myKey.currentState?.popupOnValidate();
        //             },
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        //   items: allemplist,
        //   dropdownDecoratorProps: DropDownDecoratorProps(
        //     dropdownSearchDecoration: InputDecoration(
        //       contentPadding:
        //           const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        //       hintText: '',
        //       enabledBorder: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(10),
        //         borderSide:
        //             const BorderSide(color: Appcolor.primarycolor, width: 1),
        //       ),
        //       focusedBorder: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(10),
        //         borderSide:
        //             const BorderSide(color: Appcolor.primarycolor, width: 1),
        //       ),
        //     ),
        //   ),
        //   // validator: (value) =>
        //   //     value!.isEmpty ? 'Assigned to should not empty!' : null,
        //   // onChanged: (val) {
        //   //   for (int kk = 0; kk < employeeModel.message!.length; kk++) {
        //   //     if (employeeModel.message![kk].firstName.toString() == val) {
        //   //       partiesId = employeeModel.message![kk].nsId.toString();
        //   //       partiesName = employeeModel.message![kk].firstName.toString();
        //   //       print(partiesId);
        //   //       selectedId.add(employeeModel.message![kk].nsId.toString());
        //   //       selectedNames
        //   //           .add(employeeModel.message![kk].firstName.toString());

        //   //       setState(() {});
        //   //     }
        //   //   }
        //   // },
        // ),
        const SizedBox(height: 5),

        AppUtils.buildNormalText(text: "Description"),
        const SizedBox(height: 5),
        Container(
            //padding: EdgeInsets.all(20),
            child: TextField(
          controller: descriptioncontroller,
          keyboardType: TextInputType.multiline,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Enter Description",
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.grey)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.black26, width: 1),
            ),
          ),
        )),
      ],
    );
  }

  void handleCheckBoxState({bool updateState = true}) {
    var selectedItem = myKey.currentState?.popupGetSelectedItems ?? [];
    var isAllSelected = myKey.currentState?.popupIsAllItemSelected ?? false;
    _popupBuilderSelection =
        selectedItem.isEmpty ? false : (isAllSelected ? true : null);

    if (updateState) setState(() {});
  }

  Widget proposedwidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //AppUtils.buildNormalText(text: "Employee Suggestion"),
        const SizedBox(height: 5),
        Container(
            //padding: EdgeInsets.all(20),
            child: TextField(
          controller: proposedreasoncontroller,
          keyboardType: TextInputType.multiline,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Employee Suggestion",
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.grey)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.black26, width: 1),
            ),
          ),
        )),
      ],
    );
  }

  Widget successWidget() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          AppUtils.buildNormalText(
            text: "Grievance Submitted Successfully!",
            fontSize: 16,
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  isCompleted = false;
                  currentStep = 0;
                });
              },
              child: const Text('OK'))
        ],
      ),
    );
  }

  void getallemployeedetails() async {
    setState(() {
      loading = true;
    });
    ApiService.getallemployee().then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          employeeModel =
              ViewAllEmployeeModel.fromJson(jsonDecode(response.body));
          allemplist.clear();
          for (int i = 0; i < employeeModel.message!.length; i++) {
            allemplist.add(User(
                name: employeeModel.message![i].firstName.toString(),
                id: employeeModel.message![i].nsId.toString()));
          }
        } else {
          print(jsonDecode(response.body)['message']);
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              onexitpopup,
              AssetsImageWidget.warningimage);
        }
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    }).catchError((e) {
      setState(() {
        loading = false;
      });
      print(e.toString());
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", onexitpopup,
          AssetsImageWidget.errorimage);
    });
  }

  void postgrievance() async {
    // final removedBrackets =
    //     selectedId.toString().substring(1, selectedId.length - 1);
    // final ids = removedBrackets.split(', ');
    // var selectedids = ids.map((part) => "'$part'").join(', ');

    // final removedBracketsNew =
    //     selectedNames.toString().substring(1, selectedNames.length - 1);
    // final names = removedBracketsNew.split(', ');
    // var selectednames = names.map((part) => "'$part'").join(', ');
    print(selectedId.join(''));
    print(selectedNames.join(''));

    DateTime now = DateTime.now();
    DateTime currentyear = DateTime(now.year);
    var currentdate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var json = {
      "nsId": Prefs.getNsID('nsid'),
      "employeeCode": Prefs.getEmpID(
        SharefprefConstants.sharedempId,
      ),
      "title": Prefs.getTitle(SharefprefConstants.sharedTitle),
      "firstName": Prefs.getFirstName(SharefprefConstants.shareFirstName),
      "middleName": Prefs.getMiddleName(SharefprefConstants.shareMiddleName),
      "lastName": Prefs.getLastName(SharefprefConstants.sharedLastName),
      "department": deptcontroller.text,
      "designation": designationcontroller.text,
      "supervisorid": Prefs.getLastName(SharefprefConstants.sharedsupervisor),
      "supervisorName": Prefs.getLastName(SharefprefConstants.sharedsupervisor),
      "worklocation": worklocationcontroller.text,
      "dateOfincident": dateofincientcontroller.text,
      "partiesid": selectedId.join(','),
      "partiesname": selectedNames.join(','),
      "description": descriptioncontroller.text,
      "solution": proposedreasoncontroller.text,
      "createdbyid": Prefs.getNsID(SharefprefConstants.sharednsid),
      "createdbyName": Prefs.getFullName(SharefprefConstants.shareFullName),
      "NetsuiteRefNo": "",
      "NetsuiteRemarks": "",
      "dateOfSubmission": dateofsubbmissioncontroller.text
    };
    print(jsonEncode(json));
    setState(() {
      loading = true;
    });
    ApiService.postgrievance(json).then((response) {
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

  void pickerdate(controller) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 30)),
        lastDate: DateTime.now().add(const Duration(days: 30)));

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      // var dateFormate =
      //     DateFormat("dd/MM/yyyy").format(DateTime.parse(formattedDate));

      controller.text = formattedDate;
    }
  }

  void onexitpopup() {
    Navigator.of(context).pop();
  }

  void onrefreshscreen() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}

class User {
  final String name;
  final String id;

  User({required this.name, required this.id});

  @override
  String toString() => '$name - $id';
}
