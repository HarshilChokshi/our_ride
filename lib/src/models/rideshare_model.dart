import 'package:flutter/material.dart';
import 'package:our_ride/src/models/car.dart';
import 'package:our_ride/src/models/location_model.dart';

class Rideshare {
  String driverId;
  DateTime rideDate;
  TimeOfDay rideTime;
  int capacity;
  int numberOfCurrentRiders;
  double price;
  Car car;
  List<String> riders;
  bool isDriverMale;
  String driverUniversity;
  String driverProgram;
  String driverFirstName;
  String driverLastName;
  String driverProfilePic;
  Location locationPickUp;
  Location locationDropOff;
  int luggage;


  Rideshare(String driverId, Car car, Location locationPickUp, Location locationDropOff) {
    this.driverId = driverId;
    this.car = car;
    this.locationPickUp = locationPickUp;
    this.locationDropOff = locationDropOff;
  }

  Rideshare.fromDetails(
    String driverId,
    DateTime rideDate,
    TimeOfDay rideTime,
    int capacity,
    int numberOfCurrentRiders,
    double price,
    Car car,
    List<String> riders,
    bool isDriverMale,
    String driverUniversity,
    String driverProgram,
    String driverFirstName,
    String driverLastName,
    String driverProfilePic,
    Location locationPickUp,
    Location locationDropOff,
    int luggage,
  ) {
    this.driverId = driverId;
    this.rideDate = rideDate;
    this.rideTime = rideTime;
    this.capacity = capacity;
    this.numberOfCurrentRiders = numberOfCurrentRiders;
    this.price = price;
    this.car = car;
    this.riders = riders;
    this.isDriverMale = isDriverMale;
    this.driverUniversity = driverUniversity;
    this.driverProgram = driverProgram;
    this.driverFirstName = driverFirstName;
    this.driverLastName = driverLastName;
    this.driverProfilePic = driverProfilePic;
    this.locationPickUp = locationPickUp;
    this.locationDropOff = locationDropOff;
    this.luggage = luggage;
  }
}