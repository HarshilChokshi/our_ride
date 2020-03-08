import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DateTimePicker extends StatefulWidget {
  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  String _date = "Not set";
  String _time = "Not set";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 10,
                child: RaisedButton(
                  color: Color.fromRGBO(61, 191, 165, 100),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 0,
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        theme: DatePickerTheme(
                          containerHeight: 210.0,
                        ),
                        showTitleActions: true,
                        minTime: DateTime(2000, 1, 1),
                        maxTime: DateTime(2022, 12, 31),
                        onConfirm: (date) {
                          print('confirm $date');
                          _date = '${date.year} - ${date.month} - ${date.day}';
                          setState(() {});
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 40.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                    child:  Icon(
                                      Icons.date_range,
                                      size: 18.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child:  Text(
                                      " $_date",
                                      style: TextStyle(
                                          color: Colors.white,
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 14.0),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              Expanded(flex: 1, child: SizedBox(width: 10,)),
              Expanded(
                  flex: 10,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    elevation: 0,
                    onPressed: () {
                      DatePicker.showTimePicker(context,
                          theme: DatePickerTheme(
                            containerHeight: 210.0,
                          ),
                          showTitleActions: true, onConfirm: (time) {
                        print('confirm $time');
                        _time = '${time.hour} : ${time.minute} : ${time.second}';
                        setState(() {});
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                      child:  Icon(
                                        Icons.access_time,
                                        size: 18.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      child:  Text(
                                        " $_time",
                                        style: TextStyle(
                                            color: Colors.white,
                                            // fontWeight: FontWeight.bold,
                                            fontSize: 14.0),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ]
                      ),
                    ),
                    color: Color.fromRGBO(61, 191, 165, 100),
                  ),
                ),
              ],
          ),
        );
  }
}