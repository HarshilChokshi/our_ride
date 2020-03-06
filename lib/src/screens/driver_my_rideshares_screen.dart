import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/models/car.dart';
import 'package:our_ride/src/models/rideshare_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:our_ride/src/screens/create_ride_screen.dart';
import 'package:our_ride/src/widgets/app_bottom_navigation_bar.dart';
import 'package:our_ride/src/widgets/rideshares_list.dart';

class MyRideSharesDriversScreen extends StatefulWidget {
  
  String driver_id;
  
  MyRideSharesDriversScreen(String driver_id) {
    this.driver_id = driver_id;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MyRideSharesDriversState(driver_id);
  }
}

class MyRideSharesDriversState extends State<MyRideSharesDriversScreen> {
  
  String driver_id;
  final databaseReference = Firestore.instance;
  List<Rideshare> rideShareDataList = [];
  
  MyRideSharesDriversState(String driver_id) {
    this.driver_id = driver_id;
    fetchRideShares();
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new RideSharesList(rideShareDataList, context, this, null),
      appBar: new AppBar(
        leading: new Container(),
        backgroundColor: appThemeColor,
        title: new Text(
          'My Rideshares',
          style: new TextStyle(
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: addRideShare,
            child: new Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
      ),
      bottomNavigationBar: new AppBottomNavigationBar(driver_id, 1, false),
    );
  }

  void addRideShare() {
    Navigator.push(
      context, 
      new CupertinoPageRoute(
        builder: (context) => CreateRideScreen(driver_id)
      ));
  }

  void fetchRideShares() async {
    databaseReference
      .collection('rideshares')
      .getDocuments()
      .then((QuerySnapshot snapShot) {
        snapShot.documents.forEach((f) {
          if(f.data['driverId'] == driver_id) {
            Car car = Car.fromCarDetails(
              f.data['car']['model'],
              f.data['car']['make'],
              f.data['car']['year'],
              f.data['car']['licensePlate'],
            );
            List<String> rideShareTime = f.data['rideTime'].split(':');
            List<String> riders = [];

            for(var rider in f.data['riders']) {
              riders.add(rider.toString());
            }

            Rideshare driverRideShare = Rideshare.fromDetails(
              f.data['driverId'],
              f.data['pickUpLocation'],
              f.data['dropOffLocation'],
              DateTime.parse(f.data['rideDate']),
              new TimeOfDay(hour: int.parse(rideShareTime[0]), minute: int.parse(rideShareTime[1])),
              f.data['capacity'],
              f.data['numberOfCurrentRiders'],
              f.data['price'],
              car,
              riders,
            );
            
            setState(() {
              rideShareDataList.add(driverRideShare);
            });
          }
        });
      });
  }
}