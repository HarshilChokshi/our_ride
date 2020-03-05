import 'package:flutter/material.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/models/review.dart';
import 'package:our_ride/src/widgets/app_bottom_navigation_bar.dart';
import 'package:our_ride/src/widgets/reviews_list.dart';

class DriverReviewsScreen extends StatefulWidget {
  List<Review> reviews;
  String driverName;

  DriverReviewsScreen(this.reviews, this.driverName);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new DriverReviewsState(reviews, driverName);
  }

}

class DriverReviewsState extends State<DriverReviewsScreen> {
  List<Review> reviews;
  String driverName;

  DriverReviewsState(this.reviews, this.driverName);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new ReviewsList(reviews),
      appBar: new AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          }),
        backgroundColor: appThemeColor,
        title: new Text(
          driverName + '\'s Reviews',
          style: new TextStyle(
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}