import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'ad_manager.dart';

class SearchAppBar extends StatefulWidget {
  @override
  _SearchAppBarState createState() => new _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  BannerAd myBanner;
  FocusNode _focus = new FocusNode();
  final TextEditingController _textEditingController = new TextEditingController();
  WebViewController controller;
  String _text = '';
  bool _isVisible = false;
  Widget appBarTitle = new Text("Twitter Search");

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _textEditingController.addListener(_printLatestValue);
    _showAdBanner();
    _initCrashlytics();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    debugPrint("Focus: " + _focus.hasFocus.toString());
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    myBanner?.dispose();
    super.dispose();
  }

  void _printLatestValue() {
    debugPrint("入力状況: ${_textEditingController.text}");
  }

  void _handleText(String e) {
    setState(() {
      _text = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new TextField(
            focusNode: _focus,
            controller: _textEditingController,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 24,
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
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              controller = webViewController;
            },
            onPageFinished: (url) async {
              debugPrint("onPageFinished: " + url);
              if(url.contains("https://mobile.twitter.com/search?q=")){
                // String jsCode = await rootBundle.loadString('assets/app.js');
                // await controller.evaluateJavascript(jsCode);
              }
              setState(() {
                _isVisible = true;
              });
            },
            navigationDelegate: (NavigationRequest request) {
              // TODO: https://github.com/flutter/flutter/issues/39441
              debugPrint('allowing navigation to $request');
              return NavigationDecision.prevent;
            },
          ),
        ),
        floatingActionButton: new Visibility(
          visible: _isVisible,
          child: new FloatingActionButton(
            child: Icon(Icons.share),
            backgroundColor: Colors.red,
            onPressed: () async {
              Share.share(await controller.currentUrl());
            },

          ),
        )
      )
    );
  }

  void _submission(String v) {
    if(_text.length == 0) return;
    _textEditingController.clear();
    setState(() async {
      if(_text.length > 0){
        var url = 'https://mobile.twitter.com/search?q=' + _text + '&src=typed_query';
        controller.loadUrl(url);
      }
      _text = '';
    });
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await controller.canGoBack()) {
      debugPrint("onwill goback");
      controller.goBack();
    } else {
      debugPrint("no goback");
      Scaffold.of(context).showSnackBar(
        const SnackBar(content: Text("No back history item")),
      );
      return Future.value(false);
    }
  }

  Future<void> _initCrashlytics() async {
    if (kDebugMode) {
      // Force disable Crashlytics collection while doing every day development.
      // Temporarily toggle this to true if you want to test crash reporting in your app.
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(false);
    }
  }

  

  Future<void> _showAdBanner() async {
    FirebaseAdMob.instance.initialize(appId:AdManager.appId);
    myBanner = BannerAd(
      // adUnitId: BannerAd.testAdUnitId, // テスト用
      adUnitId: AdManager.bannerAdUnitId, // 本番用
      size: AdSize.smartBanner, // 目的のサイズに合わせる
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
    // 表示
    myBanner
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }
}