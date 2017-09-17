import 'dart:async';

import 'package:barcodescanner/barcodescanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackzurich2017/firebase_helper.dart';
import 'package:hackzurich2017/group_page.dart';
import 'package:hackzurich2017/info_page.dart';

class StartPage extends StatefulWidget {
  static MaterialPageRoute createRoute(
      BuildContext context, String title, FirebaseUser user) {
    return new MaterialPageRoute(
        builder: (BuildContext context) => new StartPage(
              title: title,
              currentUser: user,
            ));
  }

  final String title;
  FirebaseUser currentUser;

  StartPage({this.title, this.currentUser});

  @override
  _StartPageState createState() =>
      new _StartPageState(title: title, currentUser: currentUser);
}

class _StartPageState extends State<StartPage> {
  final String title;
  FirebaseUser currentUser;

  _StartPageState({this.title, this.currentUser});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new Container(
          padding: const EdgeInsets.only(
              top: 8.0, left: 16.0, right: 16.0, bottom: 8.0),
          child: new Center(
              child: new Column(children: [
            new Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: new RaisedButton(
                  onPressed: _scanBarcode, child: new Text("SCAN")),
            ),
            new Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: new RaisedButton(
                  onPressed: _navigateToAddGroup, child: new Text("ADD MEMBER")),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new CircleAvatar(
                  radius: 25.0,
                  backgroundImage:
                      new NetworkImage("http://loremflickr.com/320/320/girl"),
                ),
                new CircleAvatar(
                  radius: 25.0,
                  backgroundImage:
                      new NetworkImage("http://loremflickr.com/320/320/boy"),
                ),
                new CircleAvatar(
                  radius: 25.0,
                  backgroundImage:
                      new NetworkImage("http://loremflickr.com/320/320/dog"),
                )
              ],
            )
          ]))),
    );
  }

  FloatingActionButton get createFloatingActionButton {
    return new FloatingActionButton(
      onPressed: _createGroupDialog,
      tooltip: 'Create Group',
      child: new Icon(Icons.add),
    );
  }

  Drawer get createDrawer {
    return new Drawer(
      child: new ListView(
        children: [
          new UserAccountsDrawerHeader(
            currentAccountPicture: new CircleAvatar(
              backgroundImage: new NetworkImage(currentUser.photoUrl),
            ),
            accountName: new Text(currentUser.displayName),
            accountEmail: new Text(currentUser.email),
          )
        ],
      ),
    );
  }

  Future<Null> _createGroupDialog() async {
    return null;
  }

  _scanBarcode() async {
    Map<String, dynamic> barcodeData;
    //barcodeData is a JSON (Map<String,dynamic>) like this:
    //{barcode: '12345', barcodeFormat: 'ean-13'}
    barcodeData = await Barcodescanner.scanBarcode;
    String itemId = barcodeData['barcode'];
    await items().child(itemId).set(itemId);
    var itemSnapshot = await getInfoFor(itemId);
    Navigator.push(context, InfoPage.createRoute(context, itemSnapshot));
  }

  _navigateToAddGroup() async {
    await Navigator.push(context, GroupPage.createRoute(context, firebaseUser));
  }
}
