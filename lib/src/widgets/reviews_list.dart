import 'package:flutter/material.dart';
import 'package:our_ride/src/models/review.dart';
import 'package:our_ride/src/widgets/star_display.dart';

class ReviewsList extends StatelessWidget {
  List<Review> reviewList;

  ReviewsList(this.reviewList);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new ListView.builder(
      itemBuilder: buildCell,
      itemCount: reviewList.length,
    );
  }

  Container buildCell(BuildContext context, int index) {
    return new Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0, top: 10.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            children: <Widget>[
              createReviewerNameText(reviewList[index].reviewer),
              new Container(margin: EdgeInsets.only(right: 5)),
              createRating(reviewList[index].rating),
            ],
          ),
          new Container(margin: EdgeInsets.only(top: 3)),
          createReviewContentText(reviewList[index].reviewContent),
        ],
      ),
    );
  }

  Widget createReviewerNameText(String reviewerName) {
    return new Text(
      reviewerName,
      style: new TextStyle(
        color: Colors.grey,
        fontSize: 16.0,
      ),
    );
  }

  Widget createRating(int rating) {
    return StarDisplayWidget(
        value: rating,
        filledStar: Icon(Icons.star, color: Colors.amber, size: 20),
        unfilledStar: Icon(Icons.star, color: Colors.grey, size: 20),
    );
  }

  Widget createReviewContentText(String reviewContent) {
    return Text(
      reviewContent,
      style: new TextStyle(
        color: Colors.black,
        fontSize: 12.0,
      ),
    );
  }
}