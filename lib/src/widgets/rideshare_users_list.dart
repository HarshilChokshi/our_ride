import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/models/user_profile.dart';
import 'package:our_ride/src/screens/view_rideshare_details_screen.dart';
import '../DAOs/UserProfileData.dart';
import '../screens/user_profile_screen.dart';
import 'package:flutter/cupertino.dart';

class RideShareUsersList extends StatelessWidget {
  List<UserProfile> users;
  ViewRideShareDetailsState parent;

  RideShareUsersList(this.users, this.parent);
  
  @override
  Widget build(BuildContext context) {
   return new ListView.builder(
     itemBuilder: buildCell,
     itemCount: users.length,
    );
  }


  Container buildCell(BuildContext context, int index) {
    Color borderColor = index == users.length - 1 ? Colors.transparent : Colors.grey;
    return new Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        border: new Border(
          bottom: new BorderSide(
            color: borderColor,
            width: 0.5,
          ),
        ),
      ),
      child: new Row(
        children: <Widget>[
          new Container(margin: EdgeInsets.only(right: 3)),
          createUserProfileImage(index),
          new Container(margin: EdgeInsets.only(right: 10)),
          createNameText(index),
          new Spacer(),
          createViewProfileButton(index),
          new Container(margin: EdgeInsets.only(right: 10)),
          createFacebookImage(index),
        ],
      ),
    );
  }
  
  
  Widget createUserProfileImage(int index) {
    String path = users[index].profilePic.toString() == 'Exists' ? 'assets/images/' +
      users[index].firstName + 
      '_' +
      users[index].lastName +
      '.png'
      :
      'assets/images/default-profile.png';
    return new Container(
      margin: EdgeInsets.only(bottom: 10, top: 10),
      width: 60,
      height: 60,
      decoration: new BoxDecoration(
        color: const Color(0xff7c94b6),
        image: new DecorationImage(
          image: new AssetImage(path),
          fit: BoxFit.cover,
        ),
        borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
      ),
    ); 
  }

  Widget createNameText(int index) {
    String name = users[index].firstName + ' '  + users[index].lastName[0] + '.';
    name += index == users.length - 1 ? ' (driver)' : '';

    return new Text(
      name,
      style: new TextStyle(
        fontSize: 16.0,
        color: Colors.grey,
      ),
    );
  }

  Widget createViewProfileButton(int index) {
    return new FlatButton(
      color: appThemeColor,
      onPressed: () {
        Navigator.push(
          parent.context, 
          new CupertinoPageRoute(
            builder: (context) => UserProfileScreen(null, index != users.length - 1, users[index], false)
        ));
      },
      child: new Text(
        'View Profile',
        style: new TextStyle(
          fontSize: 14.0,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget createFacebookImage(int index) {
    return new Container(
      margin: EdgeInsets.only(bottom: 10),
      width: 55,
      height: 55,
      decoration: new BoxDecoration(
        color: const Color(0xff7c94b6),
        image: new DecorationImage(
          image: new AssetImage('assets/images/facebook_icon.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
      ),
      child: new FlatButton(
        color: Colors.transparent,
        onPressed: () {
          UserProfileData.openFacebookProfile(users[index].facebookUserId);
        },
        child: null),
    );
  }
}