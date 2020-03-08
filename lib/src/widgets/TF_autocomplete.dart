import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

//calback function definitions
typedef FutureOr<Iterable<dynamic>> SuggestionsCallbackType(String pattern);
typedef Widget ItemBuilderType(BuildContext context, dynamic suggestion);
typedef void SuggestionsSelectedType(dynamic suggestion);


class TFWithAutoComplete extends StatefulWidget {
  //customization properties
  dynamic prefix;
  String hintText;
  SuggestionsCallbackType suggestionsCallback;
  ItemBuilderType itemBuilder;
  SuggestionsSelectedType onSuggestionsSelected;
  TextEditingController typeAheadController;

  
  TFWithAutoComplete({
    Key key,
    this.hintText = "Text/Search Field",
    this.prefix = Icons.search,
    @required this.suggestionsCallback,
    @required this.itemBuilder,
    @required this.onSuggestionsSelected,
    @required this.typeAheadController,
  }): super(key: key);

  @override
  _TFWithAutoCompleteState createState() {
    return _TFWithAutoCompleteState();
  }
}

class _TFWithAutoCompleteState extends State<TFWithAutoComplete> {
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
      child: TypeAheadFormField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: widget.typeAheadController,
            autofocus: true,
            style: TextStyle(fontSize: 14, color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Icon(
                  widget.prefix,
                  color: Colors.white,
                ),
              ),
              hintText: widget.hintText,
              hintStyle: TextStyle(fontSize: 14, color: Colors.white),
              errorStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none // icon is 48px widget.
            ),
          ),
          suggestionsCallback: widget.suggestionsCallback,
          itemBuilder: widget.itemBuilder,
          onSuggestionSelected: widget.onSuggestionsSelected,
        ),
      );
  }
}