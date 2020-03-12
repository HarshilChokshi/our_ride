import 'package:flutter/material.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/models/ride_request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:our_ride/src/screens/rider_rideshare_requests_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class RiderRequestsList extends StatelessWidget {
  List<RideRequest> riderRideRequestsList;
  RiderRideshareRequestState riderRideRequestsState;
  final databaseReference = Firestore.instance;

  RiderRequestsList(this.riderRideRequestsList, this.riderRideRequestsState);
  
  @override
  Widget build(BuildContext context) {
   return new ListView.builder(
     itemBuilder: buildCell,
     itemCount: riderRideRequestsList.length,
    );
  }

  Container buildCell(BuildContext context, int index) {
    return new Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0, top: 10.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          createDateText(riderRideRequestsList[index].rideshareDate),
          createRideInfo(index),
        ],
      ),
    );
  }

  Widget createDateText(DateTime date) {
    String dateString = date.toString().split(' ')[0];
    return new Container(
      padding: EdgeInsets.fromLTRB(10, 2, 0, 2),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(2)),
        color: appThemeColor
      ),
      width: double.infinity,
      height: 20,
      // color: appThemeColor,
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
        createText(riderRideRequestsList[index].pickUpLocation),
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
        createText(riderRideRequestsList[index].dropOffLocation),
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
        createText(riderRideRequestsList[index].rideTime.hour.toString() + ':' + riderRideRequestsList[index].rideTime.minute.toString()),
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
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Text(
        data,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
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

  Widget createActionButtons(int index) {
    return new Container(
      padding: EdgeInsets.only(left: 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          createCancelButton(index),
          createPrice(index),
        ],
      ),
    );
  }


  Widget createCancelButton(int index) {
    return new RaisedButton(
      color: new Color.fromARGB(255, 208, 2, 27),
      child: new Text(
        'Cancel Ride Request',
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

  void removeRequest(int index) async {
    Map<String, dynamic> map;
   
    await databaseReference
      .collection('rideshare-requests')
      .document(riderRideRequestsList[index].driverId)
      .get()
      .then((doc) {
        map = doc.data;
    });

    List<dynamic> newRidersList = [];
    int length = (map['requests'] as List).length;
    for(int i = 0; i < length; i++) {
      if(map['requests'][i]['riderId'].toString() != riderRideRequestsList[index].riderId) {
        newRidersList.add(map['requests'][i]);
      }
    }

    await databaseReference
      .collection('rideshare-requests')
      .document(riderRideRequestsList[index].driverId)
      .updateData({
        'requests': newRidersList,
      });
    
    riderRideRequestsState.setState(() {
      riderRideRequestsList.removeAt(index);
    });
  }
  
    final formatCurrency = new NumberFormat.simpleCurrency();
    Widget createPrice(int index) {
    return new Text(
      formatCurrency.format(riderRideRequestsList[index].ridesharePrice).toString(),
      style: new TextStyle(
        color: Colors.grey,
        fontSize: 30.0,
      ),
    );
  }
}