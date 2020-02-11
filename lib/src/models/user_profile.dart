import 'package:flutter/material.dart';

class UserProfile {
  String name;
  String city;
  final String state = 'Ontario';
  int points;
  int ridesGiven;
  int ridesTaken;
  String aboutMe;
  String program;
  Image profilePic;

  UserProfile() {
    this.name = name;
    this.city = city;
    this.points = points;
    this.ridesGiven = ridesGiven;
    this.ridesTaken = ridesTaken;
    this.aboutMe = aboutMe;
    this.program = program;
    this.profilePic = profilePic;
  }
}