import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  TextEditingController _controller;
  //String _initialValue;
  String _valueChanged = '';
  String _valueToValidate = '';
  String _valueSaved = '';

  //ここからTEXTフィールド　 Formウィジェット内の各フォームを識別するためのキーを設定
  final _formKey = GlobalKey<FormState>();

  // フォーカス管理用のFocusNode
  final namefocus = FocusNode();
  final agefocus = FocusNode();

  // デモ用の適当な変数
  var _yourAge = 0;
  var _yourName = '';

  // 名前更新用メソッド
  void _updateName(String name) {
    setState(() {
      _yourName = name;
    });
  }

  // 年齢更新用メソッド
  void _updateAge(int age) {
    setState(() {
      _yourAge = age;
    });
  }

//リスト
  final List<Map<String, dynamic>> _items = [
    {
      'value': '1',
      'label': '北海道',
    },
    {
      'value': '2',
      'label': '青森',
      // 'textStyle': TextStyle(color: Colors.red),
    },
    {
      'value': '3',
      'label': '岩手',
    },
    {
      'value': '4',
      'label': '秋田',
    },
    {
      'value': '5',
      'label': '山形',
    },
    {
      'value': '6',
      'label': '宮崎',
    },
  ];
  final List<Map<String, dynamic>> _wanna = [
    {
      'value': '1',
      'label': 'ボーリング',
    },
    {
      'value': '2',
      'label': '卓球',
      // 'textStyle': TextStyle(color: Colors.red),
    },
    {
      'value': '3',
      'label': '映画',
    },
    {
      'value': '4',
      'label': 'キャンプ',
    },
    {
      'value': '5',
      'label': '水切り',
    },
    {
      'value': '6',
      'label': 'ラテアート',
    },
  ];

  @override
  void initState() {
    super.initState();

    //_initialValue = 'starValue';
    _controller = TextEditingController(text: 'starValue');

    _getValue();
  }

  /// This implementation is just to simulate a load data behavior
  /// from a data base sqlite or from a API
  Future<void> _getValue() async {
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        //_initialValue = 'circleValue';
        _controller.text = 'circleValue';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Form(
          key: _oFormKey,
          child: Column(
            children: <Widget>[
              SelectFormField(
                //type: SelectFormFieldType.dialog,
                controller: _controller,
                //initialValue: _initialValue,
                icon: Icon(Icons.format_shapes),
                labelText: 'Shape',
                changeIcon: true,
                dialogTitle: 'Pick a item',
                dialogCancelBtn: 'CANCEL',
                enableSearch: true,
                dialogSearchHint: 'Search item',
                items: _items,
                onChanged: (val) => setState(() => _valueChanged = val),
                validator: (val) {
                  setState(() => _valueToValidate = val);
                  return null;
                },
                onSaved: (val) => setState(() => _valueSaved = val),
              ),
              SelectFormField(
                //type: SelectFormFieldType.dialog,
                controller: _controller,
                //initialValue: _initialValue,
                icon: Icon(Icons.format_shapes),
                labelText: 'Shape',
                changeIcon: true,
                dialogTitle: 'Pick a item',
                dialogCancelBtn: 'CANCEL',
                enableSearch: true,
                dialogSearchHint: 'Search item',
                items: _wanna,
                onChanged: (val) => setState(() => _valueChanged = val),
                validator: (val) {
                  setState(() => _valueToValidate = val);
                  return null;
                },
                onSaved: (val) => setState(() => _valueSaved = val),
              ),
              nameFormField(context),
              ageFormField(context),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  // 送信ボタンクリック時の処理
                  onPressed: () {
                    // バリデーションチェック
                    if (_formKey.currentState.validate()) {
                      // 各フォームのonSavedに記述した処理を実行
                      // このsave()を呼び出さないと、onSavedは実行されないので注意
                      _formKey.currentState.save();
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text('更新しました。')));
                    }
                  },
                  child: Text('送信する'),
                ),
              ),
              Text("あなたのお名前 : " + _yourName),
              Text("あなたのご年齢 : " + _yourAge.toString()),
              SizedBox(height: 30),
              Text(
                'SelectFormField data value onChanged:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SelectableText(_valueChanged),
              SizedBox(height: 30),
              RaisedButton(
                onPressed: () {
                  final loForm = _oFormKey.currentState;

                  if (loForm.validate()) {
                    loForm.save();
                  }
                },
                child: Text('Submit'),
              ),
              SizedBox(height: 30),
              Text(
                'SelectFormField data value validator:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SelectableText(_valueToValidate),
              SizedBox(height: 30),
              Text(
                'SelectFormField data value onSaved:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SelectableText(_valueSaved),
              SizedBox(height: 30),
              RaisedButton(
                onPressed: () {
                  final loForm = _oFormKey.currentState;
                  loForm.reset();

                  setState(() {
                    _valueChanged = '';
                    _valueToValidate = '';
                    _valueSaved = '';
                  });
                },
                child: Text('Reset'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField nameFormField(BuildContext context) {
    return TextFormField(
      // ここでは使用しないが、コントローラももちろん使用可能
      // controller: _nameController,
      textInputAction: TextInputAction.next,
      autofocus: true, // フォームを含むウィジェットが作成された時点でフォーカスする。
      decoration: InputDecoration(labelText: "お名前を入力してください。"),
      focusNode: namefocus,
      onFieldSubmitted: (v) {
        // フォーム入力完了後、agefocusにフォーカスを移す。
        // すなわち年齢入力フォームにフォーカスを移動する。
        FocusScope.of(context).requestFocus(agefocus);
      },
      // 入力内容に対するバリデーション
      validator: (value) {
        // 入力内容が空でないかチェック
        if (value.isEmpty) {
          return 'テキストを入力してください。';
        }
      },
      // _formKey.currentState.save() 呼び出し時に実行する処理
      onSaved: (value) {
        _updateName(value);
      },
    );
  }

  TextFormField ageFormField(BuildContext context) {
    return TextFormField(
      // キーボードタイプを指定。ここではnumberを指定しており、数字キーボードを表示
      // 一覧はhttps://api.flutter.dev/flutter/services/TextInputType-class.html
      keyboardType: TextInputType.number,
      // テキスト入力完了時の動作、ボタン見た目の指定
      textInputAction: TextInputAction.done,
      focusNode: agefocus,
      onFieldSubmitted: (v) {
        // 年齢フォームからフォーカス外す
        agefocus.unfocus();
      },
      validator: (value) {
        // 年齢が１０歳以上であるか確認
        if (value.length == 0 || int.parse(value) <= 10) {
          return ('年齢は１０歳以上である必要があります。');
        }
      },
      // フォームの装飾を定義
      decoration: InputDecoration(
        labelText: "ご年齢を入力してください。",
        hintText: 'ご年齢（１０歳以上）',
        icon: Icon(Icons.person_outline),
        fillColor: Colors.white,
      ),
      onSaved: (value) {
        _updateAge(int.parse(value));
      },
    );
  }
}

class AddUser extends StatelessWidget {
  final String fullName;
  final String company;
  final int age;

  AddUser(this.fullName, this.company, this.age);

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'full_name': fullName, // John Doe
            'company': company, // Stokes and Sons
            'age': age // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return TextButton(
      onPressed: addUser,
      child: Text(
        "Add User",
      ),
    );
  }
}

class GetUserName extends StatelessWidget {
  final String documentId;

  GetUserName(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Text("Full Name: ${data['full_name']} ${data['last_name']}");
        }

        return Text("loading");
      },
    );
  }
}
