import 'package:flutter/material.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/models/user_profile.dart';
import 'package:our_ride/src/screens/user_info_screen.dart';
import 'package:our_ride/src/widgets/our_ride_title.dart';
import 'package:flutter/cupertino.dart';

class PaymentInfoScreen extends StatefulWidget {
  UserProfile userProfile;

  PaymentInfoScreen(this.userProfile);
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new PaymentInfoState(userProfile);
  }
}


class PaymentInfoState extends State<PaymentInfoScreen> {

  UserProfile userProfile;
  final formKey = new GlobalKey<FormState>();

  PaymentInfoState(this.userProfile);

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
                createTextFromField('Card Holder Name'),
                new Container(margin: EdgeInsets.only(bottom: 10)),
                createTextFromField('Card Number'),
                new Container(margin: EdgeInsets.only(bottom: 10)),
                createTextFromField('Expire Date: mm/yy'),
                new Container(margin: EdgeInsets.only(bottom: 10)),
                createTextFromField('CVV'),
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
        if(hintText == 'Card Holder Name') {
          userProfile.paymentMethod.cardHolderName = value;
        } else if(hintText == 'Card Number') {
          userProfile.paymentMethod.cardNumber = value;
        } else if(hintText == 'Expire Date: mm/yy') {
          userProfile.paymentMethod.expireDate = value;
        } else if(hintText == 'CVV') {
            userProfile.paymentMethod.cvv = value;
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
                builder: (context) => UserInfoScreen(userProfile)
          )); 
        },
        color: appThemeColor,
      )
    )
    );
  }
}