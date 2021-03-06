import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
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
  bool _isEntry = false;
  Widget appBarTitle = new Text("Twitter Search");
  bool _hasUrl = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    // _showAdBanner();
    _initCrashlytics();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    debugPrint("Focus: " + _focus.hasFocus.toString());
    setState(() {
      _textEditingController.clear();
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    myBanner?.dispose();
    super.dispose();
  }

  void _handleText(String e) {
    setState(() {
      if(e.length > 0){
        _isEntry = true;
      }else{
        _isEntry = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: _appBarTitle(),
          actions: _appBarActions()
        ),
        body: _webView()
      )
    );
  }


  // Padding _padding(context){
  //   // 下部にAdMob広告を表示するため、スペースを空ける
  //   return Padding(
  //     child: _webView(),
  //     padding: EdgeInsets.only(
  //       bottom: AdManager.getAdBannerHeight(context),
  //     ),
  //   );
  // }

  TextField _appBarTitle(){
    return new TextField(
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
    );
  }

  List<Widget> _appBarActions(){
    if(_isEntry){
      return <Widget>[
        new IconButton(
          icon: new Icon(Icons.clear),
          onPressed:(){
            setState(() {
              _isEntry = false;
            });
            _textEditingController.clear();
          },
        ),
      ];
    }else{
      return _popMenu();
    }
  }

  List<Widget> _popMenu() {
    if (_hasUrl) {
      return <Widget>[
        _popupMenuButton()
      ];
    } else {
      return <Widget>[];
    }
  }

  PopupMenuButton _popupMenuButton(){
    return PopupMenuButton<int>(
        itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
          new PopupMenuItem<int>(
              value: 1, child: new Text('open url')),
          new PopupMenuItem<int>(
              value: 2, child: new Text('share')),
        ],
        onSelected: (int value) async {
          String url = await controller.currentUrl();
          if (value == 1) {
            await launch(url);
          } else {
            Share.share(url);
          }
        });
  }

  WebView _webView(){
    return WebView(
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
      },
      // navigationDelegate: (NavigationRequest request) {
      //   // TODO: https://github.com/flutter/flutter/issues/39441
      //   debugPrint('allowing navigation to $request');
      //   if (!request.isForMainFrame) return NavigationDecision.navigate;
      //   return NavigationDecision.prevent;
      // },
    );
  }

  void _submission(String v) {
    if(v.length == 0) return;
    _textEditingController.clear();
    setState(() async {
      _hasUrl = true;
      _isEntry = false;
      var url = 'https://mobile.twitter.com/search?q=' + v + '&src=typed_query';
      controller.loadUrl(url);
    });
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await controller.canGoBack()) {
      debugPrint("onWill goback");
      controller.goBack();
    } else {
      debugPrint("moveTaskToBack");
      MoveToBackground.moveTaskToBack();
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
