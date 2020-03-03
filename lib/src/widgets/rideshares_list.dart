import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/models/rideshare_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:our_ride/src/screens/driver_my_rideshares_screen.dart';

class RideSharesList extends StatelessWidget {
  
  final List<Rideshare> rideShareDataList;
  BuildContext context;
  final databaseReference = Firestore.instance;
  MyRideSharesDriversState parent;

  RideSharesList(this.rideShareDataList, this.context, this.parent);
   
  @override
  Widget build(BuildContext context) {
   return new ListView.builder(
     
     itemBuilder: buildCell,
     itemCount: rideShareDataList.length,
    );
  }

  Slidable buildCell(BuildContext context, int index) {
    return new Slidable(
      child: new Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(margin: EdgeInsets.only(top: 10)),
              createDateText(rideShareDataList[index].rideDate),
              createRideInfo(index),
            ],
        ),
      ),
      actionPane: new SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'Cancel',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            showLoginErrorMessage(index);
          },
        ),
      ],
    );
  }

  void deleteRideShareRecord(int index)  async {
   Rideshare r = rideShareDataList[index];
   databaseReference
      .collection('rideshares')
      .document(r.driverId + '-' + r.rideDate.toString() + '-' + r.rideTime.hour.toString() + ':' + r.rideTime.minute.toString())
      .delete();
    this.parent.setState(() {
      rideShareDataList.removeAt(index);
    });
  }

  void showLoginErrorMessage(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Cancel Ride'),
          content: new Text('Are you sure you want to cancel the ride? You will be charged'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Close', style: new TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('Cancel rideshare', style: new TextStyle(color: Colors.red)),
              onPressed: () {
                deleteRideShareRecord(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
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
          createOptions(index),
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
        createText(rideShareDataList[index].pickUpLocation),
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
        createText(rideShareDataList[index].dropOffLocation),
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
        createText(rideShareDataList[index].rideTime.hour.toString() + ':' + rideShareDataList[index].rideTime.minute.toString()),
      ],
    );
  }

  Widget createOptions(int index) {
    return new Row(
      children: <Widget>[
        new Container(margin: EdgeInsets.only(left: 5)),
        createViewPassengersButton(),
        new Container(margin: EdgeInsets.only(left: 30)),
        createPassengersIcon(),
        new Container(margin: EdgeInsets.only(left: 3)),
        createSeatsLeftText(rideShareDataList[index].capacity - rideShareDataList[index].riders.length),
        new Container(margin: EdgeInsets.only(left: 30)),
        createPriceText(rideShareDataList[index].price),
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

  Widget createViewPassengersButton() {
    return new FlatButton(
      color: appThemeColor,
      child: new Text(
        'View Passengers',
        style: new TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
      onPressed: () {

      }
    );
  }

  Widget createPassengersIcon() {
    return new Icon(Icons.airline_seat_recline_normal, size: 25.0);
  }

  Widget createSeatsLeftText(int seats) {
    return new Text(
      seats.toString() + ' seats left',
      style: new TextStyle(
        color: Colors.grey
      ),
    );
  }

  Widget createPriceText(double price) {
    return new Text(
      '\$' + price.toString(),
      style: new TextStyle(
        color: Colors.grey,
        fontSize: 30.0,
      ),
    );
  }
}