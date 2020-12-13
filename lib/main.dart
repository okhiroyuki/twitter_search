import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:twitter_search/ad_manager.dart';
import 'package:twitter_search/search_bar.dart';
import 'package:twitter_search/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Create the initialization Future outside of `build`:
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return MyWidget(_initialization);
  }

  MaterialApp MyWidget(Future<FirebaseApp> _initialization){
    return MaterialApp(
      title: 'Twitter Search',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            return SearchAppBar();
          } else {
            return SplashScreen();
          }
        },
      ),
      // builder: (BuildContext context, Widget child) {
      //   // 下部にAdMob広告を表示するため、スペースを空ける
      //   return Padding(
      //     child: child,
      //     padding: EdgeInsets.only(
      //       bottom: AdManager.getAdBannerHeight(context),
      //     ),
      //   );
      // },
    );
  }
}


