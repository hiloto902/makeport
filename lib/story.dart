import 'package:cloud_firestore/cloud_firestore.dart';
import 'widget/loading.dart';

import 'package:flutter/material.dart';
import 'const.dart';
import 'storydetails.dart';

class Story extends StatefulWidget {
  Story({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State createState() => StoryState();
}

class StoryState extends State<Story> {
  final ScrollController listScrollController = ScrollController();
  int _limit = 20;
  int _limitIncrement = 20;
  bool isLoading = false;

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onItemMenuPress(Mark mark) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => StoryDetails()));
  }

  void onBackPress() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            // List
            Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('stories')
                    // .limit(_limit)
                    .snapshots(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(context, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    controller: listScrollController,
                  );
                },
              ),
            ),

            // Loading
            Positioned(
              child: isLoading ? const Loading() : Container(),
            )
          ],
        ),
        //戻るときにポップが表示される
        onWillPop: onBackPress,
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

class Mark {
  const Mark({this.title, this.detail});

  final String title;
  final IconData detail;
}
