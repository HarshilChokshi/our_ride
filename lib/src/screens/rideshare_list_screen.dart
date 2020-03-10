import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/widgets/app_bottom_navigation_bar.dart';
import 'package:our_ride/src/widgets/rideshare_search_filter.dart';
import 'package:our_ride/src/widgets/main_rideshare_list.dart';
import 'package:our_ride/src/models/car.dart';
import 'package:our_ride/src/models/location_model.dart';
import 'package:our_ride/src/models/rideshare_model.dart';

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

  var dummyData = Rideshare.fromDetails(
    "diver_id",
    DateTime.now(),
    TimeOfDay(hour: 14, minute: 69),
    4,
    3,
    15.0,
    Car.fromCarDetails('model x', 'make x','2011','324kblk1234iu'),
    ['rider 1', 'rider 2', 'rider 3'],
    false,
     'University of Waterloo',
    'Systems Design Engineering',
    'Revanth',
    'Sakthi',
    'profile_string',
    Location.fromDetails("1276 Silver Spear Road, Mississauga, ON", "place_id", 0, 0),
    Location.fromDetails("E5 Building, Waterloo, ON", "place_id", 0, 0)
  );

  RideshareListState(String rider_id) {
    this.rider_id = rider_id;
  }

  GlobalKey<FormState> testFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appThemeColor,
        elevation: 0,
        title: Text(
          'Rideshares',
          style: TextStyle(
              fontSize: 24.0,
              color: Colors.white,
            ),
          ),
        ),
      body: CustomScrollView(
          slivers: <Widget>[
            RideshareSearchFilter(),
            SliverList(
              delegate: SliverChildListDelegate(
                [ 
                  RideshareSearchList(rideShareData: dummyData,),
                ],
              ),
            ),
          ],
        ),
      bottomNavigationBar: AppBottomNavigationBar(rider_id, 0, true),
    );
  }
}

