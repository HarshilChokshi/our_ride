import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:our_ride/src/DAOs/UserProfileData.dart';
import 'package:our_ride/src/models/car.dart';
import 'package:our_ride/src/models/rideshare_model.dart';
import 'package:our_ride/src/screens/ride_share_created_screen.dart';
import 'package:our_ride/src/widgets/TF_autocomplete.dart';
import 'package:our_ride/src/widgets/rideshare_search_filter.dart';
import '../contants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class CreateRideScreen extends StatefulWidget {
  String driverId;
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new CreateRideState(driverId);
  }

  CreateRideScreen(String driverId) {
    this.driverId = driverId;
  }
}

class CreateRideState extends State<CreateRideScreen> {

  String driverId;
  final locationFormKey = new GlobalKey<FormState>();
  final carFormKey = new GlobalKey<FormState>();
  Rideshare rideshare;
  final databaseReference = Firestore.instance;
  TextEditingController pickUpLocationController = TextEditingController();
  TextEditingController dropOffLocationController = TextEditingController();

  CreateRideState(String driverId) {
    this.driverId = driverId;
  }

  @override
  Widget build(BuildContext context) {
    Car rideShareVehicle = new Car();
    rideshare = new Rideshare(driverId, rideShareVehicle);
    return new Scaffold(
      backgroundColor: lightGreyColor,
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        backgroundColor: appThemeColor,
        title: new Text(
          'Ride Creation',
          style: new TextStyle(
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: createRideShare,
            child: new Icon(
              Icons.check,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Container(margin: EdgeInsets.only(bottom: 20)),
            createAddLocationImage(),
            new Container(
            margin: EdgeInsets.only(bottom: 10)),
            createLocationForm(),
            new Container(margin: EdgeInsets.only(bottom: 20)),
            createYourCarText(),
            new Container(margin: EdgeInsets.only(bottom: 20)),
            createCarSection(),
          ],
        )
      ),
    );
  }

  void createRideShare() {
    if(!carFormKey.currentState.validate() || !locationFormKey.currentState.validate()) {
      return;
    }

    carFormKey.currentState.save();
    locationFormKey.currentState.save();
    rideshare.numberOfCurrentRiders = 0;
    rideshare.riders = [];

    addRideShareToDB(rideshare);

    Navigator.pushReplacement(
      context, 
      new CupertinoPageRoute(
        builder: (context) => RideShareCreatedScreen(driverId)
      ));
  }

  void addRideShareToDB(Rideshare r) async {
    bool isDriverMale;
    String driverUniversity;
    String driverProgram;
    String driverFirstName;
    String driverLastName;
    String driverProfilePic;

    await UserProfileData.fetchUserProfileData(driverId)
    .then((profile) {
      isDriverMale = profile.isMale;
      driverUniversity = profile.university;
      driverProgram = profile.program;
      driverFirstName = profile.firstName;
      driverLastName = profile.lastName;
      driverProfilePic = profile.profilePic;
    });
    await databaseReference.collection('rideshares')
    .document(r.driverId + '-' + r.rideDate.toString() + '-' + r.rideTime.hour.toString() + ':' + r.rideTime.minute.toString())
    .setData({
      'driverId': r.driverId,
      'rideDate': r.rideDate.toString(),
      'rideTime': r.rideTime.hour.toString() + ':' + r.rideTime.minute.toString(),
      'capacity': r.capacity,
      'numberOfCurrentRiders': r.numberOfCurrentRiders,
      'price': r.price,
      'car': r.car.toJson(),
      'riders': r.riders,
      'isDriverMale': isDriverMale,
      'driverUniversity': driverUniversity,
      'driverProgram': driverProgram,
      'driverFirstName': driverFirstName,
      'driverLastName': driverLastName,
      'driverProfilePic': driverProfilePic,
      'locationPickUp': r.locationPickUp.toJson(),
      'locationDropOff': r.locationDropOff.toJson(),
    });
  }

  Widget createAddLocationImage() {
    return new Icon(
      Icons.add_location,
      color: Colors.white,
      size: 50.0,
    );
  }

