import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:our_ride/src/DAOs/GoogleMaps.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/widgets/app_bottom_navigation_bar.dart';
import 'package:our_ride/src/widgets/rideshare_search_filter.dart';
import 'package:our_ride/src/widgets/rideshare_result.dart';
import 'package:our_ride/src/DAOs/SearchFilter.dart';
import 'package:our_ride/src/models/rideshare_model.dart';

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
  Future<List<Rideshare>> searchResultsFuture;
  GlobalKey<FormState> testFormKey = GlobalKey<FormState>();
  
  RideshareListState(String rider_id) {
    this.rider_id = rider_id;
  }

  @override
  void initState() {
    super.initState();
    this.searchResultsFuture = null;
  }

  void updateFuture(Map searchOptions) async {
      await GoogleMapsHandler.fetchLatLongForPlaceID(
        placeID: searchOptions["from"]["placeId"],
        callback: (double lat, double lng) {
          searchOptions["from"]["coordinates"] = [lat, lng];
        }
      );

      await GoogleMapsHandler.fetchLatLongForPlaceID(
        placeID: searchOptions["to"]["placeId"],
        callback: (double lat, double lng) {
          searchOptions["to"]["coordinates"] = [lat, lng];
        }
      );

      setState(() {
        this.searchResultsFuture = RideShareSearch.fetchRideshareFilterResults();
      });
  }

  @override
  Widget build(BuildContext context) {
    // print("Building Main Screen");
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
            RideshareSearchFilter(parentListStateRef: this,),
            //Results are rendered based on search
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  child: FutureBuilder(
                    future: searchResultsFuture,
                    builder: (BuildContext context, AsyncSnapshot<List<Rideshare>> snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          print("inside loading");
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 70),
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(
                                  backgroundColor: appThemeColor,
                                )
                              )
                            ],
                          );
                        }
                        else if (snapshot.hasData){
                          List<Widget> res = [];
                          for(Rideshare rideshare in snapshot.data){
                            res.add( RideshareSearchResult(rideShareData: rideshare));
                          }
                          return Column(
                            children: res,
                          ); 
                        }
                        else{
                          return Column(
                            children: [
                              Container(
                                height: 100,
                                width: 180,
                                child:  Center(child:Text(
                                  "Try searching for a ride!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color.fromRGBO(84, 84, 84, 100),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700
                                  ),
                                )),
                              )
                              
                            ]
                          ); 
                        }
                      },
                    )
                  )
                ]
              )
              ),
          ],
        ),
      bottomNavigationBar: AppBottomNavigationBar(rider_id, 0, true),
    );
  }

}
