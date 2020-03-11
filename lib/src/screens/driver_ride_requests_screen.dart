import 'package:flutter/material.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/models/ride_request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:our_ride/src/widgets/app_bottom_navigation_bar.dart';
import 'package:our_ride/src/widgets/driver_requests_list.dart';

class DriverRideRequestsScreen extends StatefulWidget {
  String driverId;


  DriverRideRequestsScreen(this.driverId);
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new DriverRideRequestsState(driverId);
  }
}

class DriverRideRequestsState extends State<DriverRideRequestsScreen> {
  String driverId;
  final databaseReference = Firestore.instance;
  List<RideRequest> rideRequests;

  DriverRideRequestsState(this.driverId);
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchRideRequests(),
      builder: (BuildContext context, AsyncSnapshot<List<RideRequest>> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return new Scaffold(
            backgroundColor: Colors.white,
            body: new Center(
              child: Container(
                child: new Text('Loading ride requests...', style: (
                  new TextStyle(color: Colors.grey, fontSize: 20.0)
                ),),
              ),
            ) 
          );
        } else {
          rideRequests = snapshot.data == null ? [] : snapshot.data;
          return new Scaffold(
            appBar: new AppBar(
              leading: new Container(),
              backgroundColor: appThemeColor,
              title: new Text(
                'My Ride Requests',
                style: new TextStyle(
                  fontSize: 24.0, 
                  color: Colors.white,
                ),
              ),
            ),
            bottomNavigationBar: new AppBottomNavigationBar(driverId, 3, false),
            body: new Container(
              child: new DriverRequestsList(rideRequests, this),
            ),
          );
        }
      },
    );
  }

  Future<List<RideRequest>> fetchRideRequests() async {
    List<RideRequest> rideRequestList = [];
    await databaseReference
    .collection('rideshare-requests')
    .document(driverId)
    .get()
    .then((doc){
      if(!doc.exists) {
        return Future.value(rideRequestList);
      }

      int numberOfRequests = (doc['requests'] as List).length;
      for(int i = 0; i < numberOfRequests; i++) {
        String driverId = doc['requests'][i]['driverId'];
        String riderId = doc['requests'][i]['riderId'];
        String riderFirstName = doc['requests'][i]['riderFirstName'];
        String riderLastName = doc['requests'][i]['riderLastName'];
        String facebookId = doc['requests'][i]['facebookId'];
        String profilePic = doc['requests'][i]['profilePic'];
        String pickUpLocation = doc['requests'][i]['pickUpLocation'];
        String dropOffLocation = doc['requests'][i]['dropOffLocation'];
        DateTime rideshareDate = DateTime.parse(doc['requests'][i]['rideshareDate']);
        List<String> rideShareTime = doc['requests'][i]['rideTime'].split(':');
        TimeOfDay rideTime = new TimeOfDay(
          hour: int.parse(rideShareTime[0]),
          minute: int.parse(rideShareTime[1])
        );
        String rideshareRef = doc['requests'][i]['rideshareRef'];
        double ridesharePrice = doc['requests'][i]['ridesharePrice'];

        rideRequestList.add(
          new RideRequest(
            driverId,
            riderId,
            riderFirstName,
            riderLastName,
            facebookId,
            profilePic,
            pickUpLocation,
            dropOffLocation,
            rideshareDate,
            rideTime,
            ridesharePrice,
            rideshareRef,
          )
        );
      }
    });
    return Future.value(rideRequestList);
  }
}