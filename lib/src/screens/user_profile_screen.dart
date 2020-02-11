import 'package:flutter/material.dart';
import 'package:our_ride/src/contants.dart';
import '../models/user_profile.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new UserProfileState();
  }
}

class UserProfileState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
       resizeToAvoidBottomPadding: false,
       body: new Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           topComponent(),
           new Container(margin: EdgeInsets.only(bottom: 10)),
           bottomComponent(),
         ],
       ),
    );
    
  }

  Widget topComponent() {
    return new Container(
      padding: new EdgeInsets.only(left: 10.0),
      color: appThemeColor,
      height: 200.0,
      child: new Row(
        children: <Widget>[
          createUserProfile(),
          new Container(margin: EdgeInsets.only(right: 60)),
          createUserRideData(),
        ],
      ),
    );
  }

  Widget bottomComponent() {
    return new Container(
      padding: new EdgeInsets.only(left: 10.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          createDesciption('About me'),
          new Padding(padding: EdgeInsets.only(bottom: 3)),
          createText('Sample text for about me'),
          new Padding(padding: EdgeInsets.only(bottom: 30)),
          createDesciption('Gender'),
          new Padding(padding: EdgeInsets.only(bottom: 3)),
          createText('Male'),
          new Padding(padding: EdgeInsets.only(bottom: 30)),
          createDesciption('Program'),
          new Padding(padding: EdgeInsets.only(bottom: 3)),
          createText('Systems Design Engineering, Class of 2020'),
          new Padding(padding: EdgeInsets.only(bottom: 30)),
          createDesciption('Add reviews here...'),
        ],
      ),
    );
  }

  Widget createUserProfile() {
    return new Column( 
      children: <Widget>[
        new Container(margin: EdgeInsets.only(top: 40)),
        createUserProfileImage(),
        new Container(margin: EdgeInsets.only(bottom: 10)),
        createNameText(),
        new Container(margin: EdgeInsets.only(bottom: 3)),
        createLocationText(),
      ],
    );
  }

  Widget createUserProfileImage() {
    return new Container(
      width: 100.0,
      height: 100.0,
      decoration: new BoxDecoration(
        color: const Color(0xff7c94b6),
        image: new DecorationImage(
          image: new AssetImage('assets/images/default-profile.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
        border: new Border.all(
          color: Colors.white,
          width: 2.0,
        ),
      ),
    );
  }

  Widget createNameText() {
    return new Text(
      'Harshil Chokshi',
      style: new TextStyle(color: Colors.white),
    );
  }

  Widget createLocationText() {
    return new Text(
      'Waterloo' + ', ' + 'Ontario',
      style: new TextStyle(color: Colors.white, fontSize: 10),
    );
  }


  Widget createUserRideData() {
    return new Column(
      children: <Widget>[
        new Container(margin: EdgeInsets.only(top: 40)),
        createPointsText(),
        new Container(margin: EdgeInsets.only(top: 20)),
        createRidesGivenText(),
        new Container(margin: EdgeInsets.only(top: 10)),
        createRidesTakenText(),
        new Container(margin: EdgeInsets.only(bottom: 10)),
        createEditProfileButton(),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  Widget createPointsText() {
    return new Text(
      '2000' + ' Points',
      style: new TextStyle(
        color: Colors.white,
        fontSize: 25,
      ),
    );
  }

  Widget createRidesGivenText() {
    return new Row(
      children: <Widget>[
        new Text(
          '0',
          style: new TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          textAlign: TextAlign.left,
        ),
        new Container(margin: EdgeInsets.only(right: 30)),
        new Text(
          'rides given',
          style: new TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
    
  }

  Widget createRidesTakenText() { 
      return new Row(
        children: <Widget>[
          new Text(
            '0',
            style: new TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            textAlign: TextAlign.left,
          ),
          new Container(margin: EdgeInsets.only(right: 30)),
          new Text(
            'rides taken',
            style: new TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      );
    }

    Widget createEditProfileButton() {
      return new FlatButton(
        child: new Text(
          'Edit Profile',
          style: new TextStyle(color: Colors.white),
        ),
        onPressed: () {  
        },
        color: appThemeColor,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.white)
        ),
      );
    }

    Widget createDesciption(String text) {
      return new Text(
        text,
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0
        ),
      );
    }

    Widget createText(String text) {
      return new Text(
        text,
        style: new TextStyle(
          fontSize: 14.0
        ),
      );
    }
}