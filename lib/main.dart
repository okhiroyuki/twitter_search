import 'package:flutter/material.dart';
import 'package:twitter_search/search_bar.dart';

// バナー広告の高さ
double adBannerHeight;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitter Search',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SearchAppBar(),
      builder: (BuildContext context, Widget child) {
        // 画面サイズを取得(幅、高)
        final Size screenSize = MediaQuery.of(context).size;

        // 画面の高さ(dp)によって表示広告(スマートバナー)の高さをセット
        if (screenSize.height > 720) {
          adBannerHeight = 90.0;
        } else if (screenSize.height > 400) {
          adBannerHeight = 50.0;
        } else {
          adBannerHeight = 32.0;
        }

        // 下部にAdMob広告を表示するため、スペースを空ける
        return Padding(
          child: child,
          padding: EdgeInsets.only(
            bottom: adBannerHeight,
          ),
        );
      },
    );
  }
}
