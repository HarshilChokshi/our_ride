import 'package:flutter/material.dart';
import '../contants.dart';
import '../widgets/our_ride_title.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginState();
  }
}

class LoginState extends State<LoginScreen> {

  final formKey = new GlobalKey<FormState>();
  bool keepUserSignedIn = false;

  String emailAddress;
  String password;

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(left: 50, right: 50, top: 100),
      child: new Form(
        key: formKey,
        child: new Column(
          children: <Widget>[
            new OurRideTitle(),
            new Container(margin: EdgeInsets.only(bottom: 175)),
            createEmailTextField(),
            new Container(margin: EdgeInsets.only(bottom: 10)),
            createPasswordTextField(),
            new Container(margin: EdgeInsets.only(bottom: 10)),
            createSubmitButton(),
            new Container(margin: EdgeInsets.only(bottom: 20)),
            createKeepMeSignedInButton(),
            createSignUpButton(),
          ],
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
        emailAddress = value;
      },
    );
  }

  Widget createPasswordTextField() {
   return new TextFormField(
     style: new TextStyle(fontSize: 14, color: Color.fromARGB(255, 255, 255, 255)),
      decoration: new InputDecoration(
        hintText: 'Password must contain at least 8 characters',
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
        password = value;
      },
    );
  }

  Widget createSubmitButton() {
   return new SizedBox(
     width: double.infinity, 
     child: new RaisedButton(
      child: new Text(
        'LOGIN',
        style: new TextStyle(color: Colors.white),
      ),
      onPressed: () {
         if(formKey.currentState.validate() && verifyUser()) {
           formKey.currentState.save();
         }
      },
      color: appThemeColor,
    )
   );
  }

  Widget createKeepMeSignedInButton() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
       new Checkbox(
         value: keepUserSignedIn,
         onChanged: (bool value) {
          setState(() {
            keepUserSignedIn = value;
          });
         },
         activeColor: appThemeColor,
         checkColor: Colors.white,
       ),
       new Text(
         'Keep me logged in',
         style: TextStyle(
           color: Colors.white,
         ),
       ),
      ],
    );  
  }

  Widget createSignUpButton() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
       new Text(
         'Don\'t have an account?',
         style: TextStyle(
           color: Colors.white,
         ),
       ),
       new SizedBox(
         height: 20.0,
         child: new FlatButton(
            child: new Text(
              'Sign up!',
              style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
            
            },
            color: Colors.transparent,
          ),
       ),
      ],
    );  
  }

  bool verifyUser() {
    //need to implement
    return true;
  }
}

