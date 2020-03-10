import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:our_ride/src/DAOs/UserProfileData.dart';
import 'package:our_ride/src/models/car.dart';
import 'package:our_ride/src/models/location_model.dart';
import 'package:our_ride/src/models/rideshare_model.dart';
import 'package:our_ride/src/screens/ride_share_created_screen.dart';
import 'package:our_ride/src/widgets/DT_picker.dart';
import 'package:our_ride/src/widgets/TF_autocomplete.dart';
import 'package:our_ride/src/widgets/rideshare_search_filter.dart';
import 'package:our_ride/src/DAOs/GoogleMaps.dart';
import '../contants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class CreateRideScreen extends StatefulWidget {
  String driverId;
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new CreateRideState(driverId);
  }

  CreateRideScreen(String driverId) {
    this.driverId = driverId;
    SystemChannels.textInput.invokeMethod('TextInput.hide');
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
  String selectedDate;
  String selectedTime;

  CreateRideState(String driverId) {
    this.driverId = driverId;
    Car rideShareVehicle = new Car();
    Location locationPickUp = new Location();
    Location locationDropOff = new Location();
    rideshare = new Rideshare(driverId, rideShareVehicle, locationPickUp, locationDropOff);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: appThemeColor,
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
              createLocationForm(),
              new Container(margin: EdgeInsets.only(bottom: 20)),
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

    if(selectedDate.isEmpty || selectedTime.isEmpty) {
      showEmptyFieldAlert();
      return;
    }

    if(this.rideshare.locationPickUp.description == null ||
      this.rideshare.locationDropOff.description == null) {
        showEmptyFieldAlert();
        return;
    }
   
    getLatLong(rideshare.locationPickUp.placeId, true);
    getLatLong(rideshare.locationDropOff.placeId, false);

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

  void getLatLong(String placeId, bool isPickUpLocation) async {
    await GoogleMapsHandler.fetchLatLongForPlaceID(placeId)
    .then((List latlong){
      double lat = latlong[0];
      double long = latlong[1];
      if(isPickUpLocation) {
        rideshare.locationPickUp.lat = lat;
        rideshare.locationPickUp.long = long;
      } else {
        rideshare.locationDropOff.lat = lat;
        rideshare.locationDropOff.long = long;
      }
    });
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
    .document(r.driverId + '-' + selectedDate + '-' + selectedTime)
    .setData({
      'driverId': r.driverId,
      'rideDate': selectedDate,
      'rideTime': selectedTime,
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

  void showEmptyFieldAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(61, 191, 165, 100),
          title: new Text('Empty Fields'),
          content: new Text('No fields can be empty', style: new TextStyle(color: Colors.black),),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Close', style: new TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
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
      color: appThemeColor,
      child: new Form(
        key: locationFormKey,
        child: new Row(
          children: <Widget>[
            new Container(margin: EdgeInsets.only(left: 15)),
            new Flexible(
              child: new Column(
                  children: <Widget>[
                    new DateTimeFilter(
                     updateDateTime: updateDateTime,
                     dateState: selectedDate,
                     timeState: selectedTime,
                    ),
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


  void updateDateTime(String type, String state) {
    setState(() {
      if(type == 'date') {
        this.selectedDate = state;
      } else {
        this.selectedTime = state;
      }
    });
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
      color: appThemeColor,
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
        fillColor: new Color.fromRGBO(61, 191, 165, 100),
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

  Widget createCapacityTextField() {
    return new Container(
      height: 60,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(61, 191, 165, 100),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10)) 
      ),
      child: TextFormField(
        style: new TextStyle(
          color: Colors.white,
        ),
        decoration: new InputDecoration(
          hintText: 'Capacity',
          hintStyle: new TextStyle(fontSize: 14, color: new Color.fromARGB(150, 255, 255, 255)),
          errorStyle: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          filled: true,
          fillColor: new Color.fromARGB(20, 211, 211, 211),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
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
      ),
    );  
  }

  Widget createLocationDropDown(bool isPickUpLocation) {
    return new Container(
      height: 60,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(61, 191, 165, 100),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10)) 
      ),
      child: TFWithAutoComplete(
        dropDownColor: Color.fromARGB(20, 211, 211, 211),
        hintText: isPickUpLocation ? 'Pick up location' : 'Drop off location',
        suggestionsCallback: (String prefix) async {
          return await GoogleMapsHandler.fetchLocationSuggestions(prefix);
        },
        itemBuilder: (context, suggestion) {
          return new Container(
            color: appThemeColor,
            child: ListTile(
              leading: Icon(Icons.location_searching),
              title: new Text(
                suggestion['description'],
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
            this.rideshare.locationPickUp.description = suggestion['description'];
            print('pick location is: ' + rideshare.locationPickUp.description);
            this.rideshare.locationPickUp.placeId = suggestion['id'];
            this.pickUpLocationController.text = suggestion['description'];             
          } else {
            this.rideshare.locationDropOff.description = suggestion['description'];
            print('dropoff location is: ' + rideshare.locationDropOff.description);
            this.rideshare.locationDropOff.placeId = suggestion['id'];
            this.dropOffLocationController.text = suggestion['description'];              
          }
        },
        typeAheadController: isPickUpLocation ? pickUpLocationController : dropOffLocationController,
      )
    );
  }

  Widget createPriceTextField() {
    return new Container(
      height: 60,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(61, 191, 165, 100),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10)) 
      ),
      child: TextFormField(
        style: new TextStyle(
          color: Colors.white,
        ),
        decoration: new InputDecoration(
          hintText: 'Price',
          hintStyle: new TextStyle(fontSize: 14, color: Color.fromARGB(150, 255, 255, 255)),
          errorStyle: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          filled: true,
          fillColor: new Color.fromARGB(20, 211, 211, 211),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
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
      )
    );
  }

  Widget createCarInfoTextField(String carInfo) {
    return new Container(
      height: 60,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(61, 191, 165, 100),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10)) 
      ),
      child: new Center(
        child: TextFormField(
          style: new TextStyle(
            color: Colors.white,
          ),
          decoration: new InputDecoration(
            hintText: carInfo,
            hintStyle: new TextStyle(fontSize: 14, color: new Color.fromARGB(150, 255, 255, 255)),
            errorStyle: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            filled: true,
            fillColor: new Color.fromARGB(20, 211, 211, 211),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
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
        ),
      ),
    );
  }
}