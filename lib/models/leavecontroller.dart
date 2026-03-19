import 'package:winstar/models/viewleavemodel.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/api_details.dart';
import 'package:winstar/utils/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LeaveController {
  List<Message> data = [];
  ViewLeaveModel leavemodel = ViewLeaveModel();
  int currentPage = 1;
  int itemsPerPage = 5;

  Future<void> fetchData() async {
    try {
      Map<String, String> headers = {
        "Content-Type": "application/json",
        //'Authorization': 'Bearer ${Prefs.getToken('token')}'
      };
      var body = {
        "nsid": Prefs.getNsID('nsid'),
      };

      final response = await http.post(
          Uri.parse(AppConstants.apiBaseUrl + ApiDetails.viewleave),
          body: jsonEncode(body),
          headers: headers);

      if (response.statusCode == 200) {
        leavemodel = ViewLeaveModel.fromJson(jsonDecode(response.body));
        data.clear();
        if (leavemodel.message!.isEmpty) {
        } else {
          leavemodel.message?.forEach((element) {
            data.add(Message(
                element.sId.toString(),
                element.date.toString(),
                element.leavetypecode.toString(),
                element.leavetypename.toString(),
                element.leavebalance.toString(),
                element.fromdate.toString(),
                element.todate.toString(),
                element.totalNoOfDays,
                element.attachment.toString(),
                element.reason.toString(),
                element.airticketrequired.toString(),
                element.airticketamount,
                element.airticketattachment.toString(),
                element.iscancelled.toString(),
                element.isstatus,
                element.createdby,
                element.createdByEmpName.toString(),
                element.createdDate.toString(),
                element.toEmpID,
                element.toEmpName,
                element.isSync,
                element.approvalHistory));
          });
        }
      } else {
        throw Exception(
            'Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<void> nextPage() async {
    try {
      if (currentPage < data.length ~/ itemsPerPage) {
        currentPage++;
        await fetchData();
      }
    } catch (e) {
      throw Exception('Failed to navigate to the next page: $e');
    }
  }

  Future<void> previousPage() async {
    try {
      if (currentPage > 1) {
        currentPage--;
        await fetchData();
      }
    } catch (e) {
      throw Exception('Failed to navigate to the previous page: $e');
    }
  }

  List<Message> getCurrentPageData() {
    try {
      int startIndex = (currentPage - 1) * itemsPerPage;
      int endIndex = startIndex + itemsPerPage;
      endIndex = endIndex.clamp(0, data.length);
      return data.sublist(startIndex, endIndex);
    } catch (e) {
      throw Exception('Failed to retrieve current page data: $e');
    }
  }
}

class Message {
  String? sId;
  String? date;
  String? leavetypecode;
  String? leavetypename;
  var leavebalance;
  String? fromdate;
  String? todate;
  int? totalNoOfDays;
  String? attachment;
  String? reason;
  String? airticketrequired;
  int? airticketamount;
  String? airticketattachment;
  String? iscancelled;
  String? isstatus;
  int? createdby;
  String? createdbyEmpName;
  String? createdDate;
  int? toEmpID;
  String? toEmpName;
  int? isSync;
  List<ApprovalHistory>? approvalHistory;
  int? iV;

  Message(
      this.sId,
      this.date,
      this.leavetypecode,
      this.leavetypename,
      this.leavebalance,
      this.fromdate,
      this.todate,
      this.totalNoOfDays,
      this.attachment,
      this.reason,
      this.airticketrequired,
      this.airticketamount,
      this.airticketattachment,
      this.iscancelled,
      this.isstatus,
      this.createdby,
      this.createdbyEmpName,
      this.createdDate,
      this.toEmpID,
      this.toEmpName,
      this.isSync,
      this.approvalHistory);

  Message.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    date = json['date'];
    leavetypecode = json['leavetypecode'];
    leavetypename = json['leavetypename'];
    leavebalance = json['leavebalance'];
    fromdate = json['fromdate'];
    todate = json['todate'];
    totalNoOfDays = json['total_no_of_days'];
    attachment = json['attachment'];
    reason = json['reason'];
    airticketrequired = json['airticketrequired'];
    airticketamount = json['airticketamount'];
    airticketattachment = json['airticketattachment'];
    iscancelled = json['iscancelled'];
    isstatus = json['isstatus'];
    createdby = json['createdby'];
    createdbyEmpName = json['createdByEmpName'];
    createdDate = json['createdDate'];
    toEmpID = json['toEmpID'];
    toEmpName = json['toEmpName'];
    isSync = json['isSync'];
    if (json['approval_history'] != null) {
      approvalHistory = <ApprovalHistory>[];
      json['approval_history'].forEach((v) {
        approvalHistory!.add(ApprovalHistory.fromJson(v));
      });
    }
  }
}
