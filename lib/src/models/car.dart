import 'package:flutter/material.dart';

class Car {
  String model;
  String make;
  String year;
  String licensePlate;
  Image carPicture;

  Car() {
    this.model = '';
    this.make = '';
    this.year = '';
    this.licensePlate = '';
  }

  toJson() {
    return {
      'model': model,
      'make': make,
      'year': year,
      'licensePlate': licensePlate,
    };
  }
}