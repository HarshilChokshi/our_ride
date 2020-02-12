import 'package:flutter/material.dart';
import 'package:our_ride/src/screens/login_screen.dart';
import 'package:our_ride/src/screens/rideshare_list_screen.dart';
import 'package:our_ride/src/screens/sign_up_screen.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'OURide',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/rideshareList': (context) => RideshareListScreen(),
      },
    );
  }
}