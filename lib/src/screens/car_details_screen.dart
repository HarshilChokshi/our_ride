import 'package:flutter/material.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/models/car.dart';
import 'package:our_ride/src/models/user_profile.dart';
import 'package:our_ride/src/screens/payment_info_screen.dart';
import 'package:our_ride/src/widgets/our_ride_title.dart';
import 'package:flutter/cupertino.dart';

class CarDetailsScreen extends StatefulWidget {
  UserProfile userProfile;

  CarDetailsScreen(this.userProfile);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new CarDetailsState(userProfile);
  }
}

class CarDetailsState extends State<CarDetailsScreen> {
  UserProfile userProfile;
  final formKey = new GlobalKey<FormState>();  


  CarDetailsState(UserProfile userProfile) {
    this.userProfile = userProfile;
    userProfile.userVehicles.add(new Car());
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: AssetImage('assets/images/background.png'), fit: BoxFit.cover
        ),
      ),
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomPadding: false,
        body: new Container(
          margin: new EdgeInsets.only(left: 50, right: 50, top: 20),
          child: new Form(
            key: formKey,
            child: new Column(
              children: <Widget>[
                new OurRideTitle(),
                new Container(margin: EdgeInsets.only(bottom: 100)),
                createTextFromField('Model'),
                new Container(margin: EdgeInsets.only(bottom: 10)),
                createTextFromField('Make'),
                new Container(margin: EdgeInsets.only(bottom: 10)),
                createTextFromField('Year'),
                new Container(margin: EdgeInsets.only(bottom: 10)),
                createTextFromField('License Plate'),
                  new Container(margin: EdgeInsets.only(bottom: 10)),
                createNextButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createTextFromField(String hintText) {
    return new TextFormField(
      style: new TextStyle(fontSize: 14, color: Color.fromARGB(255, 255, 255, 255)),
      decoration: new InputDecoration(
        hintText: hintText,
        hintStyle: new TextStyle(fontSize: 14, color: Color.fromARGB(150, 255, 255, 255)),
        errorStyle: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: new Color.fromARGB(20, 211, 211, 211),
      ),
      onSaved: (String value) {
        if(hintText == 'Model') {
          userProfile.userVehicles[0].model = value;
        } else if(hintText == 'Make') {
          userProfile.userVehicles[0].make = value;
        } else if(hintText == 'Year') {
          userProfile.userVehicles[0].year = value;
        } else if(hintText == 'License Plate') {
            userProfile.userVehicles[0].licensePlate = value;
        }
      },
      validator: (String value) {
        if(value.isEmpty) {
          return 'Value cannot be empty';
        }
        
        return null;
      },
    );
  }

  Widget createNextButton() {
   return Align(
     alignment: Alignment.bottomCenter,
    child: new SizedBox(
      width: double.infinity, 
      child: new RaisedButton(
        child: new Text(
          'Next',
          style: new TextStyle(color: Colors.white),
        ),
        onPressed: () {
          if(!formKey.currentState.validate()) {
            return;
          }

          formKey.currentState.save();

          Navigator.push(
              context, 
              CupertinoPageRoute(
                builder: (context) => PaymentInfoScreen(userProfile)
          )); 
        },
        color: appThemeColor,
      )
    )
    );
  }
}