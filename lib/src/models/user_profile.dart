import 'package:flutter/material.dart';
import 'package:our_ride/src/models/car.dart';
import 'package:our_ride/src/models/payment_method.dart';
import 'package:our_ride/src/models/review.dart';

class UserProfile {
  String email;
  String password;
  String firstName;
  String lastName;
  bool isMale;
  String driverLicenseNumber;

  String city;
  final String state = 'Ontario';
  int points;
  int ridesGiven;
  int ridesTaken;
  String aboutMe;
  String program;
  String university;
  String profilePic;
  String facebookUserId;
  List<Review> reviews;
  PaymentMethod paymentMethod;
  List<Car> userVehicles;

  UserProfile() {
    this.email = '';
    this.password = '';
    this.firstName = '';
    this.lastName = '';
    this.isMale = true;
    this.driverLicenseNumber = '';
    this.city = '';
    this.points = 0;
    this.ridesGiven = 0;
    this.ridesTaken = 0;
    this.aboutMe = '';
    this.program = '';
    this.university = '';
    this.profilePic = '';
    this.facebookUserId = '';
    this.reviews = [];
    this.paymentMethod = new PaymentMethod();
    this.userVehicles = [];
  }

  UserProfile.fromDetails(
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.isMale,
    this.driverLicenseNumber,
    this.city,
    this.points,
    this.ridesGiven,
    this.ridesTaken,
    this.aboutMe,
    this.program,
    this.university,
    this.profilePic,
    this.facebookUserId,
    this.reviews,
    this.paymentMethod,
    this.userVehicles,
  );
}