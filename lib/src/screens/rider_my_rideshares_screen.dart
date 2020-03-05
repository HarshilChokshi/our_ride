import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/models/car.dart';
import 'package:our_ride/src/models/rideshare_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:our_ride/src/widgets/app_bottom_navigation_bar.dart';
import 'package:our_ride/src/widgets/rideshares_list.dart';

class MyRideSharesRidersScreen extends StatefulWidget {
  
  String rider_id;
  
  MyRideSharesRidersScreen(String rider_id) {
    this.rider_id = rider_id;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MyRideSharesRidersState(rider_id);
  }
}

class MyRideSharesRidersState extends State<MyRideSharesRidersScreen> {
  
  String rider_id;
  final databaseReference = Firestore.instance;
  List<Rideshare> rideShareDataList = [];
  
  MyRideSharesRidersState(String rider_id) {
    this.rider_id = rider_id;
    fetchRideShares();
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new RideSharesList(rideShareDataList, context, null, this),
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
      ),
      bottomNavigationBar: new AppBottomNavigationBar(rider_id, 1, true),
    );
  }

  void fetchRideShares() async {
    databaseReference
      .collection('rideshares')
      .getDocuments()
      .then((QuerySnapshot snapShot) {
        snapShot.documents.forEach((f) {
          List<dynamic> riders = f.data['riders'] as List;
          for(int i = 0; i < riders.length; i++) {
            String rider = riders[i].toString();
            if(rider == rider_id) {
              Car car = Car.fromCarDetails(
                f.data['model'],
                f.data['make'],
                f.data['year'],
                f.data['licensePlate'],
              );
              List<String> rideShareTime = f.data['rideTime'].split(':');
              List<String> riders = [];

              for(var rider in f.data['riders']) {
                riders.add(rider.toString());
              }

              Rideshare riderRideShare = Rideshare.fromDetails(
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
                rideShareDataList.add(riderRideShare);
              });
              break;
            }
          }
        });
      });
  }
}