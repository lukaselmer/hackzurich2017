import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hackzurich2017/login_page.dart';

main() async {
  await FirebaseDatabase.instance.setPersistenceEnabled(false);
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'FoodWish',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: <String, WidgetBuilder>{
        "/": (BuildContext context) => new MyHomePage(title: 'FoodWish'),
      },
    );
  }
}
