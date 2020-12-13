import 'dart:io';

import 'package:flutter/cupertino.dart';

class AdManager {
  // アプリIDを返す関数
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1296166689727642~7689365715"; //AndroidのアプリID
    } else if (Platform.isIOS) {
      return "XXX"; //iOSのアプリID
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  // 広告ユニットIDを返す関数
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1296166689727642/8992846701";  // Androidの広告ユニットID
    } else if (Platform.isIOS) {
      return "XXX";  // iOSの広告ユニットID
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static double getAdBannerHeight(context){
    // 画面サイズを取得(幅、高)
    final Size screenSize = MediaQuery.of(context).size;

    // 画面の高さ(dp)によって表示広告(スマートバナー)の高さをセット
    if (screenSize.height > 720) {
      return 90.0;
    } else if (screenSize.height > 400) {
      return 50.0;
    } else {
      return 32.0;
    }
  }
}