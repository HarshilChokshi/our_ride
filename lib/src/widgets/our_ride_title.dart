import 'package:flutter/material.dart';
import '../contants.dart';

class OurRideTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text(
          'OUR',
          style: new TextStyle(
            fontSize: 50,
            color: appThemeColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        new Text(
          'ide',
          style: new TextStyle(
            fontSize: 50,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}