
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:our_ride/src/contants.dart';

class FAQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ & Cancellation Policy'),
        backgroundColor: appThemeColor,
      ),
      body: Center(
          child: ListView(
            children: <Widget>[
              
              Container(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Rider Policy", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ListTile(leading: Text("1."), title: Text("Free cancellation up to 24 hours before ride"),),
              ListTile(leading: Text("2."), title: Text("If the rider cancel < 24 hours before your ride, you will be charged for half the ride + a \$3 fee"),),
              ListTile(leading: Text("3."), title: Text("If the rider does not show up, there is no refund and their profile will be marked"),),
            
              Container(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Driver Policy", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ListTile(leading: Text("1."), title: Text("Free cancellation if there are no riders or if > 48 hours before the ride"),),
              ListTile(leading: Text("2."), title: Text("If the rideshare is cancelled within 48 hours of the ride, the drivers will be responsible to pay a cancellation fee"),),
              ListTile(leading: Text("3."), title: Text("If the driver does not show up for a rideshare, they will be responsible to pay a cancellation fee and they will receive a profile badge"),),

              Container(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Explanation of Payment Process", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ListTile(leading: Text("1."), title: Text("Payments are automatically sent to the driver 24 hours after the ride unless issues are reported")),
            ],
          ),
        ),
    );
  }
}