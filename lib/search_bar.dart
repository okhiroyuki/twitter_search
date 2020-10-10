import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SearchAppBar extends StatefulWidget {
  @override
  _SearchAppBarState createState() => new _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  final TextEditingController _textEditingController = new TextEditingController();
  WebViewController controller;
  String _text = '';
  Widget appBarTitle = new Text("Twitter Search");

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _textEditingController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _printLatestValue() {
    print("入力状況: ${_textEditingController.text}");
  }

  void _handleText(String e) {
    setState(() {
      _text = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          centerTitle: true,
          title: new TextField(
            controller: _textEditingController,
            style: new TextStyle(
              color: Colors.white,
            ),
            decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search, color: Colors.white),
            ),
            onChanged: _handleText,
            onSubmitted:_submission,
          ),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.clear),
              onPressed:(){
                _textEditingController.clear();
                setState(() {
                  _text = '';
                });
              }, ),
          ]
      ),
      body: Center(
        child: WebView(
          initialUrl: 'https://mobile.twitter.com',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
              controller = webViewController;
          },
        ),
      ),
    );
  }

  void _submission(String v) {
    if(_text.length == 0) return;
    _textEditingController.clear();
    setState(() {
      if(_text.length > 0){
        var url = 'https://mobile.twitter.com/search?q=' + _text + '&src=typed_query';
        controller.loadUrl(url);
      }
      _text = '';
    });
  }
}