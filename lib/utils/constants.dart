import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

class AppConstants {
  static String apiBaseUrl = 'https://mobapp.nijatech.com:6000/';

  static const String androidAppPackageName = "com.nijatech.winstar";
  static const String iOSAppID = "6738953923";

  static const String netSuiteapiBaseUrl =
      'https://11906425.restlets.api.netsuite.com/app/site/hosting/restlet.nl?';

  static List<Map<String, dynamic>> categories = [
    {"icon": Icons.location_on_outlined, "text": "Attendance"},
    {"icon": Icons.leave_bags_at_home, "text": "Regularization"},
    {"icon": Icons.flight_takeoff, "text": "Leave Request"},
    {"icon": Icons.flight_takeoff, "text": "Comp Off Request"},
    {"icon": Icons.edit_document, "text": "Letter request"},
    {"icon": Icons.payment, "text": "Payslip"},
    {"icon": Icons.assessment, "text": "Asset Request"},
    {"icon": Icons.join_full, "text": "Rejoin Request"},
    {"icon": Icons.person, "text": "Profile"},
  ];

  static convertdateformat(from) {
    if (from.toString().isNotEmpty) {
      String concatefrom = '$from 00:00:00';

      DateTime dt1 = DateTime.parse(concatefrom);

      var convertiondate = DateFormat.yMMMEd().format(dt1);
      return convertiondate.toString();
    } else {
      return;
    }
  }

  static convertdateformat1(from) {
    if (from.toString().isNotEmpty) {
      String concatefrom = '$from';

      DateTime dt1 = DateTime.parse(concatefrom);

      var convertiondate = DateFormat.yMMMMEEEEd().format(dt1);
      return convertiondate.toString();
    } else {
      return;
    }
  }

  static changeddmmyyformat(datetime) {
    return DateFormat("dd-MM-yyyy").format(DateTime.parse(datetime));
  }

  static changeAMPMformat(datetime) {
    return DateFormat("hh:mm a").format(datetime);
  }

  static String formatDateleave(String dateStr) {
    final date = DateTime.parse(dateStr); // parse "2025-09-18"
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;

    return '$day/$month/$year';
  }

  static changeddmmyyhhmmssformat(datetime) {
    return DateFormat("dd-MM-yyyy hh:mm a").format(DateTime.parse(datetime));
  }

  static changeyymmddhoursformat(datetime) {
    var inputFormat = DateFormat('dd/MM/yyyy');
    var date1 = inputFormat.parse(datetime);

    var outputFormat = DateFormat('yyyy-MM-dd');
    var date2 = outputFormat.format(date1);
    return date2;
  }

  // netsuite

  static launchUrl(url, {bool isNewTab = true}) async {
    if (Platform.isAndroid) {
      if (!await launchUrl(
        url,
      )) {
        throw Exception('Could not launch $url');
      }
    } else if (Platform.isIOS) {
      if (!await launchUrl(
        url,
      )) {
        throw Exception('Could not launch $url');
      }
    }
  }

  static String getExtensionFromMime(String? mime) {
    if (mime == null) return '';
    if (mime.contains('pdf')) return 'pdf';
    if (mime.contains('image')) return 'image';
    if (mime.contains('msword') || mime.contains('word')) return 'docx';
    if (mime.contains('excel')) return 'xlsx';
    if (mime.contains('text')) return 'txt';
    if (mime.contains('zip')) return 'zip';
    return 'unknown';
  }

  static Future<String?> getMimeType(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      final contentType = response.headers['content-type'];
      if (contentType != null) return contentType;

      // fallback: guess from URL extension
      final ext = url.split('.').last;
      return lookupMimeType('file.$ext');
    } catch (e) {
      debugPrint("MIME detection failed: $e");
      return null;
    }
  }

  static const int travelpurposcriptid = 3317;
  static const int travelpurposedeployid = 1;

  static const int travelmodesciptid = 3316;
  static const int travelmodedeployid = 1;

  // static const int empdocumentscriptid = 731;
  // static const int empdocumentdeployid = 1;

  static const int empeducationscriptid = 730;
  static const int empeducationdeployid = 1;

  // static const int emprelationscriptid = 729;
  // static const int emprelationdeployid = 1;

  static const int getcompanyscriptid = 727;
  static const int getcompanydeployod = 1;

  static const int getsubsidiaryscriptId = 792;
  static const int getsubsidiarydeployId = 1;

  static const int classscriptId = 788;
  static const int classsdeployId = 1;

  static const bool isyellow = true;

  static List<Color> colorArray = [
    const Color(0xFF1ea4a9),
    const Color(0xFF5697db),
    const Color(0xFFeb3f55),
    const Color(0xFFF39F5A),
    const Color(0xFF5B0888),
    const Color(0xFF618264),
    const Color(0xFF80B300),
    const Color(0xFF00B3E6),
    const Color(0xFF1ea4a9),
    const Color(0xFF5697db),
  ];

  static List<Color> containercolorArray = const [
    Color(0xFFF875AA),
    Color(0xFF00B3E6),
    Color(0xFFB931FC),
    Color(0xFF5697db),
    Color(0xFFeb3f55),
    Color(0xFF5B0888),
    Color(0xFF5697db),
    Color(0xFFF4CE14),
    Color(0xFFD83F31),
  ];

  static List<Color> lightcolorArray = [
    const Color(0xFF1ea4a9),
    const Color(0xFF5697db),
    const Color(0xFFeb3f55),
    const Color(0xFFF39F5A),
    const Color(0xFF8e18cd),
    const Color(0xFF618264),
  ];

  static List<Color> darkcolorArray = const [
    Color(0xFF1963b3),
    Color(0xff093e77),
    Color(0xFF841020),
    Color(0xFFcd6a18),
    Color(0xFF5B0888),
    Color(0xff0f7017)
  ];

  static String getFileTypeExtension(String fileName) {
    return ".${fileName.split('.').last}".toLowerCase();
  }

  static int daysBetween(from, to) {
    DateTime fromdatetime = DateTime.parse(from);
    DateTime toatetime = DateTime.parse(to);
    final differenceInDays = toatetime.difference(fromdatetime).inDays + 1;
    print(differenceInDays);
    return differenceInDays;
  }
}
