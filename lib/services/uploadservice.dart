import 'dart:convert';
import 'dart:developer' as log;
import 'package:sjs/models/filemodel.dart';
import 'package:sjs/domain/ApiService.dart';
import 'package:sjs/utils/app_utils.dart';
import 'package:sjs/views/widgets/assets_image_widget.dart';
import 'package:flutter/material.dart';

class UploadService {
  UploadService._privateConstructor();
  static final UploadService _instance = UploadService._privateConstructor();
  static UploadService get instance => _instance;

  /// Upload attachment list and return result map
  Future<Map<String, dynamic>?> uploadAttachment(
      BuildContext context, List<AttachModel> attachlist) async {
    if (attachlist.isEmpty) {
      AppUtils.showSingleDialogPopup(
        context,
        "Please attach a file before uploading.",
        "Ok",
        () => Navigator.pop(context),
        AssetsImageWidget.warningimage,
      );
      return null;
    }

    final body = {
      "attachment": [
        {
          "FileData": attachlist[0].fileData.toString(),
          "FileType": attachlist[0].fileType.toString(),
          "FileName": attachlist[0].fileName.toString(),
        }
      ]
    };

    log.log("Upload Body: ${jsonEncode(body)}");

    try {
      final response = await ApiService.postattachment(body);

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);

        if (responseJson['status'].toString() == "true") {
          final attachmentId = responseJson['fileId'].toString();
          final attachmentUrl = responseJson['url'].toString();

          // Replace fileData with server file ID
          attachlist[0].fileData = attachmentId;

          return {
            "fileId": attachmentId,
            "url": attachmentUrl,
            "status": true,
            "message": responseJson['message'] ?? "Upload successful"
          };
        } else {
          _showErrorDialog(context, responseJson['message']);
        }
      } else {
        _showErrorDialog(context, "Upload failed: ${response.statusCode}");
      }
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }

    return null;
  }

  void _showErrorDialog(BuildContext context, String message) {
    AppUtils.showSingleDialogPopup(
      context,
      message,
      "Ok",
      () => Navigator.pop(context),
      AssetsImageWidget.errorimage,
    );
  }
}
