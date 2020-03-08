import 'package:flutter/material.dart';
import 'package:our_ride/src/DAOs/UserProfileData.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/models/ride_request_model.dart';
import 'package:our_ride/src/screens/driver_ride_requests_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverRequestsList extends StatelessWidget {
  List<RideRequest> driverRideRequestsList;
  DriverRideRequestsState driverRideRequestsState;
  final databaseReference = Firestore.instance;

  DriverRequestsList(this.driverRideRequestsList, this.driverRideRequestsState);
  
  @override
  Widget build(BuildContext context) {
   return new ListView.builder(
     itemBuilder: buildCell,
     itemCount: driverRideRequestsList.length,
    );
  }

  Container buildCell(BuildContext context, int index) {
    return new Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0, top: 10.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          createDateText(driverRideRequestsList[index].rideshareDate),
          createRideInfo(index),
        ],
      ),
    );
  }

  Widget createDateText(DateTime date) {
    String dateString = date.toString().split(' ')[0];
    return new Container(
      width: double.infinity,
      color: appThemeColor,
      child: new Text(
        dateString,
        style: new TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

    Widget createRideInfo(int index) {
    return new Container(
      width: double.infinity,
      decoration: new BoxDecoration(
        border: new Border(
          left: BorderSide(width: 1.0, color: Colors.grey),
          right: BorderSide(width: 1.0, color: Colors.grey),
          bottom: BorderSide(width: 1.0, color: Colors.grey),
        ),
      ),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(margin: EdgeInsets.only(top: 10)),
          createPickUpLocationInfo(index),
          new Container(margin: EdgeInsets.only(top: 3)),
          createHallowCircle(),
          new Container(margin: EdgeInsets.only(top: 3)),
          createHallowCircle(),
          new Container(margin: EdgeInsets.only(top: 3)),
          createHallowCircle(),
          new Container(margin: EdgeInsets.only(top: 3)),
          createHallowCircle(),
          new Container(margin: EdgeInsets.only(top: 3)),
          createDropOffLocationInfo(index),
          new Container(margin: EdgeInsets.only(top: 3)),
          createHallowCircle(),
          new Container(margin: EdgeInsets.only(top: 3)),
          createHallowCircle(),
          new Container(margin: EdgeInsets.only(top: 3)),
          createHallowCircle(),
          new Container(margin: EdgeInsets.only(top: 3)),
          createHallowCircle(),
          new Container(margin: EdgeInsets.only(top: 3)),
          createTimeInfo(index),
          new Container(margin: EdgeInsets.only(top: 15)),
          createRiderInfo(index),
          new Container(margin: EdgeInsets.only(top: 5)),
          createActionButtons(index),
        ],
      ),
    );
  }

    Widget createPickUpLocationInfo(int index) {
    return new Row(
      children: <Widget>[
        new Container(margin: EdgeInsets.only(left: 5)),
        createLocationIcon(),
        new Container(margin: EdgeInsets.only(left: 2)),
        createBoldText('Pick Up Location: '),
        createText(driverRideRequestsList[index].pickUpLocation),
      ],
    );
  }

  Widget createDropOffLocationInfo(int index) {
    return new Row(
      children: <Widget>[
        new Container(margin: EdgeInsets.only(left: 5)),
        createLocationIcon(),
        new Container(margin: EdgeInsets.only(left: 2)),
        createBoldText('Drop Off Location: '),
        createText(driverRideRequestsList[index].dropOffLocation),
      ],
    );
  }

  Widget createTimeInfo(int index) {
    return new Row(
      children: <Widget>[
        new Container(margin: EdgeInsets.only(left: 5)),
        createTimeIcon(),
        new Container(margin: EdgeInsets.only(left: 2)),
        createBoldText('Pick Up Time: '),
        createText(driverRideRequestsList[index].rideTime.hour.toString() + ':' + driverRideRequestsList[index].rideTime.minute.toString()),
      ],
    );
  }

  Widget createLocationIcon() {
    return new Icon(Icons.person_pin_circle, size: 15.0);
  }

  Widget createTimeIcon() {
    return new Icon(Icons.time_to_leave, size: 15.0);
  }

  Widget createBoldText(String data) {
    return new Text(
      data,
      style: new TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget createText(String data) {
    return new Flexible(
      child: Text(
        data,
        style: new TextStyle(
          color: Colors.grey,
        ),
      )
    );
  }

  Widget createHallowCircle() {
    return new Container(
      margin: EdgeInsets.only(left: 9),
      width: 5,
      height: 5,
      decoration: new BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget createRiderInfo(int index) {
    return Container(
      padding: EdgeInsets.only(left: 5),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          createRiderProfilePicture(index),
          new Container(padding: EdgeInsets.only(left: 10),),
          createRiderNameText(index),
        ],
      ),
    );
  }

  Widget createRiderProfilePicture(int index) {
    String path = driverRideRequestsList[index].profilePic == 'Exists' ? 'assets/images/' +
      driverRideRequestsList[index].riderFirstName + 
      '_' +
      driverRideRequestsList[index].riderLastName +
      '.png'
      :
      'assets/images/default-profile.png';
    return new Container(
      width: 50,
      height: 50,
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

  Widget createRiderNameText(int index) {
    return new Text(
      driverRideRequestsList[index].riderFirstName +
      ' wants to join your ride',
      style: new TextStyle(
        color: Colors.grey,
        fontSize: 18,
      ),
    );
  }

  Widget createActionButtons(int index) {
    return new Container(
      padding: EdgeInsets.only(left: 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          createViewFacebookProfileButton(index),
          createAcceptButton(index),
          createDenyButton(index),
        ],
      ),
    );
  }

  Widget createViewFacebookProfileButton(int index) {
    return new RaisedButton(
      color: Colors.blue,
      child: new Text(
        'View FB Profile',
        style: new TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      onPressed: () {
        UserProfileData.openFacebookProfile(driverRideRequestsList[index].facebookId);
      },
    );
  }

  Widget createAcceptButton(int index) {
    return new RaisedButton(
      color: appThemeColor,
      child: new Text(
        'Accept',
        style: new TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      onPressed: () {
        addRiderToRideShare(index);
      },
    );
  }

  Widget createDenyButton(int index) {
    return new RaisedButton(
      color: new Color.fromARGB(255, 208, 2, 27),
      child: new Text(
        'Deny',
        style: new TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      onPressed: () {
        removeRequest(index);
      },
    );
  }

  void addRiderToRideShare(int index) async {
    List<String> riders = [];
    await databaseReference
    .collection('rideshares')
    .document(driverRideRequestsList[index].rideshareRef)
    .get()
    .then((doc) {
      int numberOfRiders = (doc['riders'] as List).length;
      for(int i = 0; i < numberOfRiders; i++) {
        riders.add(doc['riders'][i].toString());
      }
      riders.add(driverRideRequestsList[index].riderId);
    });

    await databaseReference
      .collection('rideshares')
      .document(driverRideRequestsList[index].rideshareRef)
      .updateData({
        'riders': riders,
    });

    removeRequest(index);
  }

  void removeRequest(int index) async {
    Map<String, dynamic> map;
   
    await databaseReference
      .collection('rideshare-requests')
      .document(driverRideRequestsList[index].driverId)
      .get()
      .then((doc) {
        map = doc.data;
    });

    List<dynamic> newRidersList = [];
    int length = (map['requests'] as List).length;
    for(int i = 0; i < length; i++) {
      if(map['requests'][i]['riderId'].toString() != driverRideRequestsList[index].riderId) {
        newRidersList.add(map['requests'][i]);
      }
    }

    await databaseReference
      .collection('rideshare-requests')
      .document(driverRideRequestsList[index].driverId)
      .updateData({
        'requests': newRidersList,
      });
    
    driverRideRequestsState.setState(() {
      driverRideRequestsList.removeAt(index);
    });
  }
}