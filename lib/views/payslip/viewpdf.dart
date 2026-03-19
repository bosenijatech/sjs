import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ViewPdf extends StatefulWidget {
  final String pdfurl;
  const ViewPdf({super.key, required this.pdfurl});

  @override
  State<ViewPdf> createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  bool downloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AppUtils.buildNormalText(
          text: "View Payslip",
          color: Colors.black,
          fontSize: 20,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: downloading
                ? null
                : () async {
                    await _downloadPdf(widget.pdfurl);
                  },
            icon: downloading
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CupertinoActivityIndicator(),
                  )
                : const Icon(
                    CupertinoIcons.download_circle,
                    color: Colors.black,
                    size: 24,
                  ),
          )
        ],
      ),
      body: widget.pdfurl.isNotEmpty
          ? SfPdfViewer.network(
              widget.pdfurl,
              canShowPageLoadingIndicator: true,
            )
          : const Center(
              child: Text("Invalid PDF URL"),
            ),
    );
  }

  Future<void> _downloadPdf(String url) async {
    try {
      setState(() => downloading = true);

      // Ask for permission (Android)
      if (Platform.isAndroid) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          setState(() => downloading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Storage permission denied."),
              backgroundColor: Colors.redAccent,
            ),
          );
          return;
        }
      }

      // Fetch file data
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to download PDF');
      }

      // Get storage path
      Directory? dir;
      if (Platform.isAndroid) {
        dir = await getExternalStorageDirectory();
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      String folderPath = "${dir!.path}/Payslips";
      await Directory(folderPath).create(recursive: true);

      String fileName = "Payslip_${DateTime.now().millisecondsSinceEpoch}.pdf";
      File file = File('$folderPath/$fileName');

      await file.writeAsBytes(response.bodyBytes);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("PDF saved to $folderPath"),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error downloading PDF: $e"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => downloading = false);
    }
  }
}
