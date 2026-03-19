import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewFiles extends StatefulWidget {
  final String fileUrl;
  final String fileName;
  final String? mimeType;
  const ViewFiles(
      {super.key,
      required this.fileUrl,
      required this.fileName,
      required this.mimeType});

  @override
  State<ViewFiles> createState() => _ViewFilesState();
}

class _ViewFilesState extends State<ViewFiles> {
  bool downloading = false;
  String? mimeType;

  @override
  void initState() {
    super.initState();
    if (widget.mimeType != null) {
      mimeType = widget.mimeType;
    } else {
      _fetchMimeType(); // fallback if not provided
    }
  }

  Future<void> _fetchMimeType() async {
    try {
      final response = await http.get(Uri.parse(widget.fileUrl));
      if (response.statusCode == 200) {
        setState(() {
          mimeType = response.headers['content-type'];
        });
      }
    } catch (e) {
      debugPrint("Failed to detect MIME type: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget viewer = const Center(
        child: CircularProgressIndicator(
      color: Colors.amber,
    ));

    if (mimeType != null) {
      if (mimeType!.contains('pdf')) {
        viewer = SfPdfViewer.network(widget.fileUrl);
      } else if (mimeType!.contains('image')) {
        viewer = InteractiveViewer(child: Image.network(widget.fileUrl));
      } else if (mimeType!.contains('text')) {
        viewer = FutureBuilder<String>(
          future: http.read(Uri.parse(widget.fileUrl)),
          builder: (_, snapshot) => snapshot.hasData
              ? SingleChildScrollView(child: Text(snapshot.data!))
              : const Center(child: CircularProgressIndicator()),
        );
      } else {
        viewer = const Center(
            child: Text("Preview not supported. Download to view."));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
        actions: [
          IconButton(
            icon: downloading
                ? const CupertinoActivityIndicator()
                : const Icon(CupertinoIcons.download_circle),
            onPressed: downloading
                ? null
                : () => _downloadFile(widget.fileUrl, widget.fileName),
          )
        ],
      ),
      body: viewer,
    );
  }

  Future<void> _downloadFile(String url, String fileName) async {
    try {
      setState(() => downloading = true);

      if (Platform.isAndroid) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Storage permission denied.")),
          );
          return;
        }
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) throw Exception("Download failed");

      final dir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();

      final folder = Directory("${dir!.path}/Downloads");
      await folder.create(recursive: true);

      final file = File("${folder.path}/$fileName");
      await file.writeAsBytes(response.bodyBytes);

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: const Text("File downloaded successfully!"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"))
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text(e.toString()),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"))
            ],
          ),
        );
      }
    } finally {
      setState(() => downloading = false);
    }
  }
}
