

import 'package:flutter/material.dart';
import 'package:our_ride/src/contants.dart';

class ListViewFilter extends StatefulWidget{
  ListViewFilter({Key key}) : super(key: key);

  @override
  _ListViewFilterState createState() => _ListViewFilterState();
}

class _ListViewFilterState extends State<ListViewFilter>{
      //define default filter options state
  Map<String, dynamic> _filterOptions = {
    'from': null,
    'to': null,
    'datetime': null,
    'sameGender': false
  };

  bool _isFilterEmpty = true;
  bool _isFilterExpanded = false;

  @override
  void initState(){
    super.initState();
    this._filterOptions['sameGender'] = false;
    this._isFilterEmpty = true;
    this._isFilterExpanded = false;
  }

  //funtions needed
  void _toggleExpand(){
    setState(() {
      _isFilterExpanded = (this._isFilterExpanded != null && this._isFilterExpanded) ? false : true;
    });
  }

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: _toggleExpand,
      child: Container(
        width: double.infinity,
        color: appThemeColor,
        // height: this._isFilterExpanded != null && this._isFilterExpanded ? 500 : 800,
        height: 200,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _createLocationTextfield('From'),
              _createLocationTextfield('To'),
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                color: Colors.black,
                height: 50,
                child: Row(
                  children: <Widget>[
                    Switch()
                  ]
                )
              ),
              _filterOptionsButton()
            ],
          )
        )
    );
  }

  Widget _createLocationTextfield(String hintText) {
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
          // contentPadding: EdgeInsets.all(10),
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

  Widget _toggleClass() {
    return Switch();
  }

  Widget _filterOptionsButton(){
    return 
      Container(
        width: double.infinity,
        color: Colors.transparent,
        child: Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
          size: 30.0
        ),
      );
  }
}