  Widget createLocationForm() {
    return new Container(
      width: double.infinity,
      color: Colors.white,
      child: new Form(
        key: locationFormKey,
        child: new Row(
          children: <Widget>[
            new Container(margin: EdgeInsets.only(left: 15)),
            new Flexible(
              child: new Column(
                  children: <Widget>[
                    createDateTextField(),
                    createTimeTextField(),
                    createCapacityTextField(),
                    createLocationDropDown(true),
                    createLocationDropDown(false),
                    createPriceTextField(),
                  ],
                ),
            ),
            new Container(margin: EdgeInsets.only(left: 15)),
          ],
        ),
      ),
    );
  }

  Widget createYourCarText() {
    return new Container(
      alignment: new Alignment(-1.0, 0.0),
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      child: new Text(
        'Your Car',
        style: new TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  Widget createCarSection() {
   return new Container(
      width: double.infinity,
      color: Colors.white,
      child: new Form(
        key: carFormKey,
        child: new Row(
          children: <Widget>[
            new Container(margin: EdgeInsets.only(left: 15)),
            new Flexible(
              child: new Column(
                  children: <Widget>[
                    new Icon(
                      Icons.directions_car,
                      size: 40,
                    ),
                    createCarInfoTextField('Make'),
                    createCarInfoTextField('Model'),
                    createCarInfoTextField('Year'),
                    createCarInfoTextField('License Plate'),
                  ],
                ),
            ),
            new Container(margin: EdgeInsets.only(left: 15)),
          ],
        ),
      ),
    );  
  }

  Widget createDateTextField() {
   return new TextFormField(
      style: new TextStyle(
        color: Colors.grey,
      ),
      decoration: new InputDecoration(
        hintText: 'Date: yyyy-mm-dd',
        hintStyle: new TextStyle(fontSize: 14, color: Colors.grey),
        errorStyle: new TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: new Color.fromARGB(20, 211, 211, 211),
        focusedBorder: new UnderlineInputBorder(
          borderSide: new BorderSide(
            color: lightGreyColor,
            width: 2.0,
          )
        ),
        enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(
              width: 2.0,
              color: lightGreyColor,
            )
          ),
        ),
      cursorColor: Colors.grey,
      validator: (String value) {
        try {
          DateTime rideShareDate = DateTime.parse(value);
        } on FormatException catch(e) {
          return 'Date must be speicified in yyyy-mm-dd format';
        }
      },
      onSaved: (String value) {
        rideshare.rideDate = DateTime.parse(value);
      },
    );
  }

 Widget createTimeTextField() {
    return new TextFormField(
      style: new TextStyle(
        color: Colors.grey,
      ),
      decoration: new InputDecoration(
        hintText: 'Time Example: 16:30',
        hintStyle: new TextStyle(fontSize: 14, color: Colors.grey),
        errorStyle: new TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: new Color.fromARGB(20, 211, 211, 211),
        focusedBorder: new UnderlineInputBorder(
          borderSide: new BorderSide(
            color: lightGreyColor,
            width: 2.0,
          )
        ),
        enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(
              width: 2.0,
              color: lightGreyColor,
            )
          ),
        ),
      cursorColor: Colors.grey,
      validator: (String value) {
        try {
          int hour;
          int minute;
          List<String> split = value.split(':');
          hour = int.parse(split[0]);
          minute = int.parse(split[1]);
        } on Exception catch(e) {
          return 'Time must be given in hh:mm format';
        }
      },
      onSaved: (String value) {
        List<String> split = value.split(':');
        TimeOfDay timeOfRide = new TimeOfDay(hour: int.parse(split[0]), minute: int.parse(split[1]));
        rideshare.rideTime = timeOfRide;
      },
    );
  }
  Widget createCapacityTextField() {
    return new TextFormField(
      style: new TextStyle(
        color: Colors.grey,
      ),
      decoration: new InputDecoration(
        hintText: 'Capacity',
        hintStyle: new TextStyle(fontSize: 14, color: Colors.grey),
        errorStyle: new TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: new Color.fromARGB(20, 211, 211, 211),
        focusedBorder: new UnderlineInputBorder(
          borderSide: new BorderSide(
            color: lightGreyColor,
            width: 2.0,
          )
        ),
        enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(
              width: 2.0,
              color: lightGreyColor,
            )
          ),
        ),
      cursorColor: Colors.grey,
      keyboardType: TextInputType.number,
      validator: (String value) {
        try {
          int.parse(value);
        } on Exception catch(e) {
          return 'The capacity cannot be empty';
        }
      },
      onSaved: (String value) {
        rideshare.capacity = int.parse(value);
      },
    );
  }

