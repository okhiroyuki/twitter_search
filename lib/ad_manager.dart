import 'dart:io';

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
}