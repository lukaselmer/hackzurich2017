import 'dart:async';

import 'package:barcodescanner/barcodescanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hackzurich2017/firebase_helper.dart';
import 'package:hackzurich2017/groups.dart';
import 'package:hackzurich2017/info_page/info_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseUser _currentUser;
  var _barcode = 'Not scanned yet';

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



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: new Text("App Name")),
      ),
      drawer: createDrawer,
      body: _createBody(),
      floatingActionButton: createfloatingActionButton,
    );
  }

  Widget _createBody() {
    return new Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
            image: new AssetImage("images/bg_login.png"),
            fit: BoxFit.cover,
        )
      ),
      child: new Center(
        child: new Column(
          children: [
            new Padding(padding: const EdgeInsets.only(top: 32.0)
              ,child: new Image.asset("images/app_icon.png", scale: 3.5,)
            ),
            new Expanded(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Row(
                      children:[
                        new Expanded(
                            child:new Padding(
                              padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
                              child: new RaisedButton(
                                  color: Colors.red,
                                  onPressed: _ensureLoggedIn
                                  , child: new Text("LOGIN", style: new TextStyle(color: Colors.white),)),
                            )
                          )
                      ]
                    ),
                    new Row(
                      children: [
                        new Expanded(
                            child: new FlatButton(
                                onPressed: _scanBarcode
                                , child: new Text("JUST SCAN"
                                          , style: new TextStyle(color: Colors.red),)),
                        )
                      ],
                    )

                  ],
                )
            ),
          ],
        ),
      )
    );
  }

  Widget get loginBody {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new RaisedButton(
            onPressed: _ensureLoggedIn
            , child: new Text("Login"),),
          new RaisedButton(onPressed: _scanBarcode
              , child: new Text("Just Scann"))
        ],
      ),
    );
  }

  FloatingActionButton get createfloatingActionButton {
    if (!signedIn()) {
      return null;
    }
    return new FloatingActionButton(
      onPressed: _createGroupDialog,
      tooltip: 'Create Group',
      child: new Icon(Icons.add),
    );
  }

  Drawer get createDrawer {
    if (!signedIn()) {
      return null;
    }
    return new Drawer(
        child: new ListView(
          children: [
            new UserAccountsDrawerHeader(
              currentAccountPicture: new CircleAvatar(
                backgroundImage: new NetworkImage(_currentUser.photoUrl),
              ),
              accountName: new Text(_currentUser.displayName),
              accountEmail: new Text(_currentUser.email),
            )
          ],
        ));
  }

  bool signedIn() {
    return _currentUser != null;
  }

  Widget _signInBar() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new FlatButton(onPressed: _scanBarcode, child: new Icon(Icons.scanner)),
        new FlatButton(onPressed: _signOut, child: new Icon(Icons.exit_to_app)),
      ],
    );
  }

  Future<Null> _createGroupDialog() async {
    await _ensureLoggedIn();
    createGroup('Hello World, $_barcode!', _currentUser);
  }

  _signOut() async {
    // TODO: signIn does not work after sign out...???
    // to be more exact: googleSignIn.signIn() never finishes...
    // or do we need to call: await googleSignIn.signOut(); ?
    await FirebaseAuth.instance.signOut();
    setState(() {
      _currentUser = null;
    });
    await googleSignIn.disconnect();
  }

  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) user = await googleSignIn.signInSilently();
    if (user == null) user = await googleSignIn.signIn();

    FirebaseUser firebaseUser = await auth.currentUser();
    if (await auth.currentUser() == null) {
      GoogleSignInAuthentication credentials =
      await googleSignIn.currentUser.authentication;
      firebaseUser = await auth.signInWithGoogle(
        idToken: credentials.idToken,
        accessToken: credentials.accessToken,
      );
    }
    setState(() {
      _currentUser = firebaseUser;
    });
  }
}
