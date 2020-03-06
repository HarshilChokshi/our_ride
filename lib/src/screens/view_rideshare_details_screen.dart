import 'package:flutter/material.dart';
import 'package:our_ride/src/DAOs/UserProfileData.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/widgets/rideshare_users_list.dart';
import '../models/car.dart';
import '../models/user_profile.dart';


class ViewRideshareDetailsScreen extends StatefulWidget {
  String driverId;
  List<String> riderIds;
  Car rideshareVehicle;

  ViewRideshareDetailsScreen(this.driverId, this.riderIds, this.rideshareVehicle);
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ViewRideShareDetailsState(driverId, riderIds, rideshareVehicle);
  }
}

class ViewRideShareDetailsState extends State<ViewRideshareDetailsScreen> {
  String driverId;
  List<String> riderIds;
  Car rideshareVehicle; 
  List<String> allUsers = [];

  ViewRideShareDetailsState(this.driverId, this.riderIds, this.rideshareVehicle);

  @override
  void initState() {
    super.initState();
    allUsers.addAll(riderIds);
    allUsers.add(driverId);
  }
  
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return FutureBuilder<List<UserProfile>>(
      future: UserProfileData.fetchProfileDataForUsers(allUsers),
      builder: (BuildContext context, AsyncSnapshot<List<UserProfile>> snapshot) {
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
            List<UserProfile> rideShareUsers = snapshot.data;
            return new Scaffold(
              backgroundColor: lightGreyColor,
              body: new Container(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(margin: EdgeInsets.only(bottom: 20)),
                    createTitleText('Riders and Drivers'),
                    new Container(margin: EdgeInsets.only(bottom: 20)),
                    new SizedBox(height: 200.0, child: new RideShareUsersList(rideShareUsers)),
                    new Container(margin: EdgeInsets.only(bottom: 40)),
                    createTitleText('Vehicle Details'),
                    new Container(margin: EdgeInsets.only(bottom: 20)),
                    createCarDetails(rideshareVehicle.make, rideshareVehicle.model),
                    new Container(margin: EdgeInsets.only(bottom: 40)),
                    createGroupChatButton(),
                  ],
                ),
              ),
              appBar: new AppBar(
                backgroundColor: appThemeColor,
                title: new Text(
                  'Rideshare Details',
                  style: new TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                  ),
                ),
              ),
            );
        }
      },
    );
  }

  Widget createTitleText(String title) { 
    return new Text(
      title,
      style: new TextStyle(
        color: Colors.black,
        fontSize: 16.0,
      ),
    );
  }


  Widget createCarDetails(String make, String model) {
    return new Container(
      color: Colors.white,
      width: double.infinity,
      child: new Column(
        children: <Widget>[
          createCarDetailsRow('Make', rideshareVehicle.make, true),
          createCarDetailsRow('Model', rideshareVehicle.model, true),
          createCarDetailsRow('Year', rideshareVehicle.year, true),
          createCarDetailsRow('License Plate', rideshareVehicle.licensePlate, false),
        ],
      ),
    );
  }

  Widget createCarDetailsRow(String description, String value, bool showBorder) {
    Color borderColor = showBorder ? Colors.grey : Colors.transparent;
    return new Container(
      padding: new EdgeInsets.only(left: 10, top: 10, bottom: 10),
      decoration: new BoxDecoration(
        border: new Border(
          bottom: new BorderSide(
            color: borderColor,
            width: 0.5,
          ),
        ),
      ),
      child: new Row(
        children: <Widget>[
          new Text(
            description + ':',
            style: new TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
          new Container(padding: new EdgeInsets.only(left: 20)),
          new Text(
            value,
            style: new TextStyle(
              color: Colors.grey,
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }


  Widget createGroupChatButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: new FlatButton(
        color: appThemeColor,
        onPressed: () {},
        child: new Text(
          'Group Chat',
          style: new TextStyle(
            color: Colors.white,
            fontSize: 18.0
          ),
        ),
      ),
    );
  }
}