import 'package:flutter/material.dart';
import 'package:our_ride/src/app.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/models/user_profile.dart';
import 'package:our_ride/src/screens/driver_reviews_screen.dart';
import 'package:our_ride/src/screens/edit_profile_screen.dart';
import 'package:our_ride/src/screens/login_screen.dart';
import 'package:our_ride/src/widgets/app_bottom_navigation_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import '../DAOs/UserProfileData.dart';

class UserProfileScreen extends StatefulWidget {
  
  String user_id;
  bool isRider;
  UserProfile userProfile;
  bool isUsersProfile;
  
  UserProfileScreen(String user_id, bool isRider, UserProfile userProfile, bool isUsersProfile) {
    this.user_id = user_id;
    this.isRider = isRider;
    this.userProfile = userProfile;
    this.isUsersProfile = isUsersProfile;
  }

  @override
  State<StatefulWidget> createState() {
    return new UserProfileState(user_id, isRider, userProfile, isUsersProfile);
  }
}

class UserProfileState extends State<UserProfileScreen> {
  
  String user_id;
  bool isRider;
  UserProfile userProfile;
  bool isUsersProfile;

   final databaseReference = FirebaseDatabase.instance.reference();

  
  UserProfileState(String user_id, isRider, UserProfile userProfile, bool isUsersProfile) {
    this.user_id = user_id;
    this.isRider = isRider;
    this.userProfile = userProfile;
    this.isUsersProfile = isUsersProfile;
  }
  
