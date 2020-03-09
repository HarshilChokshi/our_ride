import 'package:flutter/material.dart';
import 'package:our_ride/src/models/car.dart';

class Rideshare {
  String driverId;
  String pickUpLocation;
  String dropOffLocation;
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

  Rideshare(String driverId, Car car) {
    this.driverId = driverId;
    this.car = car;
  }

  Rideshare.fromDetails(
    String driverId,
    String pickUpLocation,
    String dropOffLocation,
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
  ) {
    this.driverId = driverId;
    this.pickUpLocation = pickUpLocation;
    this.dropOffLocation = dropOffLocation;
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
  }
}