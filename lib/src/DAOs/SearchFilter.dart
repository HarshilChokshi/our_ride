import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:our_ride/src/DAOs/UserProfileData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:our_ride/src/models/rideshare_model.dart';
import 'package:our_ride/src/models/location_model.dart';
import '../models/user_profile.dart';
import 'package:our_ride/src/models/car.dart';
import 'package:latlong/latlong.dart';
import 'package:tuple/tuple.dart';
import 'dart:core';

class RideShareSearch{
  static Firestore dbRef = Firestore.instance;

  //THIS IS GOING TO BE SUPER SLOW
  static Future<List<Rideshare>> filterUsers(String riderId, Map searchOptions) async{
    List<Tuple2<double, Rideshare>> weightedRides = []; //weighted list q
    Set<String> partialRideshareIDs = new Set();
    Set<String> partialRiderIDs = new Set();
    Set<String> partialDriverIDs = new Set();
    Map<String, UserProfile> riderProfiles = {};
    Map<String, UserProfile> driverProfiles = {};
    Map<String, bool> isCurrentRiderInsideRide = {};
    
    UserProfile currentRiderProfile;

    //helpers
    bool ridersAreSameGender(Map profiles, List<String> potentialRiders, String riderId){
      bool sameGender = true;
      for(String potentialRider in potentialRiders){
        sameGender = (currentRiderProfile.isMale == profiles[potentialRider].isMale);
        if(!sameGender) break;
      }
      return sameGender;
    }
    
    await dbRef
    .collection('rideshares')
    .getDocuments()
    .then((QuerySnapshot snapShot) {
      snapShot.documents.forEach((d){
        var doc = d.data;
        //initial validations: empty seats, same day, departure within 2 km
        if (
          doc["driverId"] != riderId && // rider can't hop on their own ride
          doc["capacity"] - doc["riders"].length > 0 && //need empty seats
          DateTime.parse(doc["rideDate"]).day == DateTime.parse(searchOptions["date"]).day && //same day
          //pickup and dropoff within 2km of requested lat, long
          isWithinRadius(doc["locationPickUp"]["lat"],doc["locationPickUp"]["long"],searchOptions["from"]["coordinates"][0],searchOptions["from"]["coordinates"][1]) &&
          isWithinRadius(doc["locationDropOff"]["lat"],doc["locationDropOff"]["long"],searchOptions["to"]["coordinates"][0],searchOptions["to"]["coordinates"][1])
        ){ 
          partialRideshareIDs.add(d.documentID);
          for(String rider in doc["riders"]) partialRiderIDs.add(rider);
          partialDriverIDs.add(doc["driverId"]);
        }
      });
    });

    //load the profile data for riders, drivers, current rider
    riderProfiles = await UserProfileData.fetchProfileDataForUsersMap(partialRiderIDs.toList());
    driverProfiles = await UserProfileData.fetchProfileDataForUsersMap(partialDriverIDs.toList());
    currentRiderProfile = await UserProfileData.fetchUserProfileData(riderId);
    
    //final validation and weighting
    await dbRef
    .collection('rideshares')
    .getDocuments()
    .then((QuerySnapshot snapShot){
      snapShot.documents.forEach((f){
        var doc = f.data;
        double weighting = 0.0;
        if (
          partialRideshareIDs.contains(f.documentID) &&
          //verify same gender for passengers and driver
          (!searchOptions["gender"] || (ridersAreSameGender(riderProfiles, doc["riders"], riderId) && doc["driverId"].isMale == currentRiderProfile.isMale)) &&
          //verify current rider is not in this ride
          !doc['riders'].toList().contains(riderId)
        ){
          //weighting for valid rides
          // +3 for each passenger (including rider + driver) in same program/department/university
          // +2 quiet/talkative
          //actual implementation subtracts so don't need to reverse sort for descending
          for(String riderId in doc["riders"]){
            if (riderProfiles[riderId].program == currentRiderProfile.program) weighting-=3;
            if (riderProfiles[riderId].university == currentRiderProfile.university) weighting-=3;
          }
          if (driverProfiles[doc["driverId"]].program == currentRiderProfile.program) weighting-=3;
          if (driverProfiles[doc["driverId"]].university == currentRiderProfile.university) weighting-=3;
          Car car = Car.fromCarDetails(
              f.data['car']['model'],
              f.data['car']['make'],
              f.data['car']['year'],
              f.data['car']['licensePlate'],
            );

            String driverFirstName =  f.data['driverFirstName'];
            String driverLastName =  f.data['driverLastName'];

            Location locationPickUp = Location.fromDetails(
              f.data['locationPickUp']['description'],
              f.data['locationPickUp']['placeId'],
              f.data['locationPickUp']['lat'],
              f.data['locationPickUp']['long']
            );

            Location locationDropOff = Location.fromDetails(
              f.data['locationDropOff']['description'],
              f.data['locationDropOff']['placeId'],
              f.data['locationDropOff']['lat'],
              f.data['locationDropOff']['long']
            );
            List<String> rideShareTime = f.data['rideTime'].split(':');
            List<String> riders = [];

            for(var rider in f.data['riders']) {
              riders.add(rider.toString());
            }
            bool isDriverMale = f.data['isDriverMale'];
            String driverUniversity = f.data['driverUniversity'];
            String driverProgram = f.data['driverProgram'];
            String driverProfilePic = f.data['driverProfilePic'];
            int luggage = f.data['luggage'];

            Rideshare riderRideShare = Rideshare.fromDetails(
              f.data['driverId'],
              DateTime.parse(f.data['rideDate']),
              new TimeOfDay(hour: int.parse(rideShareTime[0]), minute: int.parse(rideShareTime[1])),
              f.data['capacity'],
              f.data['numberOfCurrentRiders'],
              f.data['price'],
              car,
              riders,
              isDriverMale,
              driverUniversity,
              driverProgram,
              driverFirstName,
              driverLastName,
              driverProfilePic,
              locationPickUp,
              locationDropOff,
              luggage,
            );
          weightedRides.add(Tuple2(weighting,riderRideShare));
        }
      });
    });
    weightedRides.sort((a, b) => a.item1.compareTo(b.item1));

    //remove any rides that the rider has already requested
    List<Rideshare> postWeigthedResults = weightedRides.map((item)=>item.item2).toList();
    print(postWeigthedResults.length.toString());
    List<Rideshare> finalResults = [];
    for(Rideshare weightedRideshare in postWeigthedResults){
      bool remove = false;
      await dbRef
      .collection('rideshare-requests')
      .getDocuments()
      .then((QuerySnapshot snapShot) {
        snapShot.documents.forEach((d){
          var doc = d.data;
          if(d.documentID == weightedRideshare.driverId){
            String uniqueRideShareId = weightedRideshare.driverId + '-' + weightedRideshare.rideDate.toString().split(' ')[0] + '-' + weightedRideshare.rideTime.hour.toString() + ':' + weightedRideshare.rideTime.minute.toString();
            for(var rideRequestForThisDriver in doc["requests"]){
              if (rideRequestForThisDriver["rideshareRef"] == uniqueRideShareId && riderId == rideRequestForThisDriver["riderId"]){
                remove = true;
                break;
              }
            }
          }
        });
        if(!remove) finalResults.add(weightedRideshare);
      });
    }
      // .document(weightedRideshare.driverId).get()
    //   .then((d){
    //     var doc = d.data;
    //     print(d.documentID);
    //     //got through all of thid driver's ride
    //     String uniqueRideShareId = weightedRideshare.driverId + '-' + weightedRideshare.rideDate.toString().split(' ')[0] + '-' + weightedRideshare.rideTime.hour.toString() + ':' + weightedRideshare.rideTime.minute.toString();
    //     for(var rideRequestForThisDriver in doc["requests"]){
    //       if (rideRequestForThisDriver["rideshareRef"] == uniqueRideShareId && riderId == rideRequestForThisDriver["riderId"]){
    //         remove = true;
    //       }
    //     }

    //   });
    //   if(!remove) finalResults.add(weightedRideshare);
    // }

    return finalResults;
  }


  //search filter helper functions
  static isWithinRadius(double lat1, double lng1, double lat2, double lng2, {int radiusInMetres = 2000}){
    final Distance distance = new Distance();
    return distance(LatLng(lat1,lng1), LatLng(lat2,lng2)) <= radiusInMetres;
  }

  //needs to be modified with search functions
  static Future<List<Rideshare>> fetchRideshareFilterResults() async{
    var dummyData = Rideshare.fromDetails(
      "diver_id",
      DateTime.now(),
      TimeOfDay(hour: 14, minute: 69),
      4,
      3,
      15.0,
      Car.fromCarDetails('model x', 'make x','2011','324kblk1234iu'),
      ['rider 1', 'rider 2', 'rider 3'],
      false,
      'University of Waterloo',
      'Systems Design Engineering',
      'Revanth',
      'Sakthi',
      'profile_string',
      Location.fromDetails("1276 Silver Spear Road, Mississauga, ON", "place_id", 0, 0),
      Location.fromDetails("E5 Building, Waterloo, ON", "place_id", 0, 0),
      3,
    );

    return Future.delayed(Duration(seconds: 1), () => Future.value([dummyData, dummyData, dummyData, dummyData, dummyData]));
  }
}