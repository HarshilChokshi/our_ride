import 'package:flutter/material.dart';
import 'package:our_ride/src/models/rideshare_model.dart';

class RideRequest {
  String driverId;
  String riderId;
  String riderFirstName;
  String riderLastName;
  String facebookId;
  String profilePic;
  String pickUpLocation;
  String dropOffLocation;
  DateTime rideshareDate;
  TimeOfDay rideTime;
  double ridesharePrice;
  String rideshareRef;

  RideRequest(
    this.driverId,
    this.riderId,
    this.riderFirstName,
    this.riderLastName,
    this.facebookId,
    this.profilePic,
    this.pickUpLocation,
    this.dropOffLocation,
    this.rideshareDate,
    this.rideTime,
    this.ridesharePrice,
    this.rideshareRef,
  );
}