import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:winstar/models/assetnamemodel.dart';
import 'package:winstar/models/assettypemodel.dart';
import 'package:winstar/models/classmodel.dart';
import 'package:winstar/models/copymodel.dart';
import 'package:winstar/models/curremcymodel.dart';
import 'package:winstar/models/deptmodel.dart';
import 'package:winstar/models/documentmodel.dart';
import 'package:winstar/models/expcatmodel.dart';
import 'package:winstar/models/expenseamuntmodel.dart';
import 'package:winstar/models/expensemodel.dart';
import 'package:winstar/models/holidaymastermodel.dart';
import 'package:winstar/models/leavebalancemodel.dart';
import 'package:winstar/models/leavetypemodel.dart';
import 'package:winstar/models/paycompmodel.dart';
import 'package:winstar/models/relationmodel.dart';
import 'package:winstar/models/subsidiarymodel.dart';
import 'package:winstar/models/taxcodemodel.dart';
import 'package:winstar/models/yearmodel.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/api_details.dart';
import 'package:winstar/utils/constants.dart';
import 'package:winstar/utils/netsuite/netsuiteservice.dart';
import 'package:winstar/utils/sharedprefconstants.dart';
import 'package:winstar/views/letterpage/lettertypemodel.dart';
import 'package:winstar/views/profilepage/empskillsmodel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ApiService {
  static String mobilecurrentdate =
      DateFormat("dd/MM/yyyy").format(DateTime.now()); //2023-07-15";

   



  static const int timeOutDuration = 60;

  static String sessiontoken = Prefs.getToken("Token").toString();
  static String empid = Prefs.getEmpID("empID")!.toString();

  static Future<http.Response> getlogin(String usename, String password) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.getLogin);
    Map<String, String> headers = {"Content-Type": "application/json"};

    var body = {
      "username": usename,
      "userpassword": password,
    };

    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<http.Response> getemployeedetailsdata() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.getProfile);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };

    var body = {
      "nsId": Prefs.getNsID(SharefprefConstants.sharednsid.toString())
    };

    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> getskills() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.getProfile);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };

    var body = {
      "nsid": Prefs.getUserName(SharefprefConstants.sharedempId).toString()
    };
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<http.Response> getEducation() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.getProfile);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };

    var body = {
      "nsid": Prefs.getUserName(SharefprefConstants.sharedempId).toString()
    };
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<http.Response> addprofiles(dynamic json) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.addprofile1);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http
        .post(url, body: jsonEncode(json), headers: headers)
        .timeout(const Duration(seconds: timeOutDuration));
    return response;
  }

  static Future<http.Response> updatemaster(dynamic json) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.updatemaster1);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<http.Response> viewattendancehistorylog() async {
    var url = Uri.parse(
        AppConstants.apiBaseUrl + ApiDetails.viewbioattendancehistorylog);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var body = {
      "nsId": int.parse(Prefs.getNsID('nsid').toString()),
      // "fromdate": ydate,
      // "todate": cdate
    };

    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<http.Response> viewattendancebiohistory() async {
  
    var url = Uri.parse(
        AppConstants.apiBaseUrl + ApiDetails.viewbioattendancehistory);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var body = {
      "nsId": Prefs.getNsID('nsid')
    };
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> viewbioattendance() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewbioattendance);

    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    var body = {
      "nsId": Prefs.getNsID(SharefprefConstants.sharednsid),
      "currentdate": mobilecurrentdate
    };
    debugPrint(jsonEncode(body));
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<http.Response> updateAttendance(dynamic json) async {
    var url =
        Uri.parse(AppConstants.apiBaseUrl + ApiDetails.updatebioattendance);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> postBioAttendance(dynamic json) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.savebio);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http
        .post(url, body: jsonEncode(json), headers: headers)
        .timeout(const Duration(seconds: timeOutDuration));
    return response;
  }

  static Future<http.Response> postleave(dynamic json) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.applyleave);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> viewleave() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewleave);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var body = {
      "nsid": int.parse(Prefs.getNsID('nsid').toString()),
    };

    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> cancelleave(internalid, reason, uniqid) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.cancelleave);

    Map<String, String> headers = {"Content-Type": "application/json"};
    String mobilecurrentdatetime1 =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    var body = {
      "internalid": internalid,
      "uniqid": uniqid,
      "iscancelledreason": reason,
      "iscancelleddate": mobilecurrentdatetime1
    };
    print(jsonEncode(body));
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<http.Response> pullbackleave(internalid, reason, uniqid) async {
    var url =
        Uri.parse(AppConstants.apiBaseUrl + ApiDetails.cancelpullbackleave);

    Map<String, String> headers = {"Content-Type": "application/json"};
    String mobilecurrentdatetime1 =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    var body = {
      "internalid": internalid,
      "uniqid": uniqid,
      "ispullbackcancelledreason": reason,
      "ispullbackcancelleddate": mobilecurrentdatetime1
    };

    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  //RE JOIN

  static Future<http.Response> onpostdutyresumption(dynamic json) async {
    var url =
        Uri.parse(AppConstants.apiBaseUrl + ApiDetails.onpostdutyresumotion);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  //ASSET

  static Future<http.Response> postassetrequest(dynamic json) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.applyassetrequest);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> viewpostassetrequest() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewassetrequest);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var body = {
      "nsid": Prefs.getNsID('nsid'),
    };
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> postletterrequest(dynamic json) async {
    var url =
        Uri.parse(AppConstants.apiBaseUrl + ApiDetails.applyletterrequest);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    print(jsonEncode(json));
    return response;
  }

  static Future<http.Response> getletterrequest() async {
    var url = Uri.parse(
        '${AppConstants.apiBaseUrl}api/mobileapp/getletterrequest?nsid=${Prefs.getNsID('nsid')}');

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var response = await http.get(url, headers: headers).timeout(
          const Duration(seconds: timeOutDuration),
        );

    return response;
  }

  static Future<http.Response> getallemployee() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewallemployee);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var body = {
      "nsid": Prefs.getNsID('nsid'),
    };

    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

