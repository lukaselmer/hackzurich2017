import 'package:barcodescanner/barcodescanner.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:hackzurich2017/groups.dart';

final googleSignIn = new GoogleSignIn();
final auth = FirebaseAuth.instance;

main() async {
  await FirebaseDatabase.instance.setPersistenceEnabled(true);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Conshop',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new MyHomePage(title: 'Conshop'),
    );
  }
}

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

    if (!mounted) return null;

    setState(() {
      _barcode = barcodeData['barcode'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Align(
          alignment: FractionalOffset.centerRight,
          child: _signInBar(),
        ),
      ),
      drawer: createDrawer,
      body: createBody,
      floatingActionButton: createfloatingActionButton,
    );
  }

  Widget get createBody {
    return loginBody;
  }

  Widget get loginBody {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new RaisedButton(onPressed: _ensureLoggedIn, child: new Text("Login"),),
          new RaisedButton(onPressed: _scanBarcode, child: new Text("Just Scann"),)
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
    if (!signedIn()) {
      return new FlatButton(onPressed: _signIn, child: new Text('Sign in'));
    }
    return new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new FlatButton(onPressed: _scanBarcode, child: new Icon(Icons.scanner)),
        new FlatButton(onPressed: _signOut, child: new Icon(Icons.exit_to_app)),
        new CircleAvatar(
          backgroundImage: new NetworkImage(_currentUser.photoUrl),
        ),
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

  _signIn() {
    _ensureLoggedIn();
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
