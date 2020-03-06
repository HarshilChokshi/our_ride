import 'package:flutter/material.dart';
import 'package:our_ride/src/models/user_profile.dart';
import '../DAOs/UserProfileData.dart';

class RideShareUsersList extends StatelessWidget {
  List<UserProfile> users;

  RideShareUsersList(this.users);
  
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
          new Container(margin: EdgeInsets.only(right: 30)),
          createNameText(index),
          new Spacer(),
          createFacebookImage(index),
        ],
      ),
    );
  }

  Widget createUserProfileImage(int index) {
    return new Container(
      margin: EdgeInsets.only(bottom: 10, top: 10),
      width: 60,
      height: 60,
      decoration: new BoxDecoration(
        color: const Color(0xff7c94b6),
        image: new DecorationImage(
          image: new AssetImage('assets/images/default-profile.png'),
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
        fontSize: 18.0,
        color: Colors.grey,
      ),
    );
  }

  Widget createFacebookImage(int index) {
    return new Container(
      margin: EdgeInsets.only(bottom: 10),
      width: 50,
      height: 50,
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