//START DUTY TRAVEL
  static Future<http.Response> postdutytravelrequest(dynamic json) async {
    var url =
        Uri.parse(AppConstants.apiBaseUrl + ApiDetails.applydutytravelrequest);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> viewtravelduty() async {
    var url =
        Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewdutytraveldetails);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var body = {
      "nsid": int.parse(Prefs.getNsID('nsid').toString()),
    };
    print(jsonEncode(body));
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  // START REIM

  static Future<http.Response> postreimbursementrequest(dynamic json) async {
    var url =
        Uri.parse(AppConstants.apiBaseUrl + ApiDetails.applyreimrequestrequest);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> viewreimbursementrequest() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewreimdetails);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var body = {
      "nsid": Prefs.getNsID('nsid'),
    };
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

//END REIM

  static Future<http.Response> updatepassword(
      String oldpass, String newpass) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.updatepassword);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var body = {
      "nsId": Prefs.getNsID('nsid'),
      "oldpassword": oldpass,
      "newpassword": newpass,
    };
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> viewholiday() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewholidaymaster);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };

    var response = await http.get(url, headers: headers).timeout(
          const Duration(seconds: timeOutDuration),
        );

    return response;
  }

  static Future<http.Response> postgrievance(dynamic json) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.addgrievance);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> postattachment(dynamic json) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.uploadfiles);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> postreqularization(dynamic json) async {
    var url =
        Uri.parse(AppConstants.apiBaseUrl + ApiDetails.applyreqularization);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> yearlist() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.getyearlist);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var response = await http.get(url, headers: headers).timeout(
          const Duration(seconds: timeOutDuration),
        );

    return response;
  }

  static Future<http.Response> sendforgeotpassword(String emailid) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.forgetpassword);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var body = {"mobileemail": emailid};

    var response =
        await http.post(url, headers: headers, body: jsonEncode(body)).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<http.Response> viewapprovedleave() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewapprovedleave);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var body = {
      //"currentDate": mobilecurrentdate,
      "toEmpID": int.parse(Prefs.getNsID('nsid').toString()),
    };

    var response =
        await http.post(url, headers: headers, body: jsonEncode(body)).timeout(
              const Duration(seconds: timeOutDuration),
            );
    print(jsonEncode(body));
    return response;
  }

  static Future<http.Response> viewrejoin() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewrejoin);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var body = {
      "nsid": int.parse(Prefs.getNsID('nsid').toString()),
    };

    var response =
        await http.post(url, headers: headers, body: jsonEncode(body)).timeout(
              const Duration(seconds: timeOutDuration),
            );
    print(jsonEncode(body));
    return response;
  }

  static Future<http.Response> requestpayslip(dynamic json) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.requestpayslip);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http
        .post(url, body: jsonEncode(json), headers: headers)
        .timeout(const Duration(seconds: timeOutDuration));
    return response;
  }

  static Future<http.Response> deletepayslip(dynamic json) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.deletepayslip);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http
        .post(url, body: jsonEncode(json), headers: headers)
        .timeout(const Duration(seconds: timeOutDuration));
    return response;
  }

  static Future<http.Response> viewovertimeattendancehistorylog() async {
    var url = Uri.parse(
        AppConstants.apiBaseUrl + ApiDetails.viewovertimeattendancehistorylog);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var body = {
      "nsId": int.parse(Prefs.getNsID('nsid').toString()),
      // "fromdate": ydate,
      // "todate": cdate
    };
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<http.Response> viewovertimeattendancebiohistory() async {
    DateTime today = DateTime.now();
    String cdate = DateFormat("yyyy-MM-dd").format(today);

    var url = Uri.parse(
        AppConstants.apiBaseUrl + ApiDetails.viewovertimeattendancehistory);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var body = {
      "nsId": Prefs.getNsID('nsid'),
      "docdate": cdate,
    };
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<http.Response> viewovertimebioattendance() async {
    var url =
        Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewovertimeattendance);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var body = {
      "nsId": Prefs.getNsID('nsid'),
      "currentdate": mobilecurrentdate
    };
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<http.Response> updateovertimeAttendance(dynamic json) async {
    var url = Uri.parse(
        AppConstants.apiBaseUrl + ApiDetails.updateovertimeattendance);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> postovertimeAttendance(dynamic json) async {
    var url =
        Uri.parse(AppConstants.apiBaseUrl + ApiDetails.addovertimeattendance);
    Map<String, String> headers = {"Content-Type": "application/json"};
    var response = await http
        .post(url, body: jsonEncode(json), headers: headers)
        .timeout(const Duration(seconds: timeOutDuration));
    return response;
  }

  static Future<http.Response> viewpendinglist() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.pendinglistcount);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var body = {
      "lineManagerId": Prefs.getNsID('nsid').toString(),
    };
    print(jsonEncode(body));
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<http.Response> viewannouncement() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewannouncement);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var body = {
      "employeeId": Prefs.getNsID('nsid').toString(),
    };
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }

  static Future<List<ExpCatModel>> getCategoryList({String filter = ""}) async {
    final response = await http.get(
      Uri.parse("${AppConstants.apiBaseUrl}api/mobileapp/getclaimcategory"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Prefs.getToken('token')}",
      },
    );

    if (response.statusCode == 200) {
      // ✅ Decode only once
      final Map<String, dynamic> decoded = json.decode(response.body);

      if (decoded['success'] == true) {
        final List<dynamic> records = decoded['payload'] ?? [];

        // ✅ Parse each item into ExpCatModel
        final List<ExpCatModel> fullList = records.map((item) {
          return ExpCatModel.fromJson(item as Map<String, dynamic>);
        }).toList();

        // ✅ Apply optional filter
        if (filter.isNotEmpty) {
          final search = filter.toLowerCase();
          return fullList.where((item) {
            return item.name.toLowerCase().contains(search) ||
                item.expenseacct.toString().contains(search);
          }).toList();
        }

        return fullList;
      } else {
        throw Exception(decoded['message'] ?? 'API returned failure status');
      }
    } else {
      throw Exception(
          'Failed to load category list (status: ${response.statusCode})');
    }
  }

  static Future<List<ExpAmountModel>> getexpenseAccount(
      {String filter = ""}) async {
    final response = await http.get(
      Uri.parse("${AppConstants.apiBaseUrl}api/mobileapp/getclaimexpaccount"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Prefs.getToken('token')}",
      },
    );

    if (response.statusCode == 200) {
      // ✅ Decode only once
      final Map<String, dynamic> decoded = json.decode(response.body);

      if (decoded['success'] == true) {
        final List<dynamic> records = decoded['payload'] ?? [];

        // ✅ Parse each item into ExpCatModel
        final List<ExpAmountModel> fullList = records.map((item) {
          return ExpAmountModel.fromJson(item as Map<String, dynamic>);
        }).toList();

        // ✅ Apply optional filter
        if (filter.isNotEmpty) {
          final search = filter.toLowerCase();
          return fullList.where((item) {
            return item.id.toString().toLowerCase().contains(search) ||
                item.acctName.toString().toLowerCase().contains(search);
          }).toList();
        }

        return fullList;
      } else {
        throw Exception(decoded['message'] ?? 'API returned failure status');
      }
    } else {
      throw Exception(
          'Failed to load category list (status: ${response.statusCode})');
    }
  }

  static Future<List<SubsidiaryModel>> getsusidiaryList(
      {String filter = ""}) async {
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${Prefs.getToken('token')}",
    };

    final baseUri = Uri.parse(
      '${AppConstants.netSuiteapiBaseUrl}script=${AppConstants.getsubsidiaryscriptId}&deploy=${AppConstants.getsubsidiarydeployId}',
    );

    final response =
        await NetSuiteApiService.client.get(baseUri, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded =
          json.decode(json.decode(response.body));

      if (decoded['Status'] == 'Success') {
        final List<dynamic> records = decoded['records'];
        final List<SubsidiaryModel> fullList = records.map((item) {
          return SubsidiaryModel.fromJson(item as Map<String, dynamic>);
        }).toList();

        if (filter.isEmpty) return fullList;

        return fullList.where((item) {
          final search = filter.toLowerCase();
          return item.name.toLowerCase().contains(search) ||
              item.id.toString().toLowerCase().contains(search);
        }).toList();
      } else {
        throw Exception('API returned failure status');
      }
    } else {
      throw Exception('Failed to load category list');
    }
  }

  static Future<List<CurrencyModel>> getCurrencyList(
      {String filter = ""}) async {
    final response = await http.get(
      Uri.parse("${AppConstants.apiBaseUrl}api/mobileapp/getclaimgetcurrency"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Prefs.getToken('token')}",
      },
    );

    if (response.statusCode == 200) {
      // ✅ Decode only once
      final Map<String, dynamic> decoded = json.decode(response.body);

      if (decoded['success'] == true) {
        final List<dynamic> records = decoded['payload'] ?? [];

        // ✅ Parse JSON into model list
        final List<CurrencyModel> fullList = records.map((item) {
          return CurrencyModel.fromJson(item as Map<String, dynamic>);
        }).toList();

        // ✅ Optional filtering
        if (filter.isNotEmpty) {
          final search = filter.toLowerCase();
          return fullList.where((item) {
            return item.name.toLowerCase().contains(search) ||
                item.id.toString().toLowerCase().contains(search) ||
                item.symbol.toLowerCase().contains(search);
          }).toList();
        }

        return fullList;
      } else {
        throw Exception(decoded['message'] ?? 'API returned failure status');
      }
    } else {
      throw Exception(
          'Failed to load currency list (status: ${response.statusCode})');
    }
  }

  static Future<List<TaxModel>> getTaxCodeList({String filter = ""}) async {
    final response = await http.get(
      Uri.parse("${AppConstants.apiBaseUrl}api/mobileapp/getclaimgettax"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Prefs.getToken('token')}",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);

      if (decoded['success'] == true) {
        final List<dynamic> records = decoded['payload'] ?? [];

        // ✅ Parse JSON into model list
        final List<TaxModel> fullList = records.map((item) {
          return TaxModel.fromJson(item as Map<String, dynamic>);
        }).toList();

        // ✅ Optional filtering
        if (filter.isNotEmpty) {
          final search = filter.toLowerCase();
          return fullList.where((item) {
            return item.taxocode.toLowerCase().contains(search) ||
                item.id.toLowerCase().contains(search) ||
                item.rate.toLowerCase().contains(search);
          }).toList();
        }

        return fullList;
      } else {
        throw Exception(decoded['message'] ?? 'API returned failure status');
      }
    } else {
      throw Exception(
          'Failed to load tax code list (status: ${response.statusCode})');
    }
  }

  static Future<String?> getExchangeRate({
    required String baseCurrencyId,
    required String transactionCurrencyId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("${AppConstants.apiBaseUrl}api/mobileapp/getclaimexchange"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${Prefs.getToken('token')}",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);

        if (decoded['success'] == true) {
          final List records = decoded['payload'] ?? [];

          for (final item in records) {
            // ✅ If both currencies are same, exchange rate = 1
            if (baseCurrencyId == transactionCurrencyId) {
              log("CURRENCY${item['exchangeRate']}");
              return "1";
            }

            // ✅ Find matching currency pair
            if (item['baseCurrency'] == baseCurrencyId &&
                item['transactionCurrency'] == transactionCurrencyId) {
              log("CURRENCY${item['exchangeRate']}");
              return item['exchangeRate'].toString();
            }
          }

          return null; // No match found
        } else {
          throw Exception(decoded['message'] ?? 'API returned failure status');
        }
      } else {
        throw Exception(
            'Failed to load exchange rate (status: ${response.statusCode})');
      }
    } catch (e) {
      print("Error fetching exchange rate: $e");
      return null;
    }
  }

  static Future<List<ClassModel>> getClassList({String filter = ""}) async {
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${Prefs.getToken('token')}",
    };

    final baseUri = Uri.parse(
      '${AppConstants.netSuiteapiBaseUrl}script=${AppConstants.classscriptId}&deploy=${AppConstants.classsdeployId}',
    );
    final response =
        await NetSuiteApiService.client.get(baseUri, headers: headers);

    if (response.statusCode == 200) {
      // ✅ Only decode once
      final Map<String, dynamic> decoded =
          json.decode(json.decode(response.body));

      if (decoded['Status'] == 'Success') {
        final List<dynamic> records = decoded['data'];

        // ✅ Parse each item safely
        final List<ClassModel> fullList = records.map((item) {
          return ClassModel.fromJson(item as Map<String, dynamic>);
        }).toList();

        if (filter.isEmpty) return fullList;

        // ✅ Filter logic
        return fullList.where((item) {
          final search = filter.toLowerCase();
          return item.name.toLowerCase().contains(search) ||
              item.id.toString().toLowerCase().contains(search);
        }).toList();
      } else {
        throw Exception('API returned failure status');
      }
    } else {
      throw Exception('Failed to load category list');
    }
  }

  static Future<List<DeptModel>> getDepartmentList({String filter = ""}) async {
    final response = await http.get(
      Uri.parse("${AppConstants.apiBaseUrl}api/mobileapp/getclaimdept"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Prefs.getToken('token')}",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);

      if (decoded['success'] == true) {
        final List<dynamic> records = decoded['payload'] ?? [];

        final List<DeptModel> fullList = records.map((item) {
          return DeptModel.fromJson(item as Map<String, dynamic>);
        }).toList();

        if (filter.isEmpty) return fullList;

        // Filter by name or ID
        return fullList.where((item) {
          final search = filter.toLowerCase();
          return item.name.toLowerCase().contains(search) ||
              item.id.toString().toLowerCase().contains(search);
        }).toList();
      } else {
        throw Exception(decoded['message'] ?? 'API returned failure status');
      }
    } else {
      throw Exception(
          'Failed to load department list (status: ${response.statusCode})');
    }
  }

  static Future<List<PayCompModel>> paycomponentlist(
      {String filter = ""}) async {
    final response = await http.get(
      Uri.parse("${AppConstants.apiBaseUrl}api/mobileapp/getclaimpaycomponent"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Prefs.getToken('token')}",
      },
    );

    if (response.statusCode == 200) {
      // ✅ Decode only once
      final Map<String, dynamic> decoded = json.decode(response.body);

      if (decoded['success'] == true) {
        final List<dynamic> records = decoded['payload'] ?? [];

        // ✅ Filter by pay group
        final filteredList = records
            .where((item) =>
                item['paygrpinpayrollcomp'].toString() ==
                Prefs.getPayGroupId(SharefprefConstants.sharedpaygroupid)
                    .toString())
            .map((item) => PayCompModel.fromJson(item as Map<String, dynamic>))
            .toList();

        // ✅ Optional name/id filter
        if (filter.isNotEmpty) {
          final search = filter.toLowerCase();
          return filteredList.where((item) {
            return item.name.toLowerCase().contains(search) ||
                item.id.toString().contains(search);
          }).toList();
        }

        return filteredList;
      } else {
        return [];
      }
    } else {
      throw Exception(
          'Failed to load pay component list (status: ${response.statusCode})');
    }
  }

  static Future<http.Response> postexpparent(dynamic json) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.postexpheader);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<http.Response> postexpdetails(dynamic json) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.postexpdetails);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );

    return response;
  }

  static Future<List<ExpenseData>> fetchExpenses() async {
    var body = {
      "empid": Prefs.getNsID(SharefprefConstants.sharednsid.toString())
    };
    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    final response = await http.post(
        Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewexpense),
        headers: headers,
        body: jsonEncode(body));
    print(Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewexpense));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        final List messages = data['message'];

        if (messages.isEmpty) {
          return []; // return empty list
        }
        return messages.map((e) => ExpenseData.fromJson(e)).toList();
      } else {
        // ✅ In case status is false but response is valid
        return [];
      }
    } else {
      throw Exception('Failed to load');
    }
  }

  static Future<http.Response> getBirthdayList() async {
    var url =
        Uri.parse('${AppConstants.apiBaseUrl}api/mobileapp/getbirthdaylist');

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };

    var response = await http.get(url, headers: headers).timeout(
          const Duration(seconds: timeOutDuration),
        );
    return response;
  }

  static Future<http.Response> getPendingleaves() async {
    var url =
        Uri.parse('${AppConstants.apiBaseUrl}api/mobileapp/gettodayleavelist');

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };

    var response = await http.get(url, headers: headers).timeout(
          const Duration(seconds: timeOutDuration),
        );
    return response;
  }

  static Future<http.Response> viewcompoffleave() async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewleavecompoff);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //'Authorization': 'Bearer ${Prefs.getToken('token')}'
    };
    var body = {
      "nsid": int.parse(Prefs.getNsID('nsid').toString()),
    };

    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    print(jsonEncode(body));
    return response;
  }

  static Future<List<YearModel>> getyearModel({String filter = ""}) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${Prefs.getToken('token')}",
    };

    final response = await http.get(
      Uri.parse("${AppConstants.apiBaseUrl}api/mobileapp/getyearlist"),
      headers: headers,
    );

    if (response.statusCode == 200 &&
        json.decode(response.body)['success'] == true) {
      List<dynamic> data = json.decode(response.body)['payload'];

      // ✅ Convert model first
      List<YearModel> list =
          data.map((item) => YearModel.fromJson(item)).toList();

      // ✅ Remove inactive
      list = list.where((item) => item.inactive == false).toList();

      // ✅ Apply search filter
      if (filter.isNotEmpty) {
        String query = filter.toLowerCase();

        list = list.where((item) {
          return item.name.toLowerCase().contains(query) ||
              item.id.toString().toLowerCase().contains(query);
        }).toList();
      }

      // ✅ ✅ Reverse ALWAYS
      return list.reversed.toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  static Future<List<LetterTypeModel>> getLetterType(
      {String filter = ""}) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${Prefs.getToken('token')}",
    };
    final response = await http.get(
        Uri.parse("${AppConstants.apiBaseUrl}api/mobileapp/getelettertypelist"),
        headers: headers);

    if (response.statusCode == 200 &&
        json.decode(response.body)['success'] == true) {
      List<dynamic> data = json.decode(response.body)['payload'];

      if (filter.isEmpty) {
        return data.map((item) => LetterTypeModel.fromJson(item)).toList();
      }
      return data
          .map((item) => LetterTypeModel.fromJson(item))
          .where((item) => item.inactive == false) // 👈 skip inactive ones
          .where((item) =>
              item.name
                  .toString()
                  .toLowerCase()
                  .contains(filter.toString().toLowerCase()) ||
              item.id
                  .toString()
                  .toLowerCase()
                  .contains(filter.toString().toLowerCase()))
          .toList()
          .reversed
          .toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  static Future<List<CopyTypeModel>> getcopyTypeList(
      {String filter = ""}) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${Prefs.getToken('token')}",
    };
    final response = await http.get(
        Uri.parse("${AppConstants.apiBaseUrl}api/mobileapp/getecopylist"),
        headers: headers);

    if (response.statusCode == 200 &&
        json.decode(response.body)['success'] == true) {
      List<dynamic> data = json.decode(response.body)['payload'];

      if (filter.isEmpty) {
        return data.map((item) => CopyTypeModel.fromJson(item)).toList();
      }
      return data
          .map((item) => CopyTypeModel.fromJson(item))
          .where((item) => item.inactive == false) // 👈 skip inactive ones
          .where((item) =>
              item.name
                  .toString()
                  .toLowerCase()
                  .contains(filter.toString().toLowerCase()) ||
              item.id
                  .toString()
                  .toLowerCase()
                  .contains(filter.toString().toLowerCase()))
          .toList()
          .reversed
          .toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  static Future<http.Response> viewPayslip(dynamic json) async {
    var url = Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewpayslip);

    final headers = {
      "Content-Type": "application/json",
    };

    var response =
        await http.post(url, body: jsonEncode(json), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    print("📥 Response: ${response.body}");
    return response;
  }

  static Future<List<AssetTypeModel>> getAssetTypelist(
      {String filter = ""}) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${Prefs.getToken('token')}",
    };
    final response = await http.get(
        Uri.parse("${AppConstants.apiBaseUrl}api/mobileapp/getassetTypelist"),
        headers: headers);

    if (response.statusCode == 200 &&
        json.decode(response.body)['success'] == true) {
      List<dynamic> data = json.decode(response.body)['payload'];

      if (filter.isEmpty) {
        return data.map((item) => AssetTypeModel.fromJson(item)).toList();
      }
      return data
          .map((item) => AssetTypeModel.fromJson(item))
          .where((item) => item.inactive == false) // 👈 skip inactive ones
          .where((item) =>
              item.name
                  .toString()
                  .toLowerCase()
                  .contains(filter.toString().toLowerCase()) ||
              item.id
                  .toString()
                  .toLowerCase()
                  .contains(filter.toString().toLowerCase()))
          .toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  static Future<List<AssetNameModel>> getAssetNamelist(
      {String filter = ""}) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${Prefs.getToken('token')}",
    };
    final response = await http.get(
        Uri.parse("${AppConstants.apiBaseUrl}api/mobileapp/getassetnamelist"),
        headers: headers);

    if (response.statusCode == 200 &&
        json.decode(response.body)['success'] == true) {
      List<dynamic> data = json.decode(response.body)['payload'];

      if (filter.isEmpty) {
        return data.map((item) => AssetNameModel.fromJson(item)).toList();
      }
      return data
          .map((item) => AssetNameModel.fromJson(item))
          .where((item) => item.inactive == false) // 👈 skip inactive ones
          .where((item) =>
              item.name
                  .toString()
                  .toLowerCase()
                  .contains(filter.toString().toLowerCase()) ||
              item.id
                  .toString()
                  .toLowerCase()
                  .contains(filter.toString().toLowerCase()))
          .toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  static Future<List<LeaveTypeModel>> getleaveType({
    String filter = "",
    String? type,
  }) async {
    final response = await http.get(
      Uri.parse("${AppConstants.apiBaseUrl}api/mobileapp/getleavetypenew")
          .replace(
        queryParameters: {
          "empId": Prefs.getNsID(SharefprefConstants.sharednsid),
          "type": type
        },
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Prefs.getToken('token')}",
      },
    );

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['success'] == true) {
      final decoded = jsonDecode(response.body);
      final payload = decoded['payload'] as List;

      // ✅ Get current logged employee id
      final loggedEmpId = Prefs.getNsID(SharefprefConstants.sharednsid);
      print("👤 Logged Emp ID: $loggedEmpId");

      // ✅ Find employee object matching empid
      final employee = payload.firstWhere(
        (e) => e['empid'].toString() == loggedEmpId.toString(),
        orElse: () => null,
      );

      if (employee == null) {
        print("⚠️ No employee found with empid: $loggedEmpId");
        return [];
      }

      // ✅ Extract leave types for that employee
      final leaveTypes = employee['leaveTypes'] ?? [];

      // ✅ Convert to model list
      final allLeaveTypes =
          (leaveTypes as List).map((e) => LeaveTypeModel.fromJson(e)).toList();

      final filtered = allLeaveTypes.where((item) {
        final matchesName = filter.isEmpty ||
            item.leaveTypeName.toLowerCase().contains(filter.toLowerCase());
        // final notExcluded =
        //     item.leaveTypeId.toString() != excludeLeaveTypeId.toString();
        return matchesName;
      }).toList();

      return filtered;
    } else {
      return [];
    }
  }

  static Future<List<LeaveBalanceModel>> getleavebalance(
      {String filter = ""}) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${Prefs.getToken('token')}",
    };

    final response = await http.get(
      Uri.parse("${AppConstants.apiBaseUrl}api/mobileapp/getleavebalancelist"),
      headers: headers,
    );

    if (response.statusCode == 200 &&
        json.decode(response.body)['success'] == true) {
      List<dynamic> data = json.decode(response.body)['payload'];

      final String loggedInEmpId =
          Prefs.getEmpID(SharefprefConstants.sharednsid).toString();

      print("✅ Logged in EmpID = $loggedInEmpId");

      // ✅ Filter
      List<dynamic> filtered = data.where((item) {
        return item["empId"].toString() == loggedInEmpId;
      }).toList();

      print("✅ Filtered Count = ${filtered.length}");

      return filtered.map((item) => LeaveBalanceModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  static Future<http.Response> validatedate(
      String fromDate, String toDate, String leaveTypeId, String nsId) async {
    final url = Uri.parse(
        '${AppConstants.apiBaseUrl}api/mobileapp/netsuiteviewleaveValidation'
        '?fromdate=$fromDate&todate=$toDate&leavetypeid=$leaveTypeId&nsId=$nsId');

    Map<String, String> headers = {
      "Content-Type": "application/json",
      //"Authorization": "Bearer ${Prefs.getToken('token')}"
    };

    return await http.get(url, headers: headers).timeout(
          const Duration(seconds: timeOutDuration),
        );
  }

  static Future<List<HolidayModel>> getHolidayMaster(
      {String? regionFilter}) async {
    final response = await http.get(
      Uri.parse("${AppConstants.apiBaseUrl}api/mobileapp/getholiday"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Prefs.getToken('token')}",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);

      if (decoded['success'] == true) {
        final List<dynamic> payload = decoded['payload'] ?? [];

        return payload
            .map((item) => HolidayModel.fromJson(item))
            .toList()
            .reversed
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception(
          'Failed to load holiday list (status: ${response.statusCode})');
    }
  }

  // static Future<List<HolidayModel>> getHolidayMaster({
  //   String? regionFilter, // optional region filter (null or "" = show all)
  // }) async {
  //   final response = await http.get(
  //     Uri.parse("${AppConstants.apiBaseUrl}api/mobileapp/getholiday"),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer ${Prefs.getToken('token')}",
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> decoded = json.decode(response.body);

  //     if (decoded['success'] == true) {
  //       final List<dynamic> payload = decoded['payload'] ?? [];

  //       // ✅ Convert to model list
  //       final List<HolidayModel> allHolidays =
  //           payload.map((item) => HolidayModel.fromJson(item)).toList();

  //       // ✅ Apply filtering
  //       final List<HolidayModel> filtered = allHolidays.where((item) {
  //         // include only active holidays
  //         final bool isActive = item.inactive == false;

  //         // if regionFilter is empty/null, include all
  //         if (regionFilter == null || regionFilter.isEmpty) {
  //           return isActive;
  //         }

  //         // if regionFilter is set, include only if matches
  //         final List<String> regions =
  //             item.region.split(',').map((e) => e.trim()).toList();

  //         final bool matchesRegion = regions.contains(regionFilter);

  //         return isActive && matchesRegion;
  //       }).toList();

  //       // ✅ Sort or reverse if desired
  //       return filtered.reversed.toList();
  //     } else {
  //       throw Exception(decoded['message'] ?? 'API returned failure status');
  //     }
  //   } else {
  //     throw Exception(
  //         'Failed to load holiday list (status: ${response.statusCode})');
  //   }
  // }

  static Future<List<SkillMasterModel>> getSkillMaster(
      {String filter = ""}) async {
    final response = await http.get(
      Uri.parse("${AppConstants.apiBaseUrl}api/mobileapp/getskill"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Prefs.getToken('token')}",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);

      if (decoded['success'] == true) {
        final List<dynamic> records = decoded['payload'] ?? [];

        // ✅ Only include active skills
        final List<SkillMasterModel> fullList = records
            .where((item) => item['inactive'] == false)
            .map((item) =>
                SkillMasterModel.fromJson(item as Map<String, dynamic>))
            .toList();

        // ✅ Optional filter logic
        if (filter.isNotEmpty) {
          final search = filter.toLowerCase();
          return fullList.where((item) {
            return item.skillName.toLowerCase().contains(search) ||
                item.id.toString().contains(search);
          }).toList();
        }

        return fullList;
      } else {
        throw Exception(decoded['message'] ?? 'API returned failure status');
      }
    } else {
      throw Exception(
          'Failed to load skill list (status: ${response.statusCode})');
    }
  }

  static Future<List<RelationShipModel>> getrelationshiplist(
      {String filter = ""}) async {
    final response = await http.get(
      Uri.parse("${AppConstants.apiBaseUrl}api/mobileapp/getrelationship"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Prefs.getToken('token')}",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);

      if (decoded['success'] == true) {
        final List<dynamic> records = decoded['payload'] ?? [];

        final List<RelationShipModel> fullList = records.map((item) {
          return RelationShipModel.fromJson(item as Map<String, dynamic>);
        }).toList();

        if (filter.isEmpty) return fullList;

        // Filter by name or ID
        return fullList.where((item) {
          final search = filter.toLowerCase();
          return item.name.toLowerCase().contains(search) ||
              item.id.toString().toLowerCase().contains(search);
        }).toList();
      } else {
        return [];
      }
    } else {
      throw Exception(
          'Failed to load department list (status: ${response.statusCode})');
    }
  }

  static Future<List<DocumentTypeModel>> getDocuemntlist(
      {String filter = ""}) async {
    final response = await http.get(
      Uri.parse("${AppConstants.apiBaseUrl}api/mobileapp/getdocumentlist"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Prefs.getToken('token')}",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);

      if (decoded['success'] == true) {
        final List<dynamic> records = decoded['payload'] ?? [];

        final List<DocumentTypeModel> fullList = records.map((item) {
          return DocumentTypeModel.fromJson(item as Map<String, dynamic>);
        }).toList();

        if (filter.isEmpty) return fullList;

        // Filter by name or ID
        return fullList.where((item) {
          final search = filter.toLowerCase();
          return item.name.toLowerCase().contains(search) ||
              item.id.toString().toLowerCase().contains(search);
        }).toList();
      } else {
        return [];
      }
    } else {
      throw Exception(
          'Failed to load department list (status: ${response.statusCode})');
    }
  }

  static Future<List<LeaveTypeModel>> getleaveTypeComp(String type) async {
    final response = await http.get(
      Uri.parse("${AppConstants.apiBaseUrl}api/mobileapp/getleavetypenew")
          .replace(
        queryParameters: {
          "empId": Prefs.getNsID('nsid').toString(),
          "type": type
        },
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Prefs.getToken('token')}",
      },
    );

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['success'] == true) {
      final decoded = jsonDecode(response.body);
      final payload = decoded['payload'] as List;

      // ✅ If API returns only 1 employee record, skip empid filter
      final employee = payload.isNotEmpty ? payload.first : null;

      if (employee == null) {
        print("⚠️ No employee data found");
        return [];
      }

      final leaveTypes = employee['leaveTypes'] ?? [];
      print(leaveTypes);
      final allLeaveTypes =
          (leaveTypes as List).map((e) => LeaveTypeModel.fromJson(e)).toList();

      return allLeaveTypes;
    } else {
      throw Exception("Failed to load leave types");
    }
  }

  static Future<http.Response> viewAttendanceHistoryLog() async {
    var url = Uri.parse(
        AppConstants.apiBaseUrl + ApiDetails.viewbioattendancehistorylog);

    Map<String, String> headers = {"Content-Type": "application/json"};

    var body = {
      "nsId": int.parse(Prefs.getNsID('nsid').toString()),
    };
    print(jsonEncode(body));
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers).timeout(
              const Duration(seconds: timeOutDuration),
            );
    return response;
  }
}
