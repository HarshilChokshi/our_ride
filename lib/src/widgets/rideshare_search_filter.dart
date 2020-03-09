import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/widgets/TF_autocomplete.dart';
import 'package:our_ride/src/widgets/DT_picker.dart';


class RideshareSearchFilter extends StatefulWidget{
  RideshareSearchFilter({Key key}) : super(key: key);
  @override
  _RideshareSearchFilterState createState() => _RideshareSearchFilterState();
}

class _RideshareSearchFilterState extends State<RideshareSearchFilter>{
  Map<String, dynamic> _filterOptions = {
    'from': null,
    'to': null,
    'date': null,
    'time': null,
    'sameGender': false
  };

  bool _isFilterEmpty = true;
  bool _isFilterExpanded = false;
      //define default filter options state

  @override
  void initState(){
    super.initState();
    this._filterOptions['sameGender'] = false;
    this._isFilterEmpty = true;
    this._isFilterExpanded = false;
  }

  //state change functions
  void _onToggle(bool val) => {
    setState(() {
      this._filterOptions['sameGender'] = val;
    })
  };

  void _onStateDictChange(String field, String location) => {
    setState(() {
      this._filterOptions[field] = location;
    })
  };

  @override
  Widget build(BuildContext context){
    return CollapsingFilter(
      genderValue: this._filterOptions['sameGender'],
      fromValue: this._filterOptions['from'],
      toValue: this._filterOptions['to'],
      dateState: this._filterOptions['date'],
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
    this.timeState
  }) : super(key: key);
  GlobalKey<FormState> testFormKey = GlobalKey<FormState>();
  TextEditingController from = TextEditingController();
  TextEditingController to = TextEditingController();

  bool genderValue;
  String fromValue, toValue, timeState, dateState;
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
    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
    child:  RaisedButton(
      child: new Text(
        'Seach Rideshares',
        style: new TextStyle(color: Colors.white),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      onPressed: () {
        showAlertDialog(BuildContext context) {
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
                  "Search Error",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ],
              ),
            content: Text(
              "Make sure all fields are fillied out!",
              style: TextStyle(
                color: Colors.white
              ),
            ),
            backgroundColor: Color.fromRGBO(61, 191, 165, 100),
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

        if (isNullOrEmpty(fromValue) || isNullOrEmpty(toValue) || isNullOrEmpty(timeState) || isNullOrEmpty(dateState) ){
          showAlertDialog(context);
        }
        else{
          //fetch listview resuults
        }
      },
      elevation: 0,
      color: Color.fromRGBO(61, 191, 165, 100),
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
                    hintText: (fromValue != null ? fromValue : 'From'),
                    prefix:Icons.edit_location,
                    suggestionsCallback: (prefixSearch) async { //this should be async
                      return await fetchLocationSuggestions(prefixSearch);
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
                      onStateDictChange('from', suggestion['description']);
                      from.text = suggestion['description'];
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => ProductPage(product: suggestion)
                      // ));
                    }
                  ),
                  TFWithAutoComplete(
                    typeAheadController: to,
                    hintText:(toValue != null ? toValue : 'To'),
                    prefix:Icons.edit_location,
                    suggestionsCallback: (prefixSearch) async { //this should be async
                      return await fetchLocationSuggestions(prefixSearch);
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
                      onStateDictChange('to', suggestion['description']);
                      to.text = suggestion['description'];
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => ProductPage(product: suggestion)
                      // ));
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

//async call to google maps api
Future<List> fetchLocationSuggestions(String prefixText) async{
  const kGoogleAPIKey = "AIzaSyCoasYE-PQfb6PBIVR8d4M9vxx53pNiNos";
  String vettedPrefix = prefixText.trim().replaceAll(" ", "+");

  const String base = "https://maps.googleapis.com/maps/api/place/autocomplete/json?";
  String params = "input=$vettedPrefix&key=$kGoogleAPIKey&language=en";
  final resp = await http.get(base+params);
  
  if (resp.statusCode == 200) {
    return loadSuggestions(json.decode(resp.body));
  } else {
    return [];
  }
}

List<Map> loadSuggestions(dynamic results){
  List<Map> suggestions = new List<Map>();
  int suggestionInt = 10;
  for(var prediction in results['predictions']){
    suggestions.add({
      'description':prediction['description'],
      'id':prediction['id'],
    });
    if(--suggestionInt == 0) break;
  }
  return suggestions;
}