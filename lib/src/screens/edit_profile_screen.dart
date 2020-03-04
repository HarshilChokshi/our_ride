import 'package:flutter/material.dart';
import 'package:our_ride/src/models/user_profile.dart';
import 'package:our_ride/src/contants.dart';
import 'package:flutter/cupertino.dart';
import 'package:our_ride/src/screens/user_profile_screen.dart';
import 'package:firebase_database/firebase_database.dart';

class EditProfileScreen extends StatefulWidget {
  UserProfile userProfile;
  String userId;

  EditProfileScreen(this.userProfile, this.userId);
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditProfileScreenState(userProfile, userId);
  }
}

class EditProfileScreenState extends State<EditProfileScreen> {
  
  UserProfile userProfile;
  String userId;
  final formKey = new GlobalKey<FormState>();
  final databaseReference = FirebaseDatabase.instance.reference();

  String aboutme;
  bool isMale;
  String program;
  String university;
  String city;

  EditProfileScreenState(this.userProfile, this.userId);
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
      )
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
        createSaveProfileButton(),
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

  Widget createSaveProfileButton() {
    return new FlatButton(
      child: new Text(
        'Save',
        style: new TextStyle(color: Colors.white),
      ),
      onPressed: () {  
        if(!formKey.currentState.validate()) {
          return;
        }

        formKey.currentState.save();
        updateUserData();
        
        Navigator.pushReplacement(
          context, 
          new CupertinoPageRoute(
            builder: (context) => UserProfileScreen(userId)
        ));
      },
      color: appThemeColor,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.white)
      ),
    );
  }

  void updateUserData() async {
    databaseReference.reference()
    .child(userId)
    .update(
      {
        "email": userProfile.email,
        "password": userProfile.password,
        "firstName": userProfile.firstName,
        "lastName": userProfile.lastName,
        "isMale": isMale,
        "driverLicenseNumber": userProfile.driverLicenseNumber,
        "city": city,
        "state": userProfile.state,
        "ridesTaken": 0,
        "ridesGiven": 0,
        "aboutMe": aboutme,
        "program": program,
        "university": university,
        "profilePic": "",
        "facebookUserId": userProfile.facebookUserId,
      }
    );
;
  }

  Widget bottomComponent() {
    return new Container(
      padding: new EdgeInsets.only(left: 10.0, right: 10.0),
      child: new Form(
        key: formKey,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            createDesciption('About me'),
            new Padding(padding: EdgeInsets.only(bottom: 3)),
            createTextFields(userProfile.aboutMe, 0),
            new Padding(padding: EdgeInsets.only(bottom: 30)),
            createDesciption('Gender'),
            new Padding(padding: EdgeInsets.only(bottom: 3)),
            createTextFields(userProfile.isMale ? 'Male' : 'Female', 1),
            new Padding(padding: EdgeInsets.only(bottom: 30)),
            createDesciption('Program'),
            new Padding(padding: EdgeInsets.only(bottom: 3)),
            createTextFields(userProfile.program, 2),
            new Padding(padding: EdgeInsets.only(bottom: 30)),
            createDesciption('University'),
            new Padding(padding: EdgeInsets.only(bottom: 3)),
            createTextFields(userProfile.university, 3),
            new Padding(padding: EdgeInsets.only(bottom: 30)),
            createDesciption('City'),
            new Padding(padding: EdgeInsets.only(bottom: 3)),
            createTextFields(userProfile.city, 4),
          ],
        ),
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

  Widget createTextFields(String currentValue, int textFieldNum) {
    return new TextFormField(
      initialValue: currentValue,
      style: new TextStyle(fontSize: 12, color: Colors.grey),
      decoration: new InputDecoration(
        errorStyle: new TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        enabledBorder: new OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 0.5),
        ),
      ),
      validator: (String value) {
        if(value.isEmpty) {
          return 'The value cannot be empty.';
        }

        if(textFieldNum == 1 && (value != 'Male' && value != 'Female')) {
          return 'The value must be one of \'Male\' or \'Female\'';
        }

        return null;
      },
      onSaved: (String value) {
        if(textFieldNum == 0) {
          aboutme = value;
        } else if(textFieldNum == 1) {
          isMale = value == 'Male' ? true : false;
        } else if(textFieldNum == 2) {
          program = value;
        } else if(textFieldNum == 3) {
          university = value;
        } else if(textFieldNum == 4) {
          city = value;
        }
      },
    );
  }
}