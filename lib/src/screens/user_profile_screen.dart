import 'package:flutter/material.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/models/user_profile.dart';
import 'package:our_ride/src/widgets/app_bottom_navigation_bar.dart';
import 'package:firebase_database/firebase_database.dart';

class UserProfileScreen extends StatefulWidget {
  
  String user_id;
  
  UserProfileScreen(String user_id) {
    this.user_id = user_id;
  }

  @override
  State<StatefulWidget> createState() {
    return new UserProfileState(user_id);
  }
}

class UserProfileState extends State<UserProfileScreen> {
  
  String user_id;
  final databaseReference = FirebaseDatabase.instance.reference();
  UserProfile userProfile;
  
  @override
  void initState() {
    super.initState();
    var data = fetchUserProfileData();
  }
  
  UserProfileState(String user_id) {
    this.user_id = user_id;
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile>(
      future: fetchUserProfileData(),
      builder: (BuildContext context, AsyncSnapshot<UserProfile> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return new Scaffold(
            backgroundColor: Colors.white,
            body: new Text('Loading User data...'),
          );
        } else {
            userProfile = snapshot.data;
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
              bottomNavigationBar: new AppBottomNavigationBar(user_id, 2, false),
            );
        }
      },
    );
  }

  Future<UserProfile> fetchUserProfileData() async {
      var data;
      await databaseReference.child(user_id).once().then((DataSnapshot snapshot) {
        data = snapshot.value;
      });
      String email = data['email'].toString();
      String password = data['password'].toString();
      String firstName = data['firstName'].toString();
      String lastName = data['lastName'].toString();
      bool isMale = data['isMale'];
      String driverLicenseNumber = data['driverLicenseNumber'].toString();
      int ridesGiven = data['ridesGiven'];
      int ridesTaken = data['ridesTaken'];
      String aboutMe = data['aboutMe'].toString();
      String program = data['program'].toString();
      return Future.value(new UserProfile.fromDetails(
        email,
        password,
        firstName,
        lastName,
        isMale,
        driverLicenseNumber,
        calculatePoints(driverLicenseNumber != null, ridesGiven, ridesTaken),
        ridesGiven,
        ridesTaken,
        aboutMe,
        program,
        null,
      ));      
  }

  int calculatePoints(bool isDriver, int ridesGiven, int ridesTaken) {
    if(isDriver)
      return ridesGiven * 10;
    else
      return ridesTaken * 10;
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
          createText(userProfile.aboutMe),
          new Padding(padding: EdgeInsets.only(bottom: 30)),
          createDesciption('Gender'),
          new Padding(padding: EdgeInsets.only(bottom: 3)),
          createText(userProfile.isMale ? 'Male' : 'Female'),
          new Padding(padding: EdgeInsets.only(bottom: 30)),
          createDesciption('Program'),
          new Padding(padding: EdgeInsets.only(bottom: 3)),
          createText(userProfile.program),
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
        createNameText(userProfile.firstName, userProfile.lastName),
        new Container(margin: EdgeInsets.only(bottom: 3)),
        createLocationText(userProfile.city, userProfile.state),
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

  Widget createNameText(String firstName, String lastName) {
    return new Text(
      firstName + ' ' + lastName,
      style: new TextStyle(color: Colors.white),
    );
  }

  Widget createLocationText(String city, String state) {
    return new Text(
      city + ', ' + state,
      style: new TextStyle(color: Colors.white, fontSize: 10),
    );
  }


  Widget createUserRideData() {
    return new Column(
      children: <Widget>[
        new Container(margin: EdgeInsets.only(top: 40)),
        createPointsText(userProfile.points),
        new Container(margin: EdgeInsets.only(top: 20)),
        createRidesGivenText(userProfile.ridesGiven),
        new Container(margin: EdgeInsets.only(top: 10)),
        createRidesTakenText(userProfile.ridesTaken),
        new Container(margin: EdgeInsets.only(bottom: 10)),
        createEditProfileButton(),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  Widget createPointsText(int points) {
    return new Text(
      points.toString() + ' Points',
      style: new TextStyle(
        color: Colors.white,
        fontSize: 25,
      ),
    );
  }

  Widget createRidesGivenText(int ridesGiven) {
    return new Row(
      children: <Widget>[
        new Text(
          ridesGiven.toString(),
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

  Widget createRidesTakenText(int ridesGiven) { 
      return new Row(
        children: <Widget>[
          new Text(
            ridesGiven.toString(),
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