import 'package:flutter/material.dart';

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
  Image profilePic;

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
    this.profilePic = new Image.asset('assets/images/default-profile.png');
  }
}