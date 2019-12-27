import 'dart:async';

import 'package:flutter/material.dart';
import 'package:traveltranslation/ocr/config/application.dart';
import 'package:webview_flutter/webview_flutter.dart';

const String kNavigationExamplePage = '''
<!DOCTYPE html><html>
<head><title>Navigation Delegate Example</title></head>
<body>
<p>
The navigation delegate is set to block navigation to the youtube website.
</p>
<ul>
<ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
<ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
</ul>
</body>
</html>
''';

class WebViewComponent extends StatefulWidget {
  final String initUrl;

  WebViewComponent(this.initUrl);

  @override
  _WebViewComponentState createState() => _WebViewComponentState();
}

class _WebViewComponentState extends State<WebViewComponent> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR协议'),
// This drop down menu demonstrates that Flutter widgets can be shown over the web view.
//        actions: <Widget>[
//          NavigationControls(_controller.future),
//          SampleMenu(_controller.future),
//        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: this.widget.initUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
// TODO(iskakaushik): Remove this when collection literals makes it to stable.
// ignore: prefer_collection_literals
//          javascriptChannels: <JavascriptChannel>[
//            _toasterJavascriptChannel(context),
//          ].toSet(),
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('js://webview')) {
              print('blocking navigation to $request}');

              Application.router.navigateTo(context, "/vip");
              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
        );
      }),
    );
  }
}
