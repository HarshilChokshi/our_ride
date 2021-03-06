import 'dart:math' as math;

import 'package:our_ride/src/DAOs/GoogleMaps.dart';
import 'package:flutter/material.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/widgets/TF_autocomplete.dart';
import 'package:our_ride/src/widgets/DT_picker.dart';
import 'package:our_ride/src/screens/rideshare_list_screen.dart';
import 'package:our_ride/src/models/rideshare_model.dart';

class RideshareSearchFilter extends StatefulWidget{
  
  RideshareListState parentListStateRef;

  RideshareSearchFilter({
    Key key,
    @required
    this.parentListStateRef
  }) : super(key: key);
  @override

  _RideshareSearchFilterState createState() => _RideshareSearchFilterState(
    parentListStateRef
  );
}

class _RideshareSearchFilterState extends State<RideshareSearchFilter>{
  _RideshareSearchFilterState(this.parentListStateRef);

  RideshareListState parentListStateRef;
  Map<String, dynamic> _filterOptions = {
    'from': null,
    'to': null,
    'date': null,
    'time': null,
    'sameGender': false
  };

  @override
  void initState(){
    super.initState();
    this._filterOptions['sameGender'] = false;
  }

  //state change functions
  void _onToggle(bool val) => {
    setState(() {
      this._filterOptions['sameGender'] = val;
    })
  };

  void _onStateDictChange(String field, dynamic value) => {
    setState(() {
      this._filterOptions[field] = value;
    })
  };

  @override
  Widget build(BuildContext context){
    return CollapsingFilter(
      genderValue: this._filterOptions['sameGender'],
      fromValue: this._filterOptions['from'],
      toValue: this._filterOptions['to'],
      dateState: this._filterOptions['date'],
      parentListStateRef: this.parentListStateRef,
      timeState: this._filterOptions['time'],
      
      onStateDictChange: _onStateDictChange,
      onGenderToggle: _onToggle
    );
  }
}

