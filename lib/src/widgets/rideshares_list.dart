import 'package:flutter/material.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/models/rideshare_model.dart';

class RideSharesList extends StatelessWidget {
  
  final List<Rideshare> rideShareDataList;

  RideSharesList(this.rideShareDataList);
   
  @override
  Widget build(BuildContext context) {
   return new ListView.builder(
     
     itemBuilder: buildCell,
     itemCount: rideShareDataList.length,
    );
  }

  Container buildCell(BuildContext context, int index) {
    return new Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0),
      child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             new Container(margin: EdgeInsets.only(top: 10)),
            createDateText(rideShareDataList[index].rideDate),
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