  @override
  Widget build(BuildContext context) {
    if(userProfile != null) {
      return buildUserProfileScreen(context);
    }
    return FutureBuilder<UserProfile>(
      future: UserProfileData.fetchUserProfileData(user_id),
      builder: (BuildContext context, AsyncSnapshot<UserProfile> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return new Scaffold(
            backgroundColor: Colors.white,
            body: new Center(
              child: Container(
                child: new Text('Loading user data...', style: (
                  new TextStyle(color: Colors.grey, fontSize: 20.0)
                ),),
              ),
            ) 
          );
        } else {
            userProfile = snapshot.data;
            return buildUserProfileScreen(context);
        }
      },
    );
  }

  Widget buildUserProfileScreen(BuildContext context) {
    Widget topBar = isUsersProfile ? null : new AppBar(
      backgroundColor: appThemeColor,
      title: new Text(
        userProfile.firstName + '\'s Profile',
        style: new TextStyle(color: Colors.white, fontSize: 24),
        ),
      );
    Widget bottomBar = isUsersProfile ? new AppBottomNavigationBar(user_id, 2, isRider) : null;
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: new SingleChildScrollView(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            topComponent(),
            new Container(margin: EdgeInsets.only(bottom: 10)),
            bottomComponent(),
          ],
        ),
      ),
      appBar: topBar,
      bottomNavigationBar: bottomBar,
    );
  }

  int calculatePoints(bool isDriver, int ridesGiven, int ridesTaken) {
    if(isDriver)
      return ridesGiven * 10;
    else
      return ridesTaken * 10;
  }

  Widget topComponent() {
    return new Container(
      padding: new EdgeInsets.only(left: 10.0, right: 10.0),
      color: appThemeColor,
      height: 250.0,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new Row(
          children: <Widget>[
            createUserProfile(),
            new Container(margin: EdgeInsets.only(right: 30)),
            createUserRideData(),
          ],
        ),
        createSignOutButton(),
      ],
     ),
    );
  }

  Widget bottomComponent() {
    bool notNull(Object o) => o != null;
    return new Container(
      padding: new EdgeInsets.only(left: 10.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          createDesciption('About me', true),
          new Padding(padding: EdgeInsets.only(bottom: 3)),
          createText(userProfile.aboutMe, true),
          new Padding(padding: EdgeInsets.only(bottom: 20)),
          createDesciption('Gender', true),
          new Padding(padding: EdgeInsets.only(bottom: 3)),
          createText(userProfile.isMale ? 'Male' : 'Female', true),
          new Padding(padding: EdgeInsets.only(bottom: 20)),
          createDesciption('Program', true),
          new Padding(padding: EdgeInsets.only(bottom: 3)),
          createText(userProfile.program, true),
          new Padding(padding: EdgeInsets.only(bottom: 20)),
          createDesciption('University', true),
          new Padding(padding: EdgeInsets.only(bottom: 3)),
          createText(userProfile.university, true),
          new Padding(padding: EdgeInsets.only(bottom: 20)),
          createDesciption('City', true),
          new Padding(padding: EdgeInsets.only(bottom: 3)),
          createText(userProfile.city, true),
          new Padding(padding: EdgeInsets.only(bottom: 20)),
          createDesciption('Card Holder Name', isUsersProfile),
          createBottomPadding(3, isUsersProfile),
          createText(userProfile.paymentMethod.cardHolderName, isUsersProfile),
          createBottomPadding(20, isUsersProfile),
          createDesciption('Card Number', isUsersProfile),
          createBottomPadding(3, isUsersProfile),
          createText(userProfile.paymentMethod.cardNumber, isUsersProfile),
          createBottomPadding(20, isUsersProfile),
          createDesciption('Expire Date: mm/yy', isUsersProfile),
          createBottomPadding(3, isUsersProfile),
          createText(userProfile.paymentMethod.expireDate, isUsersProfile),
          createBottomPadding(20, isUsersProfile),
          createDesciption('CVV', isUsersProfile),
          createBottomPadding(3, isUsersProfile),
          createText(userProfile.paymentMethod.cvv, isUsersProfile),
          createBottomPadding(20, isUsersProfile),
          createDesciption('Driver\'s License', !isRider && isUsersProfile),
          createBottomPadding(3, !isRider && isUsersProfile),
          createText(userProfile.driverLicenseNumber, !isRider && isUsersProfile),
          createReviewsButton(),
        ].where(notNull).toList(),
      ),
    );
  }

  Widget createSignOutButton() {
    return new FlatButton(
      child: new Text(
        'Sign out',
        style: new TextStyle(color: Colors.white),
      ),
      onPressed: () {  
        Navigator.pushReplacement(
          context, 
          new CupertinoPageRoute(
            builder: (context) => LoginScreen()
        ));
      },
      color: appThemeColor,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.white)
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
    String path = userProfile.profilePic.toString() == 'Exists' ? 'assets/images/' +
      userProfile.firstName + 
      '_' +
      userProfile.lastName +
      '.png'
      :
      'assets/images/default-profile.png';
    


    return new Container(
      width: 100.0,
      height: 100.0,
      decoration: new BoxDecoration(
        color: const Color(0xff7c94b6),
        image: new DecorationImage(
          image: new AssetImage(path),
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
        firstName + ' ' + lastName[0] + '.',
        style: new TextStyle(color: Colors.white),
        maxLines: 1,
    );
  }

  Widget createLocationText(String city, String state) {
    return new Text(
      city + ', ' + state,
      style: new TextStyle(color: Colors.white, fontSize: 10),
    );
  }


  Widget createUserRideData() {
    bool notNull(Object o) => o != null;
    return new Column(
      children: <Widget>[
        new Container(margin: EdgeInsets.only(top: 40)),
        createPointsText(userProfile.points),
        new Container(margin: EdgeInsets.only(top: 20)),
        createRidesGivenText(userProfile.ridesGiven),
        new Container(margin: EdgeInsets.only(top: 10)),
        createRidesTakenText(userProfile.ridesTaken),
        new Container(margin: EdgeInsets.only(bottom: 10)),
        new Row(
          children: <Widget>[
            createEditProfileButton(),
            new Container(margin: EdgeInsets.only(left: 5)),
            createViewFacebookProfileButton(),
          ].where(notNull).toList(),
        ),
        
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
    if(!isUsersProfile) {
      return null;
    }

    return new FlatButton(
      child: new Text(
        'Edit Profile',
        style: new TextStyle(color: Colors.white),
      ),
      onPressed: () {  
        Navigator.pushReplacement(
          context, 
          new CupertinoPageRoute(
            builder: (context) => EditProfileScreen(userProfile, user_id, isRider)
        ));
      },
      color: appThemeColor,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.white)
      ),
    );
  }

  Widget createViewFacebookProfileButton() {
    return new FlatButton(
      child: new Text(
        'View FB Profile',
        style: new TextStyle(color: Colors.white),
      ),
      onPressed: () { 
          UserProfileData.openFacebookProfile(userProfile.facebookUserId);
      },
      color: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.blue)
      ),
    );     
  }

  Widget createDesciption(String text, bool show) {
    if(!show)
      return null;

    return new Text(
      text,
      style: new TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.0
      ),
    );
  }

  Widget createBottomPadding(double value, bool show) {
    if(!show)
      return null;

    return new Padding(padding: EdgeInsets.only(bottom: value));
  }

  Widget createText(String text, bool show) {
    if(!show) {
      return null;
    }

    return new Text(
      text,
      style: new TextStyle(
        fontSize: 14.0
      ),
    );
  }

  Widget createReviewsButton() {
    if(isRider) {
      return null;
    }
    return new Center(
      child: FlatButton(
        child: new Text(
          'See Reviews',
          style: new TextStyle(color: Colors.blue),
        ),
        onPressed: () {
          Navigator.push(
            context, 
            CupertinoPageRoute(
              builder: (context) => DriverReviewsScreen(userProfile.reviews, userProfile.firstName)
          ));
        },
        color: Colors.transparent,
      )
    );
  }
}