//custom collapsable sliver
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, 
      double shrinkOffset, 
      bool overlapsContent) 
  {
    return SizedBox.expand(child: child);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class CollapsingFilter extends StatelessWidget {
  CollapsingFilter({
    Key key,
    this.fromValue,
    this.toValue,
    this.genderValue,
    this.onGenderToggle,
    this.onStateDictChange,
    this.dateState,
    this.parentListStateRef,
    this.timeState
  }) : super(key: key);
  GlobalKey<FormState> testFormKey = GlobalKey<FormState>();
  TextEditingController from = TextEditingController();
  TextEditingController to = TextEditingController();

  RideshareListState parentListStateRef;
  bool genderValue;
  Map<String, dynamic> fromValue, toValue;
  String  timeState, dateState;
  final Function onGenderToggle, onStateDictChange;

  //composable widgets
  Widget _createTextSearchField(String hintText, {dynamic prefix = Icons.search}) {
  return Container(
    height: 40,
    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
    decoration: BoxDecoration(
      color: Color.fromRGBO(61, 191, 165, 100),
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(10)) 
    ),
    child: TextFormField(
      style: TextStyle(fontSize: 14, color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: Icon(
            prefix,
            color: Colors.white,
          ), // icon is 48px widget.
        ),
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14, color: Colors.white),
        errorStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: Colors.transparent,
        border: InputBorder.none
      )
  )
  );
}
  
  Widget _createSubmitButton(BuildContext context) {
  return Container(
    height: 40,
    width: double.infinity,
    color: appThemeColor,
    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
    child:  RaisedButton(
      child: new Text(
        'Seach Rideshares',
        style: new TextStyle(color: Colors.white),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.white)
      ),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      onPressed: () {
        showAlertDialog(BuildContext context, String title, String content) {
          // set up the AlertDialog
          AlertDialog alert = AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            title: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Icon(
                    Icons.error,
                    color: Colors.white,
                  ),
                ),
                Text(
                  title,
                  // "Search Input Error",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ],
              ),
            content: Text(
              content,
              // "Please fillout all search fields.",
              style: TextStyle(
                color: Colors.white
              ),
            ),
            backgroundColor: appThemeColor
          );

          // show the dialog
          showDialog(
            context: context,
            builder: (context) {
              return Center(child: alert);
            },
          );
        }

        bool isNullOrEmpty(Object o) => o == null || "" == o;

        if (fromValue == null || toValue == null || isNullOrEmpty(timeState) || isNullOrEmpty(dateState) ){
          showAlertDialog(context, "Search Input Error", "Please fillout all search fields.");
        }
        // else{
        //   int toSec(int hour, int min){ return hour*60*60 + min*60;}
        //   var tState = timeState.split(":");
        //   // var day1= DateTime.now().toUtc();
        //   // // var day2 = DateTime.parse(dateState + timeState).toUtc();
          // // var timeDiff = 86400 - toSec(DateTime.now().hour, DateTime.now().minute)+ toSec(int.parse(tState[0]), int.parse(tState[1]));
          // print("showing datetime");
          // print(DateTime.parse(dateState + " " + timeState + ":00"));
          // print(DateTime.parse(dateState + " " + timeState + ":00").toString());
          // // print(DateTime.parse(dateState + " " + timeState + ":00").difference(DateTime.now()).toString());

          // double dayDifference = double.parse(DateTime.parse(dateState + " " + timeState + ":00").difference(DateTime.now()).toString());
          // if(dayDifference <= Duration(days: 1) && timeDiff < 86400) {
          // if(dayDifference < 24.0){
          // if(true){
          //   showAlertDialog(context, "Time Booking Error", "Please pick a time 24 hours after now.");
          // } else{
        else{
          this.parentListStateRef.updateFuture({
            "from": fromValue,
            "to": toValue,
            "time": timeState,
            "date": dateState,
            "gender": genderValue
          });
        }
      },
      elevation: 0,
      color: Colors.transparent
      )
  );
  }

  Widget _createToggleWithDescription(String description, bool isToggled, Function _onChanged, {dynamic prefix = Icons.search}) {
    return Container(
      height: 40,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10)) 
      ),
      child:  SwitchListTile(
        title: Text(
          description,
          style: TextStyle(fontSize: 14, color: Color.fromRGBO(53, 154, 131, 100), fontWeight: FontWeight.w700),
        ),
        value: isToggled,
        onChanged: _onChanged,
        secondary: Icon(prefix, color: Colors.white),
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 120.0,
        maxHeight: 260.0,
        child: Container(
            color: appThemeColor,
            child: Center(
              child: Form(
                key: this.testFormKey,
                child: Column(
                children: <Widget>[
                  TFWithAutoComplete(
                    typeAheadController: from,
                    hintText: (fromValue != null ? fromValue["description"] : 'From'),
                    prefix:Icons.edit_location,
                    suggestionsCallback: (prefixSearch) async { //this should be async
                      return await GoogleMapsHandler.fetchLocationSuggestions(prefixSearch);
                    },
                    itemBuilder: (context, suggestion) {
                      return Container(
                            // decoration: BoxDecoration(color: appThemeColor),
                            child:  ListTile(
                                leading: Icon(Icons.location_searching),
                                title: Text(suggestion['description']),
                                // subtitle: Text('\$${suggestion['price']}'),
                      ),
                          );  
                    },
                    onSuggestionsSelected: (suggestion) {
                      onStateDictChange('from', {'description': suggestion['description'], 'placeId': suggestion['id']});
                      from.text = suggestion['description'];
                    }
                  ),
                  TFWithAutoComplete(
                    typeAheadController: to,
                    hintText:(toValue != null ? toValue["description"] : 'To'),
                    prefix:Icons.edit_location,
                    suggestionsCallback: (prefixSearch) async { //this should be async
                      return await GoogleMapsHandler.fetchLocationSuggestions(prefixSearch);
                    },
                    itemBuilder: (context, suggestion) {
                      return Container(
                            child:  ListTile(
                                leading: Icon(Icons.location_searching),
                                title: Text(suggestion['description']),
                      ),
                          );
                    },
                    onSuggestionsSelected: (suggestion) {
                      onStateDictChange('to', {"description": suggestion['description'], "placeId": suggestion['id']});
                      to.text = suggestion['description'];
                    }
                  ),
                  DateTimeFilter(
                    updateDateTime: onStateDictChange,
                    dateState: dateState,
                    timeState: timeState,
                  ),
                  _createToggleWithDescription("Same Gender Only", this.genderValue, this.onGenderToggle, prefix:Icons.person),
                  _createSubmitButton(context),
                ]
              )
              ),
            ),
        ),
      ) ,
    );
  }
}