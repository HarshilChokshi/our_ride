import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:our_ride/src/models/rideshare_model.dart';
import 'package:our_ride/src/models/location_model.dart';
import 'package:our_ride/src/models/car.dart';

class RideShareSearch{
  static DatabaseReference dbRef = FirebaseDatabase.instance.reference();

  static Future<List<Rideshare>> filterUsers() async{
    // var results = await dbRef.
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
      Location.fromDetails("E5 Building, Waterloo, ON", "place_id", 0, 0)
    );

    return Future.delayed(Duration(seconds: 1), () => Future.value([dummyData, dummyData, dummyData, dummyData, dummyData]));
  }
}