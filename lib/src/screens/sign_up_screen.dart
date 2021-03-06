import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:our_ride/src/models/user_profile.dart';
import 'package:our_ride/src/screens/car_details_screen.dart';
import 'package:our_ride/src/screens/payment_info_screen.dart';
import 'package:our_ride/src/screens/user_info_screen.dart';
import '../contants.dart';
import '../widgets/our_ride_title.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' show get;
import 'package:flutter/cupertino.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SignUpState();
  }
}


class SignUpState extends State<SignUpScreen> {

  final formKey = new GlobalKey<FormState>();
  String dropDownValue = 'Male';
  bool riderSelected = true;
  bool facebookAccountLinked = false;
  UserProfile userProfile;

  SignUpState() {
    userProfile = new UserProfile();
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
      resizeToAvoidBottomPadding: true,
      body: new SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.only(left: 50, right: 50, top: 20),
          child: new Form(
            key: formKey,
            child: new Column(
              children: <Widget>[
                new OurRideTitle(),
                new Container(margin: EdgeInsets.only(bottom: 100)),
                createEmailTextField(),
                new Container(margin: EdgeInsets.only(bottom: 10)),
                createPasswordTextField(),
                new Container(margin: EdgeInsets.only(bottom: 10)),
                createNameTextField(true),
                new Container(margin: EdgeInsets.only(bottom: 10)),
                createNameTextField(false),
                new Container(margin: EdgeInsets.only(bottom: 10)),
                createGenderDropDown(),
                new Container(margin: EdgeInsets.only(bottom: 10)),
                createLinkFacebookAccount(),
                new Container(margin: EdgeInsets.only(bottom: 10)),
                createDriversLicenseTextField(),
                new Container(margin: EdgeInsets.only(bottom: 10)),
                createRiderDriverOption(),
                createNextButton(),
              ],
            ),
          ),
        )
      ),
     ),
   );
  }

  Widget createEmailTextField() {
    return new TextFormField(
      style: new TextStyle(fontSize: 14, color: Color.fromARGB(255, 255, 255, 255)),
      decoration: new InputDecoration(
        hintText: 'University Email Address',
        hintStyle: new TextStyle(fontSize: 14, color: Color.fromARGB(150, 255, 255, 255)),
        errorStyle: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: new Color.fromARGB(20, 211, 211, 211),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if(!value.endsWith('uwaterloo.ca')) {
          return 'Must be a valid unviersity of waterloo email';
        }

        return null;
      },
      onSaved: (String value) {
        userProfile.email = value;
      },
    );
  }

  Widget createPasswordTextField() {
   return new TextFormField(
     style: new TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
      decoration: new InputDecoration(
        hintText: 'Password',
        hintStyle: new TextStyle(fontSize: 14, color: Color.fromARGB(150, 255, 255, 255)),
        errorStyle: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: new Color.fromARGB(20, 211, 211, 211),
      ),
      obscureText: true,
      validator: (String value) {
        if(value.length < 8) {
          return 'Password must contain at least 8 characters';
        }

        return null;
      },
      onSaved: (String value) {
        userProfile.password = value;
      },
    );
  }

  Widget createNameTextField(bool isFirstName) {
    String hintText =  isFirstName ? 'First Name' : 'Last Name';
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
        if(isFirstName) {
          userProfile.firstName = value;
        } else {
          userProfile.lastName = value;
        }
      },
      validator: (String value) {
        if(value.isEmpty) {
          return 'You have to enter a value for this';
        }
        return null;
      },
    );
  }


  Widget createGenderDropDown() {
    return new Row(
      children: <Widget>[
          Theme(
          data: Theme.of(context).copyWith(
              canvasColor: appThemeColor,
          ),
          child: new Expanded(
              child: new DropdownButton<String>(
                value: dropDownValue,
                icon: new Icon(Icons.arrow_drop_down),
                iconEnabledColor: Colors.white,
                iconSize: 40,
                isExpanded: true,
                style: new TextStyle(color: Colors.white),
                onChanged: (String newValue) {
                  setState(() {
                    dropDownValue = newValue;
                  });
                },
                items: <String>['Male', 'Female']
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: new TextStyle(
                          backgroundColor: new Color.fromARGB(20, 211, 211, 211),
                          )
                      ),
                      
                    );
                  })
                  .toList(),
              ),
            ),
        ),
        new IconButton(
          icon: new Icon(
            Icons.info,
            color: Colors.white,
          ),
          onPressed: () {
            showInformation(
              'Gender Info',
              'OURide allows riders to request ridershares with their own gender.'
            );
          }
        ),
      ]
    );
  }

  Widget createRiderDriverOption() {
    var grayFadedColor = new Color.fromARGB(20, 211, 211, 211);
    var riderButtonColor = riderSelected ? appThemeColor :  grayFadedColor;
    var driverButtonColor = riderSelected ? grayFadedColor : appThemeColor;

    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new FlatButton(
          child: new Text(
            'Rider',
            style: new TextStyle(color: Colors.white),
          ),
          onPressed: () {
            setState(() {
              riderSelected = true;
            });
          },
          color: riderButtonColor,
        ),
        new FlatButton(
          child: new Text(
            'Driver',
            style: new TextStyle(color: Colors.white),
          ),
          onPressed: () {
            setState(() {
              riderSelected = false;
            });
          },
          color: driverButtonColor,
        ),
      ],
    );
  }


  Widget createDriversLicenseTextField() {
    return  !riderSelected ?  new TextFormField(
      style: new TextStyle(fontSize: 14, color: Color.fromARGB(255, 255, 255, 255)),
      decoration: new InputDecoration(
        hintText: 'Enter Your Driver\'s License Number',
        hintStyle: new TextStyle(fontSize: 14, color: Color.fromARGB(150, 255, 255, 255)),
        errorStyle: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: new Color.fromARGB(20, 211, 211, 211),
      ),
      validator: (String value) {
        if(value.isEmpty) {
          return 'You have to enter a valid driver\'s license';
        }
        if(!licenseIsValid(value)) {
          return 'Driver\'s license not valid';
        }
        return null;
      },
      onSaved: (String value) {
        userProfile.driverLicenseNumber = value;
      },
    ) : new Container();
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

          if(!facebookAccountLinked) {
            showFacebookAlert(false);
            return;
          }

          formKey.currentState.save();
          userProfile.isMale = dropDownValue == 'Male' ? true : false;

          if(userProfile.driverLicenseNumber.isEmpty) {
            Navigator.push(
                context, 
                CupertinoPageRoute(
                  builder: (context) => PaymentInfoScreen(userProfile)
            )); 
          } else {
             Navigator.push(
                context, 
                CupertinoPageRoute(
                  builder: (context) => CarDetailsScreen(userProfile)
            ));            
          }
        },
        color: appThemeColor,
      )
    )
    );
  }

  bool licenseIsValid(String licenseNumber) {
    // Check if license is valid from API
    return true;
  }

  Widget createLinkFacebookAccount() {
    return Row(
      children: <Widget>[
      new Expanded(
        child:  RaisedButton(
            child: new Text(
              'Link Facebook',
              style: new TextStyle(color: Colors.white),
            ),
            onPressed: () {  
              didUserLogIntoFacebook();
            },
            color: new Color.fromARGB(255, 56, 103, 178),
          )
        ),
        new IconButton(
          icon: new Icon(
            Icons.info,
            color: Colors.white,
          ),
          onPressed: () {
            showInformation(
              'Facebook Account Linking',
              'OURide needs your Facebook account so other riders/drivers can view your profile.'
            );
          }
        )
      ],
    );
  }


  void didUserLogIntoFacebook() async {
    final FacebookLogin facebookLogin = FacebookLogin();
    final FacebookLoginResult result = await facebookLogin.logIn(<String>['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        facebookAccountLinked = true;
        final token = result.accessToken.token;
        final graphResponse = await get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
        final profile = jsonDecode(graphResponse.body);
        userProfile.facebookUserId = profile['id'].toString();
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
    }
    
    showFacebookAlert(facebookAccountLinked);
  }

  void showFacebookAlert(bool didUserLogin) {
    String message = facebookAccountLinked ? 'Successfully linked Facebook Account' : 'You must link your Facebook account in order to use the application';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(61, 191, 165, 100),
          title: new Text('Facebook Account Linking'),
          content: new Text(message),
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