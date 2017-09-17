import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackzurich2017/business_logic.dart';

class GroupPage extends StatefulWidget {
  FirebaseUser _firebaseUser;

  GroupPage(this._firebaseUser);

  static MaterialPageRoute createRoute(
      BuildContext context, FirebaseUser firebaseUser) {
    return new MaterialPageRoute(
        builder: (BuildContext context) => new GroupPage(firebaseUser));
  }

  @override
  _GroupPageState createState() => new _GroupPageState(_firebaseUser);
}

class _GroupPageState extends State<GroupPage> {
  String email = "";

  FirebaseUser _firebaseUser;

  _GroupPageState(this._firebaseUser);

  // TODO: add UI submit button
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Add to group"),
      ),
      body: new Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: new TextField(
          decoration: new InputDecoration(hintText: "E-Mail"),
          onSubmitted: (String str) {
            setState(() {
              email = str;
            });
            addEmailToMyGroup(_firebaseUser, email).then((found) {
              if (found) return Navigator.pop(context);
              // if (found) return Navigator.of(context).pop();
            });
          },
        ),
      ),
    );
  }
}
