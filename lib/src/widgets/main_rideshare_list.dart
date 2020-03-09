import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/models/rideshare_model.dart';
import 'package:our_ride/src/models/car.dart';

import 'package:flutter/cupertino.dart';

class RideshareSearchList extends StatefulWidget{
  RideshareSearchList({
    this.rideShareData
  });

  // final Function addRide; 
  final Rideshare rideShareData;

  _RidershareSearchListState createState() => _RidershareSearchListState();
}

class _RidershareSearchListState extends State<RideshareSearchList>{
  _RidershareSearchListState();
  final SlidableController slidableController = SlidableController();


  '''
   String driverId,
    DateTime rideDate,
    TimeOfDay rideTime,
    int capacity,
    int numberOfCurrentRiders,
    double price,
    Car car,
    List<String> riders,
    bool isDriverMale,
    String driverUniversity,
    String driverProgram,
    String driverFirstName,
    String driverLastName,
    String driverProfilePic,
    Location locationPickUp,
    Location locationDropOff,
  '''
  var dummyData = Rideshare.fromDetails(
    "diver_id",
    'University, Toronto Waterloo',
    'Square One, Mississauga',
    DateTime.now(),
    TimeOfDay(hour: 14, minute: 69),
    4,
    2,
    23.0,
    Car.fromCarDetails( 'model x', 'make x','2011','324kblk1234iu'),
    ['rider 1', 'rider 2', 'rider 3'],
    false,
    'University of Waterloo',
    'Systems Design Engineering'
  );

  //textformatters
  String nameFormatter(String name){
    //need driver first and lastname
    return "${widget.rideShareData.driverFirstname}. ${widget.rideShareData.driverLastname[0]}";
  }

  // AssetImage getImage(String firstname, String lastname){
  //   String path = driverRideRequestsList[index].profilePic == 'Exists' ? 'assets/images/' +
  //     driverRideRequestsList[index].riderFirstName + 
  //     '_' +
  //     driverRideRequestsList[index].riderLastName +
  //     '.png'
  //     :
  //     'assets/images/default-profile.png';
  //   return AssetImage(path);
  // }



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
        drawHollow(8,Color.fromRGBO(84, 84, 84, 100)),
        SizedBox(height: 3,),
        drawCircle(4, Color.fromRGBO(84, 84, 84, 100)),
        SizedBox(height: 3,),
        drawCircle(4, Color.fromRGBO(84, 84, 84, 100)),
        SizedBox(height: 3,),
        drawCircle(4, Color.fromRGBO(84, 84, 84, 100)),
        SizedBox(height: 3,),
        drawCircle(4, Color.fromRGBO(84, 84, 84, 100)),
        SizedBox(height: 3,),
        drawHollow(8, Color.fromRGBO(84, 84, 84, 100))

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
            backgroundColor: Colors.black,
          ),
          Padding(
            padding: EdgeInsets.only(top: 3),
            child: Text(
              'Sarah',
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
              '12:30 pm',
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
                                'University Plaza, Waterloo, ON',
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
                                'Square One, Mississauga, asdf, asdf',
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
                          '4 seats left',
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
                            r'$ 15',
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
    return Container(
      height: 135,
      child: Slidable(
        controller: slidableController,
        actionPane: SlidableDrawerActionPane(),
        child: Container(
          height: double.infinity,
          color: Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 3,
                child:  GestureDetector(
                  onTap: () { //link to user profile
                      // Navigator.pushReplacement(
                      //   context, 
                      //   CupertinoPageRoute(
                      //     builder: (context) => UserProfileScreen(<ENTER DRIVER ID>, false, null, false)
                      // ));
                  },
                  child: leftPortion(),
                  ),
                ),
              drawLine(1, 115),
              Expanded(
                flex: 8,
                child:  GestureDetector(
                  onTap: () { //link to user profile
                    print("right");
                      // Navigator.pushReplacement(
                      //   context, 
                      //   CupertinoPageRoute(
                      //     builder: (context) => UserProfileScreen(userId, isRider, userProfile, true)
                      // ));
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
            caption: 'Add Ride',
            color: appThemeColor,
            iconWidget: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onTap: () => {},
          ),
        ],
      )
    );
  }
}