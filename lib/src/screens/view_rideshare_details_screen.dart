import 'package:flutter/material.dart';
import 'package:our_ride/src/DAOs/RideRequestsCreator.dart';
import 'package:our_ride/src/DAOs/UserProfileData.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/models/rideshare_model.dart';
import 'package:our_ride/src/screens/rider_rideshare_requests_screen.dart';
import 'package:our_ride/src/widgets/rideshare_users_list.dart';
import '../models/car.dart';
import '../models/user_profile.dart';
import 'package:flutter/cupertino.dart';


class ViewRideshareDetailsScreen extends StatefulWidget {
  String driverId;
  List<String> riderIds;
  Car rideshareVehicle;
  int luggageType;
  bool isRiderAlreadyAdded;
  Rideshare targetRideshare;
  String viewerId;

  ViewRideshareDetailsScreen(
    this.driverId,
    this.riderIds,
    this.rideshareVehicle,
    this.luggageType,
    this.isRiderAlreadyAdded,
    this.targetRideshare,
    this.viewerId,
  );
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ViewRideShareDetailsState(driverId, riderIds, rideshareVehicle, luggageType, isRiderAlreadyAdded, targetRideshare, viewerId);
  }
}

class ViewRideShareDetailsState extends State<ViewRideshareDetailsScreen> {
  String driverId;
  List<String> riderIds;
  Car rideshareVehicle; 
  int luggageType;
  bool isRiderAlreadyAdded;
  Rideshare targetRideshare;
  String viewerId;
  List<String> allUsers = [];

  List<String> luggageTypeMessages = [
    '(Each passenger can bring a backpack)',
    '(Each passenger can bring a duffel bag)',
    '(Each passenger can bring a suitcase)',
  ];

  ViewRideShareDetailsState(
    this.driverId,
    this.riderIds,
    this.rideshareVehicle,
    this.luggageType,
    this.isRiderAlreadyAdded,
    this.targetRideshare,
    this.viewerId,
  );

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
            bool notNull(Object o) => o != null;
            return new Scaffold(
              backgroundColor: Colors.white,
              body: new SingleChildScrollView(
                child: new Container(
                  padding: new EdgeInsets.only(left: 10, right: 10),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(margin: EdgeInsets.only(bottom: 20)),
                      createTitleText('Vehicle Details'),
                      new Container(margin: EdgeInsets.only(bottom: 20)),
                      createCarDetails(),
                      new Container(margin: EdgeInsets.only(bottom: 40)),
                      createTitleText('Riders and Drivers'),
                      new Container(margin: EdgeInsets.only(bottom: 20)),
                      new SizedBox(height: 200.0, child: new RideShareUsersList(rideShareUsers, this)),
                      new Container(margin: EdgeInsets.only(bottom: 40)),
                      createGroupChatButton(),
                      createRequestToJoinRideButton(),
                    ].where(notNull).toList(),
                  ),
                )
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
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }


  Widget createCarDetails() {
    return new Container(
      color: Colors.white,
      width: double.infinity,
      child: new Column(
        children: <Widget>[
          createCarDetailsRow('Make', rideshareVehicle.make, true),
          createCarDetailsRow('Model', rideshareVehicle.model, true),
          createCarDetailsRow('Year', rideshareVehicle.year, true),
          createCarDetailsRow('License Plate', rideshareVehicle.licensePlate, true),
          createCarDetailsRow('Luggage Type', luggageType.toString() + ' ' + luggageTypeMessages[luggageType - 1], false),
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
              fontSize: 12.0,
            ),
          ),
          new Container(padding: new EdgeInsets.only(left: 20)),
          new Text(
            value,
            style: new TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }


  Widget createGroupChatButton() {
    if(!isRiderAlreadyAdded) {
      return null;
    }
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

  Widget createRequestToJoinRideButton() {
    if(isRiderAlreadyAdded) {
      return null;
    }
    return Align(
      alignment: Alignment.bottomCenter,
      child: new FlatButton(
        color: appThemeColor,
        onPressed: () {
          requestToJoinRide();
          showRideShareAddedMessage();
        },
        child: new Text(
          'Request to join ride',
          style: new TextStyle(
            color: Colors.white,
            fontSize: 14.0
          ),
        ),
      ),
    );
  }

  void showRideShareAddedMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(61, 191, 165, 100),
          title: new Text('Requested to Join Rideshare'),
          content: new Text('Succesfully requested to join rideshare', style: new TextStyle(fontWeight: FontWeight.bold),),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Okay', style: new TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
                Navigator.pushReplacement(
                  context, 
                  new CupertinoPageRoute(
                    builder: (context) =>  RiderRideshareRequestScreen(viewerId)
                ));
              },
            ),
          ],
        );
      }
    );
  }

  void requestToJoinRide() async {
    RideRequestsCreator.create(targetRideshare, viewerId);
  }
}