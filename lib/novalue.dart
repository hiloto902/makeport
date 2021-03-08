import 'package:flutter/material.dart';

class NoValue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var list = [
      "メッセージ",
      "メッセージ",
      "メッセージ",
      "メッセージ",
      "メッセージ",
    ];
    return Scaffold(body: ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        if (index >= list.length) {
          list.addAll([
            "メッセージ",
            "メッセージ",
            "メッセージ",
            "メッセージ",
          ]);
        }
        return _messageItem(list[index]);
      },
    ));
  }

  Widget _messageItem(String title) {
    return Container(
      decoration: new BoxDecoration(
          border:
              new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        onTap: () {
          print("onTap called.");
        }, // タップ
        onLongPress: () {
          print("onLongTap called.");
        }, // 長押し
      ),
    );
  }
}
