import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/screens/driver_my_rideshares_screen.dart';

class RideShareCreatedScreen extends StatefulWidget {
  String driverId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RideShareCreatedState(driverId);
  }

  RideShareCreatedScreen(String driverId) {
    this.driverId = driverId;
  }
}


class RideShareCreatedState extends State<RideShareCreatedScreen> {
  String driverId;

  RideShareCreatedState(String driverId) {
    this.driverId = driverId;
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        backgroundColor: appThemeColor,
        title: new Text(
          'Rideshare Created',
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
              createCheckMarkImage(),
              new Container(margin: EdgeInsets.only(bottom: 20)),
              createRideShareCreatedText(),
              new Container(margin: EdgeInsets.only(bottom: 40)),
              createOkButton(),
            ],
          ),
        ),
    );
  }


  Widget createCheckMarkImage() {
    return new Image.asset(
      'assets/images/ride_created_checkmark.png',
      width: 200.0,
      height: 200.0,
    );
  }

  Widget createRideShareCreatedText() {
    return new Text(
      'Ride was created!',
      style: new TextStyle(
        color: Colors.grey,
        fontSize: 40.0,
      ),
    );
  }

  Widget createOkButton() {
    return new SizedBox(
      width: 250.0,
      height: 62.5,
      child: RaisedButton(
        onPressed: () {
          Navigator.push(
            context, 
            new CupertinoPageRoute(
              builder: (context) => new MyRideSharesDriversScreen(driverId)
            ));
        },
        color: appThemeColor,
        child: new Text(
          'OK',
          style: new TextStyle(
            color: Colors.white,
            fontSize: 30.0,
          ),
        ),
      )
    );
  }
}