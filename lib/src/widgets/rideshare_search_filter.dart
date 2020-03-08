import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:our_ride/src/contants.dart';

typedef void onChanged(bool val);

class RideshareSearchFilter extends StatefulWidget{
  RideshareSearchFilter({Key key}) : super(key: key);
  @override
  _RideshareSearchFilterState createState() => _RideshareSearchFilterState();
}

class _RideshareSearchFilterState extends State<RideshareSearchFilter>{
  Map<String, dynamic> _filterOptions = {
    'from': null,
    'to': null,
    'datetime': null,
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

  @override
  Widget build(BuildContext context){
    return CollapsingFilter(genderValue: this._filterOptions['sameGender'], onGenderToggle: _onToggle);
  }
}

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
  CollapsingFilter({Key key, this.genderValue, this.onGenderToggle}) : super(key: key);
  bool genderValue;
  final Function onGenderToggle;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 120.0,
        maxHeight: 200.0,
        child: Container(
            color: appThemeColor,
            child: Center(
              child: Column(
                children: <Widget>[
                  _createTextSearchField('From', prefix:Icons.edit_location),
                  _createTextSearchField('To', prefix:Icons.edit_location),
                  _createTextSearchField('Time', prefix:Icons.access_time),
                  _createToggleWithDescription("Same Gender Only", this.genderValue, this.onGenderToggle, prefix:Icons.person)
                ]
              )
            ),
        ),
      ) ,
    );
  }
}