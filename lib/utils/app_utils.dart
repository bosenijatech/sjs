import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winstar/utils/appcolor.dart';
import 'package:path_provider/path_provider.dart';

class AppUtils {
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static String capitalize(String value) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty) return value;
    if (trimmed.length == 1) return trimmed.toUpperCase();
    return '${trimmed[0].toUpperCase()}${trimmed.substring(1)}';
  }

  static void showSnackbar({
    required BuildContext context,
    required String? message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 4),
  }) {
    if (message == null || message.trim().isEmpty) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? Colors.red,
        duration: duration,
      ),
    );
  }

  // show dialog popup
  static Future<T?> showSingleDialogPopup<T>(
    BuildContext context,
    String title,
    String buttonname,
    VoidCallback onPressed,
    String? icons,
  ) {
    return showDialog<T>(
        barrierDismissible: false,
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            icon: (icons != null)
                ? Image.asset(
                    icons,
                    width: 80,
                    height: 80,
                  )
                : const SizedBox.shrink(),
            title: Text(
              title,
              maxLines: null,
              style: const TextStyle(fontSize: 14),
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFFFFFFFF),
                    minimumSize: const Size(0, 45),
                    backgroundColor: Appcolor.primarycolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onPressed,
                  child:
                      Text(buttonname, style: const TextStyle(fontSize: 14))),
            ],
          );
        });
  }

  // show confirmation dialog
  static Future<T?> showconfirmDialog<T>(
    BuildContext context,
    String title,
    String yesstring,
    String nostring,
    VoidCallback onPressedYes,
    VoidCallback onPressedNo,
  ) async {
    return showDialog<T>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            //TextButton(onPressed: onPressedYes, child: Text(yesstring)),
            // TextButton(onPressed: onPressedNo, child: Text(nostring)),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFFFFFFFF),
                  minimumSize: const Size(0, 45),
                  backgroundColor: Appcolor.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onPressedYes,
                child: Text(yesstring, style: const TextStyle(fontSize: 14))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onPressedNo,
              child: Text(
                nostring,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }

  //Text
  static Widget buildHeaderText({final String? text}) {
    return Text(
      text ?? '--',
      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    );
  }

  static Widget buildNormalText(
      {Object? text,
      Color? color,
      double fontSize = 12,
      TextAlign? textAlign,
      FontWeight? fontWeight,
      double? letterSpacing,
      double? wordSpacing,
      String? fontFamily,
      int? maxLines,
      TextOverflow? overflow,
      TextDecoration? decoration,
      double? lineSpacing,
      FontStyle? fontStyle}) {
    return Text(
      text?.toString() ?? '--',
      textAlign: textAlign ?? TextAlign.left,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
          decoration: decoration ?? TextDecoration.none,
          color: color ?? Colors.black,
          fontSize: fontSize,
          fontWeight: fontWeight ?? FontWeight.w400,
          letterSpacing: letterSpacing ?? 0.0,
          wordSpacing: wordSpacing ?? 0.0,
          fontFamily: fontFamily,
          height: lineSpacing,
          fontStyle: fontStyle ?? FontStyle.normal),
    );
  }

  static Widget iconWithText(
      {required IconData icons,
      Object? text,
      Color? iconcolor,
      Color? color,
      double fontSize = 12,
      TextAlign? textAlign,
      FontWeight? fontWeight,
      double? letterSpacing,
      double? wordSpacing,
      String? fontFamily,
      int? maxLines,
      TextOverflow? overflow,
      TextDecoration? decoration,
      double? lineSpacing,
      FontStyle? fontStyle}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icons,
          color: iconcolor ?? Colors.black,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          text?.toString() ?? '--',
          textAlign: textAlign ?? TextAlign.left,
          maxLines: maxLines,
          overflow: overflow,
          style: TextStyle(
              decoration: decoration ?? TextDecoration.none,
              color: color ?? Colors.black,
              fontSize: fontSize,
              fontWeight: fontWeight ?? FontWeight.w400,
              letterSpacing: letterSpacing ?? 0.0,
              wordSpacing: wordSpacing ?? 0.0,
              fontFamily: fontFamily,
              height: lineSpacing,
              fontStyle: fontStyle ?? FontStyle.normal),
        )
      ],
    );
  }

  static Future<void> showBottomCupertinoDialog(BuildContext context,
      {required String? title,
      required VoidCallback btn1function,
      required VoidCallback btn2function}) async {
    return showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
          title: Text(title ?? ''),
          actions: [
            CupertinoActionSheetAction(
                onPressed: btn1function, child: const Text('Camera')),
            CupertinoActionSheetAction(
                onPressed: btn2function, child: const Text('Files'))
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: const Text('Cancel'),
          )),
    );
  }

  static void pop(BuildContext context, [Object? result]) {
    Navigator.pop(context, result);
  }

  static Widget bottomHanger(BuildContext context) {
    return Center(
        child: Container(
      height: 5,
      width: MediaQuery.of(context).size.width / 6,
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(100)),
    ));
  }

  static void changeNodeFocus(BuildContext context,
      {required FocusNode current, FocusNode? next}) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      errorsnackBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(message)));
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      successsnackBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.green, content: Text(message)));
  }
  // average for ratings

  static double averageRatings(List<int> ratings) {
    if (ratings.isEmpty) return 0;
    double avg = 0;
    for (int i = 0; i < ratings.length; i++) {
      avg += ratings[i];
    }
    avg /= ratings.length;

    return avg;
  }

  static Widget gethanger(BuildContext context) {
    return bottomHanger(context);
  }

  static Future<String> createFolderInAppDocDir(String folderName) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final Directory appDocDirFolder =
        Directory('${appDocDir.path}/$folderName/');

    if (await appDocDirFolder.exists()) {
      return appDocDirFolder.path;
    } else {
      final Directory appDocDirNewFolder =
          await appDocDirFolder.create(recursive: true);
      return appDocDirNewFolder.path;
    }
  }
  // _callFolderCreationMethod() async {
  //   String folderInAppDocDir =
  //       await AppUtil.createFolderInAppDocDir('your_folder_name_here');
  // }
}
