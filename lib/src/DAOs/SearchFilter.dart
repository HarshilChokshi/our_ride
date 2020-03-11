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
    Set<String> partialRideshareIDs;
    Set<String> partialRiderIDs;
    Set<String> partialDriverIDs;
    Map<String, UserProfile> riderProfiles;
    Map<String, UserProfile> driverProfiles;
    
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
      snapShot.documents.forEach((doc){
        //initial validations: empty seats, same day, departure within 2 km
        if (
          doc["driverId"] != riderId && // rider can't hop on their own ride
          doc["capacity"] - doc["numberOfCurrentRiders"] > 0 && //need empty seats
          DateTime.parse(doc["rideDate"]).day == DateTime.parse(searchOptions["date"]).day && //same day
          //pickup and dropoff within 2km of requested lat, long
          isWithinRadius(doc["locationPickUp"]["lat"],doc["locationPickUp"]["long"],searchOptions["from"]["coordinates"][0],searchOptions["from"]["coordinates"][1]) &&
          isWithinRadius(doc["locationDropOff"]["lat"],doc["locationDropOff"]["long"],searchOptions["from"]["coordinates"][0],searchOptions["from"]["coordinates"][1])
        ){ 
          partialRideshareIDs.add(doc.documentID);
          partialRiderIDs.addAll(doc["riders"]);
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
      snapShot.documents.forEach((doc){
        double weighting = 0.0;
        if (
          partialRideshareIDs.contains(doc.documentID) &&
          //verify same gender for passengers and driver
          (!doc["sameGender"] || (ridersAreSameGender(riderProfiles, doc["riders"], riderId) && doc["driverId"].isMale == currentRiderProfile.isMale))
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
          
          Rideshare riderRideShare = Rideshare.fromDetails(
            doc['driverId'],
            doc['rideDate'],
            doc['rideTime'],
            doc['capacity'],
            doc['numberOfCurrentRiders'],
            doc['price'],
            Car.fromCarDetails(
              doc['car']['model'],
              doc['car']['make'],
              doc['car']['year'],
              doc['car']['licensePlate'],
            ),
            doc["riders"],
            doc["driverId"].isMale,
            doc["driverUniversity"],
            doc["driverProgram"],
            doc["driverFirstName"],
            doc["driverLastName"],
            doc["driverProfilePic"],
            Location.fromDetails(
              doc['locationPickUp']['description'],
              doc['locationPickUp']['placeId'],
              doc['locationPickUp']['lat'],
              doc['locationPickUp']['long']
            ),
            Location.fromDetails(
              doc['locationDropOff']['description'],
              doc['locationDropOff']['placeId'],
              doc['locationDropOff']['lat'],
              doc['locationDropOff']['long']
            ),
            doc['luggage'],
          );
          weightedRides.add(Tuple2(weighting,riderRideShare));
        }
      });
    });

    //sort weighted rides
    weightedRides.sort();
    return weightedRides.map((item)=>item.item2);
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