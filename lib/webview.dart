import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final Uri initialPageUrl;
  final Uri closeViewUrl;

  const WebViewScreen({Key key, this.initialPageUrl, this.closeViewUrl})
      : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: widget.initialPageUrl.toString(),
      navigationDelegate: (navReq) {
        print('Navigating to ${navReq.url}');
        if (navReq.url.startsWith(widget.closeViewUrl.toString())) {
          var responseUrl = Uri.parse(navReq.url);
          Navigator.of(context).pop(responseUrl);
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    );
  }
}
