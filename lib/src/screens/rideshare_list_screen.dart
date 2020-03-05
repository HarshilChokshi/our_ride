import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/widgets/app_bottom_navigation_bar.dart';


class RideshareListScreen extends StatefulWidget {
  String rider_id;

  RideshareListScreen(String rider_id) {
    this.rider_id = rider_id;
  }

  @override
  State<StatefulWidget> createState() {
    return new RideshareListState(rider_id);
  }
}

class RideshareListState extends State<RideshareListScreen> {
  String rider_id;

  RideshareListState(String rider_id) {
    this.rider_id = rider_id;
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        backgroundColor: appThemeColor,
        title: new Text(
          'Rideshares',
          style: new TextStyle(
              fontSize: 24.0,
              color: Colors.white,
            ),
          ),
        ),
      body: new Container(
          height: double.infinity,
          width: double.infinity,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            ],
          ),
        ),
      bottomNavigationBar: new AppBottomNavigationBar(rider_id, 0, true),
    );
  }
}