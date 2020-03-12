import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DateTimeFilter extends StatelessWidget{
  DateTimeFilter({
    this.updateDateTime,
    this.dateState,
    this.timeState,
  });

  //parent tree state values and functions
  String dateState;
  String timeState;
  final Function updateDateTime;

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
                        minTime: DateTime.now().add(Duration(days: 1)),
                        maxTime: DateTime(2020, 12, 31),
                        onConfirm: (date) {
                          print('confirm $date');
                          dateState = '$date'.split(' ')[0];
                          updateDateTime('date', dateState);
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
                                      " ${dateState != null ? dateState : "Date"}",
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
                          showTitleActions: true, 
                          onConfirm: (time) {
                            print('confirm $time');
                            timeState = '${time.hour}:${time.minute}';
                            updateDateTime('time', timeState);
                          }, 
                          currentTime: DateTime.now(), 
                          locale: LocaleType.en
                        );
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
                                         " ${timeState != null ? timeState : "Time"}",
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