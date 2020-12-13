import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Fast Twitter Search",
            style: TextStyle(
              fontSize: 32,
              color: Colors.white
            ),
          ),
          SizedBox(height: 20),
          CircularProgressIndicator()
        ],
      ),
      color: Colors.blue,
    );
  }
}