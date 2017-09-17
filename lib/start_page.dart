import 'dart:async';

import 'package:barcodescanner/barcodescanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackzurich2017/business_logic.dart';
import 'package:hackzurich2017/firebase_helper.dart';
import 'package:hackzurich2017/group_page.dart';
import 'package:hackzurich2017/utils.dart';

class StartPage extends StatefulWidget {
  static MaterialPageRoute createRoute(BuildContext context, String title,
      String groupId, List<String> images, FirebaseUser user) {
    return new MaterialPageRoute(
      builder: (BuildContext context) => new StartPage(
            title: title,
            groupId: groupId,
            currentUser: user,
            images: images,
          ),
    );
  }

  final String title;
  final String groupId;
  final FirebaseUser currentUser;
  final List<String> images;

  StartPage({this.title, this.groupId, this.currentUser, this.images});

  @override
  _StartPageState createState() => new _StartPageState(
      title: title, currentUser: currentUser, groupId: groupId, images: images);
}

class _StartPageState extends State<StartPage> {
  final String title;
  FirebaseUser currentUser;
  final String groupId;
  List<String> images;

  _StartPageState({this.title, this.currentUser, this.groupId, this.images}) {
    groupsStream(groupId).listen((event) {
      groupImages(groupId).then((newImages) {
        setState(() {
          images = newImages;
        });
      });
    });
  }

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
              padding: const EdgeInsets.only(bottom: 20.0),
              child: new RaisedButton(
                onPressed: _navigateToAddGroup,
                child: new Text("ADD MEMBER"),
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: images.map((url) {
                return new CircleAvatar(
                  radius: 25.0,
                  backgroundImage: new NetworkImage(url),
                );
              }).toList(),
            ),
            new Padding(
              child: new Text('Group Favorites',
                  style: new TextStyle(fontSize: 20.0, color: Colors.accents[4])),
              padding: const EdgeInsets.only(top: 30.0, bottom: 15.0),
            ),
            new Padding(
              child: new Text('Green Vegetables',
                  style: new TextStyle(fontSize: 15.0)),
              padding: const EdgeInsets.only(bottom: 6.0),
            ),
            new Padding(
              child: new Text('Quinoa',
                  style: new TextStyle(fontSize: 15.0)),
              padding: const EdgeInsets.only(bottom: 6.0),
            ),
            new Padding(
              child: new Text('Tofu',
                  style: new TextStyle(fontSize: 15.0)),
              padding: const EdgeInsets.only(bottom: 6.0),
            ),
            new Padding(
              child: new Text('Salad',
                  style: new TextStyle(fontSize: 15.0)),
              padding: const EdgeInsets.only(bottom: 6.0),
            ),
            new Padding(
              child: new Text('Sweet Patatoes',
                  style: new TextStyle(fontSize: 15.0)),
              padding: const EdgeInsets.only(bottom: 6.0),
            ),
            new Padding(
              child: new Text('Chocolate',
                  style: new TextStyle(fontSize: 15.0)),
              padding: const EdgeInsets.only(bottom: 6.0),
            ),
            new Padding(
              child: new Text('Organic Food',
                  style: new TextStyle(fontSize: 15.0)),
              padding: const EdgeInsets.only(bottom: 6.0),
            ),
            new Padding(
              child: new Text('Unwished',
                  style: new TextStyle(fontSize: 20.0, color: Colors.accents[0])),
              padding: const EdgeInsets.only(top: 30.0, bottom: 15.0),
            ),
            new Padding(
              child: new Text('Meat',
                  style: new TextStyle(fontSize: 15.0)),
              padding: const EdgeInsets.only(bottom: 6.0),
            ),
            new Padding(
              child: new Text('Bread',
                  style: new TextStyle(fontSize: 15.0)),
              padding: const EdgeInsets.only(bottom: 6.0),
            ),
            new Padding(
              child: new Text('Non Saturated Fats',
                  style: new TextStyle(fontSize: 15.0)),
              padding: const EdgeInsets.only(bottom: 6.0),
            ),
          ]),
        ),
      ),
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
    try {
      Map<String, dynamic> barcodeData;
      //barcodeData is a JSON (Map<String,dynamic>) like this:
      //{barcode: '12345', barcodeFormat: 'ean-13'}
      barcodeData = await Barcodescanner.scanBarcode;
      String itemId = barcodeData['barcode'];
      if ((await items().child(itemId).once()).value == null)
        await items().child(itemId).set(itemId);
      await handleBarcodeScan(context, groupId, currentUser, itemId);
      // var excludedInfo = await getInfoFor(itemId);
    } catch (_) {
      Navigator.pop(context);
    }
  }

  _navigateToAddGroup() async {
    await Navigator.push(
        context, GroupPage.createRoute(context, currentUser, groupId));
  }
}