  Widget createLocationDropDown(bool isPickUpLocation) {
    return new TFWithAutoComplete(
      dropDownColor: Color.fromARGB(20, 211, 211, 211),
      hintText: isPickUpLocation ? 'Pick up location' : 'Drop off location',
      suggestionsCallback: (String prefix) async {
        return await fetchLocationSuggestions(prefix);
      },
      itemBuilder: (context, value) {
        return new Container(
          color: appThemeColor,
          child: ListTile(
            leading: Icon(Icons.location_searching),
            title: new Text(
              value,
              style: new TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          )
        );
      },
      onSuggestionsSelected: (suggestion) {
        if(isPickUpLocation) {
          //rideshare.pickUpLocation = suggestion;
          pickUpLocationController.text = suggestion;
        } else {
          //rideshare.dropOffLocation = suggestion;
          dropOffLocationController.text = suggestion;
        }
      },
      typeAheadController: isPickUpLocation ? pickUpLocationController : dropOffLocationController,
    );
  }

  Widget createLocationTextField(bool isPickUpLocation) {
    String text = isPickUpLocation ? 'From' : 'To';
    return new TextFormField(
      style: new TextStyle(
        color: Colors.grey,
      ),
      decoration: new InputDecoration(
        hintText: text,
        hintStyle: new TextStyle(fontSize: 14, color: Colors.grey),
        errorStyle: new TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: new Color.fromARGB(20, 211, 211, 211),
        focusedBorder: new UnderlineInputBorder(
          borderSide: new BorderSide(
            color: lightGreyColor,
            width: 2.0,
          )
        ),
        enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(
              width: 2.0,
              color: lightGreyColor,
            )
          ),
        ),
      cursorColor: Colors.grey,
      validator: (String value) {
        if(value.length == 0) {
          return 'Must specify a location';
        }
      },
      onSaved: (String value) {
        if(isPickUpLocation) {
          //rideshare.pickUpLocation = value;
        } else {
          //rideshare.dropOffLocation = value;
        }
      },
    );
  }

  Widget createPriceTextField() {
    return new TextFormField(
      style: new TextStyle(
        color: Colors.grey,
      ),
      decoration: new InputDecoration(
        hintText: 'Price',
        hintStyle: new TextStyle(fontSize: 14, color: Colors.grey),
        errorStyle: new TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: new Color.fromARGB(20, 211, 211, 211),
        focusedBorder: new UnderlineInputBorder(
          borderSide: new BorderSide(
            color: lightGreyColor,
            width: 2.0,
          )
        ),
        enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(
              width: 2.0,
              color: lightGreyColor,
            )
          ),
        ),
      cursorColor: Colors.grey,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: (String value) {
        try {
          double.parse(value);
        } on Exception catch(e) {
          return 'Format for price is dd.cc';
        }
      },
      onSaved: (String value) {
        rideshare.price = double.parse(value);
      },
    );
  }

  Widget createCarInfoTextField(String carInfo) {
   return new TextFormField(
      style: new TextStyle(
        color: Colors.grey,
      ),
      decoration: new InputDecoration(
        hintText: carInfo,
        hintStyle: new TextStyle(fontSize: 14, color: Colors.grey),
        errorStyle: new TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: new Color.fromARGB(20, 211, 211, 211),
        focusedBorder: new UnderlineInputBorder(
          borderSide: new BorderSide(
            color: lightGreyColor,
            width: 2.0,
          )
        ),
        enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(
              width: 2.0,
              color: lightGreyColor,
            )
          ),
        ),
      cursorColor: Colors.grey,
      validator: (String value) {
        if(value.isEmpty) {
          return 'Value cannot be empty';
        }
      },
      onSaved: (String value) {
        if(carInfo == 'Make') {
          rideshare.car.make = value;
        } else if(carInfo == 'Model') {
          rideshare.car.model = value;
        } else if(carInfo == 'Year') {
          rideshare.car.year = value;
        } else if(carInfo == 'License Plate') {
          rideshare.car.licensePlate = value;
        }
      },
    );
  }
}