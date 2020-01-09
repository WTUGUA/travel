import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';


class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
  final int word;

  WebViewPage({Key key, @required this.word}) : super(key: key);
}

class _WebViewPageState extends State<WebViewPage> {
  String _title = "隐私政策";
  WebViewController _webViewController;
  String filePath = 'files/travel_yingsi.html';
  @override
  void initState() {
    if(widget.word==1){
      setState(() {
        _title = "服务条款";
        filePath='files/travel_test.html';
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text(_title),
      ),
        body: WebView(
          initialUrl: '',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _webViewController = webViewController;
            _loadHtmlFromAssets();
          },
        )
    );
  }

  _loadHtmlFromAssets() async {
    String fileHtmlContents = await rootBundle.loadString(filePath);
    _webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')).toString());
  }
}