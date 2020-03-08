import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:our_ride/src/contants.dart';
import 'package:our_ride/src/widgets/app_bottom_navigation_bar.dart';
import 'package:our_ride/src/widgets/rideshare_search_filter.dart';

import 'package:our_ride/src/widgets/TF_with_floatinglist.dart';


class RideshareListScreen extends StatefulWidget {
  String rider_id;

  RideshareListScreen(String rider_id) {
    this.rider_id = rider_id;
  }

  @override
  State<StatefulWidget> createState() {
    return new RideshareListState(rider_id);
  }
}

class RideshareListState extends State<RideshareListScreen> {
  String rider_id;

  RideshareListState(String rider_id) {
    this.rider_id = rider_id;
  }

   GlobalKey<FormState> testFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appThemeColor,
        elevation: 0,
        title: Text(
          'Rideshares',
          style: TextStyle(
              fontSize: 24.0,
              color: Colors.white,
            ),
          ),
        ),
        // body: TypeAheadField(
        //   textFieldConfiguration: TextFieldConfiguration(
        //     autofocus: true,
        //     style: DefaultTextStyle.of(context).style.copyWith(
        //       fontStyle: FontStyle.italic
        //     ),
        //     decoration: InputDecoration(
        //       border: OutlineInputBorder()
        //     )
        //   ),
        //   suggestionsCallback: (pattern)  {
        //     var item = {'name': "item 1", "price": "10"};
        //     return [item];
        //   },
        //   itemBuilder: (context, suggestion) {
        //     return ListTile(
        //       leading: Icon(Icons.shopping_cart),
        //       title: Text(suggestion['name']),
        //       subtitle: Text('\$${suggestion['price']}'),
        //     );
        //   },
        //   onSuggestionSelected: (suggestion) {
        //     // Navigator.of(context).push(MaterialPageRoute(
        //     //   builder: (context) => ProductPage(product: suggestion)
        //     // ));
        //   },
        // ),
        // body: TFWithFloatingList(hintText:'From', prefix:Icons.edit_location),
        
      // body: Form(
      //           key: this.testFormKey,
      //           child:
      //           TFWithFloatingList(hintText:'From', prefix:Icons.edit_location),
      //       ),
      body: CustomScrollView(
          slivers: <Widget>[
            RideshareSearchFilter(),
            SliverFixedExtentList(
              itemExtent: 150.0,
              delegate: SliverChildListDelegate(
                [
                  Container(color: Colors.red),
                  Container(color: Colors.purple),
                  Container(color: Colors.green),
                  Container(color: Colors.orange),
                  Container(color: Colors.yellow),
                ],
              ),
            ),
          ],
        ),
      bottomNavigationBar: AppBottomNavigationBar(rider_id, 0, true),
    );
  }
}

