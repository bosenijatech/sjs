import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AllFileViewer extends StatefulWidget {
  String sourcefile;
  AllFileViewer({super.key, required this.sourcefile});

  @override
  State<AllFileViewer> createState() => _AllFileViewerState();
}

class _AllFileViewerState extends State<AllFileViewer> {
  bool firstTimeLoading = true;
  late final WebViewController controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            if (firstTimeLoading) {
              setState(() {
                firstTimeLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          "https://docs.google.com/gview?embedded=true&url=${widget.sourcefile}"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                child: WebViewWidget(
                  controller: controller,
                ))
          ],
        ),
      ),
    );
  }
}
