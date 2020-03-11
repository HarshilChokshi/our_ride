import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:our_ride/src/DAOs/RideRequestsCreator.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/models/rideshare_model.dart';
import 'package:our_ride/src/models/rideshare_model.dart';
import 'package:our_ride/src/screens/rideshare_list_screen.dart';
import 'package:our_ride/src/screens/user_profile_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:our_ride/src/screens/view_rideshare_details_screen.dart';

class RideshareSearchResult extends StatefulWidget{
  // final Function addRide; 
  Rideshare rideShareData;
  RideshareListState parentListStateRef;

  RideshareSearchResult({
    @required
    this.rideShareData,
    this.parentListStateRef,
  });

  _RideshareSearchResultState createState() => _RideshareSearchResultState();
}

class _RideshareSearchResultState extends State<RideshareSearchResult>{
  _RideshareSearchResultState();

  //textformatters
  String nameFormatter(){
    return "${widget.rideShareData.driverFirstName}. ${widget.rideShareData.driverLastName[0]}";
  }

  String timeFormatter(){
      return "${widget.rideShareData.rideTime.format(context)}";
  }

  String fromLocationFormatter(){
      return "${widget.rideShareData.locationPickUp.description}";
  }

  String toLocationFormatter(){
      return "${widget.rideShareData.locationDropOff.description}";
  }

  String seatsLeft(){
    int seatsLeft = widget.rideShareData.capacity - widget.rideShareData.riders.length;
    return  seatsLeft == 1 ? "$seatsLeft seat left" : "$seatsLeft seats left";
  }

  String priceFormatter(){
    return "\$ ${double.parse((widget.rideShareData.price).toStringAsFixed(2))}";
  }

  AssetImage getImage(){
    String path = widget.rideShareData.driverProfilePic == 'Exists' ? 'assets/images/' +
      widget.rideShareData.driverFirstName + 
      '_' +
      widget.rideShareData.driverLastName +
      '.png'
      :
      'assets/images/default-profile.png';
    return AssetImage(path);
  }

  //composable widgets
  Widget drawCircle(double size, Color color){
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color
      ),
    );
  }

  Widget circleColumn(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        drawHollow(8,Color.fromRGBO(61, 191, 165, 100)),
        SizedBox(height: 3,),
        drawCircle(4, Color.fromRGBO(61, 191, 165, 100)),
        SizedBox(height: 3,),
        drawCircle(4, Color.fromRGBO(61, 191, 165, 100)),
        SizedBox(height: 3,),
        drawCircle(4, Color.fromRGBO(61, 191, 165, 100)),
        SizedBox(height: 3,),
        drawCircle(4, Color.fromRGBO(61, 191, 165, 100)),
        SizedBox(height: 3,),
        drawHollow(8, Color.fromRGBO(61, 191, 165, 100))

      ]
    );
  }
  
  Widget drawHollow(double size, Color color){
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color),
    );
  }

  Widget leftPortion(){
    return Container(
      height: double.infinity,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 40,
            backgroundImage: getImage(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 3),
            child: Text(
              nameFormatter(),
              overflow: TextOverflow.clip,
              maxLines: 1,
              style: TextStyle(
                color: Color.fromRGBO(84, 84, 84, 100),
                fontSize: 14,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              timeFormatter(),
              style: TextStyle(
                color: Color.fromRGBO(84, 84, 84, 100),
                fontSize: 16,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rightPortion(){
    return Container(
      // color: Colors.red,
      height: 135,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 95,
            // color: Colors.orange, 
            child:
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //TOP PORTION --> to, from location
                Container(
                  height:80,
                // color: Colors.lime,
                child:
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 30,
                      ),
                      circleColumn(),
                      Container(
                        // color: Colors.blue,
                        width: 250,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 0, 0, 3),
                              child: Text(
                                fromLocationFormatter(),
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Color.fromRGBO(84, 84, 84, 100),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                            ),
                            drawLine(180, 1),
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 3, 0, 0),
                              child: Text(
                                toLocationFormatter(),
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Color.fromRGBO(84, 84, 84, 100),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                            ),
                          ],
                        )
                      )
                    ]
                  )
                ),
            ],
          )
         ),
         Container(
           height: 40,
           child: //BOTTOM PORTION --> seats left, price of ride
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child:Icon(
                          Icons.person,
                          size: 25,
                          color: Color.fromRGBO(84, 84, 84, 100),
                        ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 3, 0, 0),
                      child: 
                        Text(
                          seatsLeft(),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                            color: Color.fromRGBO(84, 84, 84, 100),
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    Expanded(
                      child: Container(

                      ),
                    ),
                     Padding(
                        padding: EdgeInsets.fromLTRB(8, 3, 10, 0),
                        child: 
                          Text(
                            priceFormatter(),
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              color: Color.fromRGBO(84, 84, 84, 100),
                              fontSize: 24,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                  ],
                )
         )
        ],
      ),
    );
  }

  Widget drawLine(double width, double height){
    return Container(
      width: width,
      height: height,
      color: Color.fromRGBO(84, 84, 84, 60),
    );
  }

  @override
  Widget build(BuildContext context){
    return Material(child:Container(
      height: 140,
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2.0, // has the effect of softening the shadow
            spreadRadius: 2.0, // has the effect of extending the shadow
            offset: Offset(
              0,// 10.0, // horizontal, move right 10
              2.0, // vertical, move down 10
            ),
          )
        ],
      ),
      child: Slidable(
        // controller: slidableController,
        actionPane: SlidableDrawerActionPane(),
        child: Container(
          height: double.infinity,
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 3,
                child:  GestureDetector(
                  onTap: () { //link to user profile
                  // print("left");
                  Navigator.push(
                    context, 
                    CupertinoPageRoute(
                      builder: (context) => UserProfileScreen(widget.rideShareData.driverId, false, null, false)
                  ));
                  },
                  child: leftPortion(),
                  ),
                ),
              drawLine(1, 115),
              Expanded(
                flex: 8,
                child:  GestureDetector(
                  onTap: () { //link to ride details
                  print("pushed");
                      Navigator.push(
                        context, 
                        CupertinoPageRoute(
                          builder: (context) => ViewRideshareDetailsScreen(
                            widget.rideShareData.driverId,
                            widget.rideShareData.riders,
                            widget.rideShareData.car,
                            widget.rideShareData.luggage,
                            false,
                            widget.rideShareData,
                            widget.parentListStateRef.rider_id,
                          )
                      ));
                  },
                  child: rightPortion(),
                  ),
                ),
            ],
          )
        ),
        actions: <Widget>[
          IconSlideAction(
            foregroundColor: Colors.white,
            caption: 'Request Ride',
            color: appThemeColor,
            iconWidget: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onTap: () {
              requestToJoinRide();
            },
          ),
        ],
      )
    ));
  }

    void requestToJoinRide() async {
      RideRequestsCreator.create(widget.rideShareData, widget.parentListStateRef.rider_id);
    }
}