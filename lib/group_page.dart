import 'package:flutter/material.dart';

class GroupPage extends StatefulWidget {
  static MaterialPageRoute createRoute(BuildContext context) {
    return new MaterialPageRoute(
        builder: (BuildContext context) => new GroupPage());
  }

  @override
  _GroupPageState createState() => new _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  String email = "";

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
              //TODO add it to your group
              email = str;
            });
          },
        ),
      ),
    );
  }
}
