import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/screens/driver_my_rideshares_screen.dart';
import 'package:our_ride/src/screens/user_profile_screen.dart';

class AppBottomNavigationBar extends StatelessWidget {
  int page;
  String driver_id;
  bool isRider;
  
  AppBottomNavigationBar(String driver_id, int page, bool isRider) {
    this.page = page;
    this.driver_id = driver_id;
    this.isRider = isRider;
  }
  
  @override
  Widget build(BuildContext context) {
    bool notNull(Object o) => o != null;
    // TODO: implement build
    return new BottomAppBar(
      color: lightGreyColor,
      child: new Container(
        width: double.infinity,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[           
            createListButton(),
            new IconButton(
              icon: Icon(Icons.directions_car),
              onPressed: () {
                Navigator.pushReplacement(
                  context, 
                  new CupertinoPageRoute(
                    builder: (context) => MyRideSharesDriversScreen(driver_id)
                ));
              },
              iconSize: 30.0,
              color: page == 1 ? Colors.blue : Colors.black,
            ),
            new IconButton(
              icon: Icon(Icons.face),
              onPressed: () {
                Navigator.pushReplacement(
                  context, 
                  new CupertinoPageRoute(
                    builder: (context) => UserProfileScreen(driver_id)
                ));
              },
              iconSize: 30.0,
              color: page == 2 ? Colors.blue : Colors.black,
            ), 
          ].where(notNull).toList(),
        ),
      ),
    );
  }

  Widget createListButton() {
    if(isRider) {
      return new IconButton(
        icon: Icon(Icons.list),
        onPressed: () {},
        iconSize: 30.0,
        color: page == 0 ? Colors.blue : Colors.black,
      );
    }
    return null;
  }
}