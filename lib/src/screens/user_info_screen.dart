import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:our_ride/src/models/user_profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:our_ride/src/screens/driver_my_rideshares_screen.dart';
import 'package:our_ride/src/screens/rider_my_rideshares_screen.dart';
import '../widgets/our_ride_title.dart';
import '../contants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/TF_autocomplete.dart';

class UserInfoScreen extends StatefulWidget {
  UserProfile userProfile;

  UserInfoScreen(this.userProfile);
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new UserInfoState(userProfile);
  }
}

class UserInfoState extends State<UserInfoScreen> {
  
  UserProfile userProfile;
  final formKey = new GlobalKey<FormState>();
  final databaseReference = FirebaseDatabase.instance.reference();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController universityTEditingController = new TextEditingController();
  TextEditingController cityTEditingController = new TextEditingController();

  UserInfoState(this.userProfile);
  
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
                new Container(margin: EdgeInsets.only(bottom: 50)),
                createDropDown(false),
                new Container(margin: EdgeInsets.only(bottom: 12)),
                createTextFromField('Program'),
                new Container(margin: EdgeInsets.only(bottom: 10)),
                createDropDown(true),
                new Container(margin: EdgeInsets.only(bottom: 10)),
                createSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createTextFromField(String hintText) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: TextFormField(
            style: new TextStyle(fontSize: 14, color: Color.fromARGB(255, 255, 255, 255)),
            decoration: new InputDecoration(
              hintText: hintText,
              hintStyle: new TextStyle(fontSize: 14, color: Color.fromARGB(150, 255, 255, 255)),
              errorStyle: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              filled: true,
              fillColor: new Color.fromARGB(20, 211, 211, 211),
            ),
            onSaved: (String value) {
              if(hintText == 'University') {
                userProfile.university = value;
              } else if(hintText == 'Program') {
                userProfile.program = value;
              } else if(hintText == 'City') {
                userProfile.city = value;
              }
            },
            validator: (String value) {
              if(value.isEmpty) {
                return 'Value cannot be empty';
              }
              return null;
            },
          ),
        ),
        new IconButton(
          icon: new Icon(
            Icons.info,
            color: Colors.white,
          ),
          onPressed: () {
            showInformation(
              'Program Info',
              'OURide uses program information to rank rideshare results'
            );
          }
        ),
      ],
    );
  }

  Widget createSubmitButton() {
   return Align(
     alignment: Alignment.bottomCenter,
    child: new SizedBox(
      width: double.infinity, 
      child: new RaisedButton(
        child: new Text(
          'Submit',
          style: new TextStyle(color: Colors.white),
        ),
        onPressed: () {
          if(!formKey.currentState.validate()) {
            return;
          }

          formKey.currentState.save();

          if(userProfile.program.isEmpty || userProfile.university.isEmpty) {
            showEmptyFieldAlert();
          }
          
          registerUser(userProfile).then((FirebaseUser user) {
            if(user == null)
              return;

            addUserToDB(user.uid);
            if(userProfile.driverLicenseNumber.isNotEmpty) {
              Navigator.pushReplacement(
                context, 
                CupertinoPageRoute(
                  builder: (context) => MyRideSharesDriversScreen(user.uid)
              ));               
            } else {
                Navigator.pushReplacement(
                  context, 
                  CupertinoPageRoute(
                    builder: (context) => MyRideSharesRidersScreen(user.uid)
                ));               
            }
          });
        },
        color: appThemeColor,
      )
    )
    );
  }

  Widget createDropDown(bool isCity) {
    return new Row(
      children: <Widget>
      [
        new Expanded(
          child: TFWithAutoComplete(
            dropDownColor: Color.fromARGB(20, 211, 211, 211),
            hintText: isCity ? 'City' : 'University',
            suggestionsCallback: (String prefix) {
              if(prefix.length == 1) {
                prefix = prefix[0].toUpperCase();
              } else {
                prefix = prefix[0].toUpperCase() + prefix.substring(1, prefix.length);
              }

              if(isCity) {
                return ontarioCities.where((f) => f.startsWith(prefix)).toList();
              } else {
                return ontarioUniversities.where((f) => f.startsWith(prefix)).toList();
              }
            },
            itemBuilder: (context, value) {
              Icon leadingIcon = isCity ? 
                new Icon(Icons.location_city) :
                new Icon(Icons.school);
              return new Container(
                color: appThemeColor,
                child: ListTile(
                  leading: leadingIcon,
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
              if(isCity) {
                userProfile.city = suggestion;
                cityTEditingController.text = suggestion;
              } else {
                userProfile.university = suggestion;
                universityTEditingController.text = suggestion;
              }
            },
            typeAheadController: isCity ? cityTEditingController : universityTEditingController,
          )
        ),
        new IconButton(
          icon: new Icon(
            Icons.info,
            color: Colors.white,
          ),
          onPressed: () {
            showInformation(
              isCity ? 'City Info' : 'University Info',
              isCity ? 'OURide uses city information to rank rideshares when searching.' : 
              'OURide uses university information to rank rideshares when searching.'
            );
          }
        ),
      ],
    );
  }

  Future<FirebaseUser> registerUser(UserProfile userProfile) async {
    try {
      final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
        email: userProfile.email,
        password: userProfile.password,
      )).user;
      return user;
    }  catch(signUpError) {
        if(signUpError is PlatformException) {
          if(signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
            showEmailExistsAlert();
          }
        }
    }
    return null;
  }

  void showEmailExistsAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(61, 191, 165, 100),
          title: new Text('Facebook Account Linking'),
          content: new Text('A user with this email has already been registered.'),
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

  void addUserToDB(String userId) async {
    databaseReference.child(userId).set(
      {
        "email": userProfile.email,
        "password": userProfile.password,
        "firstName": userProfile.firstName,
        "lastName": userProfile.lastName,
        "isMale": userProfile.isMale,
        "driverLicenseNumber": userProfile.driverLicenseNumber,
        "city": userProfile.city,
        "state": userProfile.state,
        "ridesTaken": 0,
        "ridesGiven": 0,
        "aboutMe": "",
        "program": userProfile.program,
        "profilePic": "",
        "facebookUserId": userProfile.facebookUserId,
        "university": userProfile.university,
        "reviews": userProfile.reviews,
        "paymentMethod": userProfile.paymentMethod.toJson(),
        "userVehicles": userProfile.userVehicles.length > 0 ? [userProfile.userVehicles[0].toJson()] : [],
      }
    );
  }

  void showEmptyFieldAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(61, 191, 165, 100),
          title: new Text('Empty Fields'),
          content: new Text('Fields cannot be empty', style: new TextStyle(color: Colors.black),),
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

  void showInformation(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(61, 191, 165, 100),
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Okay', style: new TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }
}