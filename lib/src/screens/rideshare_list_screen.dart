import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/widgets/app_bottom_navigation_bar.dart';
import 'package:our_ride/src/widgets/rideshare_search_filter.dart';
import 'package:our_ride/src/widgets/main_rideshare_list.dart';


class RideshareListScreen extends StatefulWidget {
  String rider_id;

  RideshareListScreen(String rider_id) {
    this.rider_id = rider_id;
  }

  @override
  State<StatefulWidget> createState() {
    return new RideshareListState(rider_id);
  }
}

class RideshareListState extends State<RideshareListScreen> {
  String rider_id;

  RideshareListState(String rider_id) {
    this.rider_id = rider_id;
  }

   GlobalKey<FormState> testFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appThemeColor,
        elevation: 0,
        title: Text(
          'Rideshares',
          style: TextStyle(
              fontSize: 24.0,
              color: Colors.white,
            ),
          ),
        ),
      body: CustomScrollView(
          slivers: <Widget>[
            RideshareSearchFilter(),
            SliverList(
              delegate: SliverChildListDelegate(
                [ 
                  RideshareSearchList(),
                ],
              ),
            ),
          ],
        ),
      bottomNavigationBar: AppBottomNavigationBar(rider_id, 0, true),
    );
  }
}

