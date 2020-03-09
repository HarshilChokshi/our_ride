import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

//calback function definitions
typedef FutureOr<Iterable<dynamic>> SuggestionsCallbackType(String pattern);
typedef Widget ItemBuilderType(BuildContext context, dynamic suggestion);
typedef void SuggestionsSelectedType(dynamic suggestion);
typedef String FieldValidatorType(String value);
typedef String OnSavedType(String value);

class TFWithAutoComplete extends StatefulWidget {
  //customization properties
  dynamic prefix;
  String hintText;
  Color dropDownColor;
  double height;
  SuggestionsCallbackType suggestionsCallback;
  ItemBuilderType itemBuilder;
  SuggestionsSelectedType onSuggestionsSelected;
  FieldValidatorType validator;
  OnSavedType onSaved;
  TextEditingController typeAheadController;

  static const Color _defaultDropDownColor = Color.fromRGBO(61, 191, 165, 100);

  
  TFWithAutoComplete({
    Key key,
    this.hintText = "Text/Search Field",
    this.prefix = Icons.search,
    this.dropDownColor = _defaultDropDownColor,
    this.height = 40,
    @required this.suggestionsCallback,
    @required this.itemBuilder,
    @required this.onSuggestionsSelected,
    // @required this.onSaved,
    @required this.typeAheadController,
    // this.validator,
  }): super(key: key);

  @override
  _TFWithAutoCompleteState createState() {
    return _TFWithAutoCompleteState(this.dropDownColor, this.height);
  }
}

class _TFWithAutoCompleteState extends State<TFWithAutoComplete> {
 
 Color dropDownColor;
 double height;
 
 _TFWithAutoCompleteState(this.dropDownColor, this.height);
 
 @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
        color: dropDownColor,
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
              hintStyle: TextStyle(fontSize: 14, color: Color.fromARGB(150, 255, 255, 255)),
              errorStyle: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold
                ),
              // errorBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color: Colors.red, width: 5.0)
              // ),
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none // icon is 48px widget.
            ),
          ),
          suggestionsCallback: widget.suggestionsCallback,
          itemBuilder: widget.itemBuilder,
          onSuggestionSelected: widget.onSuggestionsSelected,
          // validator: (String value) {
          // },
          // onSaved: widget.onSaved,
        ),
      );
  }
}