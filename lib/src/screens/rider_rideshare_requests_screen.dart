import 'package:flutter/material.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/models/ride_request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:our_ride/src/widgets/app_bottom_navigation_bar.dart';
import 'package:our_ride/src/widgets/rider_request_list.dart';

class RiderRideshareRequestScreen extends StatefulWidget {
  String riderId;

  RiderRideshareRequestScreen(this.riderId);
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RiderRideshareRequestState(riderId);
  }
}

class RiderRideshareRequestState extends State<RiderRideshareRequestScreen> {
  String riderId;
  final databaseReference = Firestore.instance;
  List<RideRequest> rideRequests;

  RiderRideshareRequestState(this.riderId);
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchRideRequestData(),
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
            bottomNavigationBar: new AppBottomNavigationBar(riderId, 3, true),
            body: new RiderRequestsList(rideRequests, this),
          );
        }
      },
    );
  }

  Future<List<RideRequest>> fetchRideRequestData() async {
     List<RideRequest> rideRequestList = [];
     await databaseReference
      .collection('rideshare-requests')
      .getDocuments()
      .then((QuerySnapshot snapShot) {
         snapShot.documents.forEach((f) {
           List<dynamic> ridersRequests = f.data['requests'] as List<dynamic>;
           for(int i = 0; i < ridersRequests.length; i++) {
             var doc = ridersRequests[i];
             if(doc['riderId'].toString() == riderId) {
                String driverId = doc['driverId'];
                String riderId = doc['riderId'];
                String riderFirstName = doc['[riderFirstName'];
                String riderLastName = doc['riderLastName'];
                String facebookId = doc['facebookId'];
                String profilePic = doc['profilePic'];
                String pickUpLocation = doc['pickUpLocation'];
                String dropOffLocation = doc['dropOffLocation'];
                DateTime rideshareDate = DateTime.parse(doc['rideshareDate']);
                List<String> rideShareTime = doc['rideTime'].split(':');
                TimeOfDay rideTime = new TimeOfDay(
                  hour: int.parse(rideShareTime[0]),
                  minute: int.parse(rideShareTime[1])
                );
                String rideshareRef = doc['rideshareRef'];
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
                    rideshareRef,
                )
              );
             }
           }
         });
      });

    return Future.value(rideRequestList);
  }
}