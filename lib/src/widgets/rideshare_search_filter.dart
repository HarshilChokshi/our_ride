import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:our_ride/src/contants.dart';

class RideshareSearchFilter extends StatefulWidget{
  RideshareSearchFilter({Key key}) : super(key: key);
    Map<String, dynamic> _filterOptions = {
    'from': null,
    'to': null,
    'datetime': null,
    'sameGender': false
  };

  bool _isFilterEmpty = true;
  bool _isFilterExpanded = false;

  @override
  _RideshareSearchFilterState createState() => _RideshareSearchFilterState();
}

class _RideshareSearchFilterState extends State<RideshareSearchFilter>{
      //define default filter options state

  @override
  void initState(){
    super.initState();
    widget._filterOptions['sameGender'] = false;
    widget._isFilterEmpty = true;
    widget._isFilterExpanded = false;
  }

  @override
  Widget build(BuildContext context){
    return CollapsingFilter();
  }
}

//composable widgets
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
  //generic makeHeader function
  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: new _SliverAppBarDelegate(
        minHeight: 60.0,
        maxHeight: 200.0,
        child: Container(
            color: Colors.lightBlue, child: Center(child:
                Text(headerText))),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 60.0,
        maxHeight: 200.0,
        child: Container(
            color: appThemeColor,
            child: Center(
              child: Column(
                children: <Widget>[
                    _createLocationTextfield('From'),
                  _createLocationTextfield('To'),
                ]
              )
            ),
        ),
      ) ,
    );
  }
}