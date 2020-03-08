import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TFWithFloatingList  extends StatefulWidget {
  //customization properties
  dynamic prefix;
  String hintText;
  
  TFWithFloatingList({
    Key key,
    this.hintText = "Text/Search Field",
    this.prefix = Icons.search,
  }): super(key: key);

  @override
  _TFWithFloatingListState createState() {
    return _TFWithFloatingListState();
  }
}

class _TFWithFloatingListState extends State<TFWithFloatingList> {
  final FocusNode _focusNode = FocusNode();
  OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    this._focusNode.addListener(() {
      if(this._focusNode.hasFocus == true){
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);
      }
      else {
        this._overlayEntry.remove();
      }
    });

  }

  //generate the overlay needed to show the dropdown list
  OverlayEntry _createOverlayEntry(){
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5.0,
        width: size.width,
        child: Material(
          elevation: 4.0,
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: <Widget>[
              ListTile(
                title: Text('Syria'),
              ),
              ListTile(
                title: Text('Lebanon'),
              )
            ],
          ),
        ),
      )
    );
  }

 @override
  Widget build(BuildContext context) {
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
                widget.prefix,
                color: Colors.white,
              ), // icon is 48px widget.
            ),
            hintText: widget.hintText,
            hintStyle: TextStyle(fontSize: 14, color: Colors.white),
            errorStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            filled: true,
            fillColor: Colors.transparent,
            border: InputBorder.none
            )
        )
  );
  }
}