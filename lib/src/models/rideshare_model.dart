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

  Rideshare(String driverId, Car car) {
    this.driverId = driverId;
    this.car = car;
  }
}