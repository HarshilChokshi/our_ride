import 'package:flutter/material.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/screens/login_screen.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'OURide',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
      },
        theme: ThemeData(
          accentColor: Color.fromRGBO(61, 191, 165, 100)
        )
    );
  }
}