import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'const.dart';

class StoryDetails extends StatefulWidget {
  StoryDetails({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State createState() => StoryDetailsState();
}

class StoryDetailsState extends State<StoryDetails> {
  void onBackPress() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('stories')
            // .limit(_limit)
            .snapshots(),
        builder: (context, snapshot) {
          return Scaffold(
            body: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      'Title: ${document.data()['title']}',
                      style: TextStyle(color: primaryColor),
                    ),
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                  ),
                  Container(
                    child: Text(
                      'Detail: ${document.data()['content'] ?? 'Not available'}',
                      style: TextStyle(color: primaryColor),
                    ),
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    return Container(
      child: FlatButton(
        child: Row(
          children: <Widget>[
            Flexible(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Title: ${document.data()['title']}',
                        style: TextStyle(color: primaryColor),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                    Container(
                      child: Text(
                        'Detail: ${document.data()['content'] ?? 'Not available'}',
                        style: TextStyle(color: primaryColor),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 20.0),
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => StoryDetails()));
        },
        color: Colors.amber,
        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
    );
  }
}
