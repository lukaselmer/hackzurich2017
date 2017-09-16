import 'package:barcodescanner/barcodescanner.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:async';
import 'package:flutter/services.dart';

final googleSignIn = new GoogleSignIn();
final auth = FirebaseAuth.instance;
final reference = FirebaseDatabase.instance.reference().child('groups');

void main() {
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
  var _currentUser;
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
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: appBar(),
      body: body(),
      floatingActionButton: new FloatingActionButton(
        onPressed: _createGroupDialog,
        tooltip: 'Create Group',
        child: new Icon(Icons.add),
      ),
    );
  }

  bool signedIn() {
    return _currentUser != null;
  }

  Center body() {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Flexible(
            child: new FirebaseAnimatedList(
              query: reference,
              sort: (a, b) => b.key.compareTo(a.key),
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder:
                  (_, DataSnapshot snapshot, Animation<double> animation, __) {
                return new Group(snapshot: snapshot, animation: animation);
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return new AppBar(
      title: new Align(
        alignment: FractionalOffset.centerRight,
        child: _signInBar(),
      ),
    );
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
          backgroundImage: new NetworkImage(googleSignIn.currentUser.photoUrl),
        ),
      ],
    );
  }

  Future<Null> _createGroupDialog() async {
    await _ensureLoggedIn();
    _createGroup('Hello World, $_barcode!');
  }

  void _createGroup(String name) {
    reference.push().set({
      'name': name,
      'ownerEmail': googleSignIn.currentUser.email,
      'ownerPhotoUrl': googleSignIn.currentUser.photoUrl,
    });
  }

  _signOut() {
    // TODO: signIn does not work after sign out...???
    // to be more exact: googleSignIn.signIn() never finishes...
    // flutter is still alpha! :-/
    // this would actually be the right code: await googleSignIn.signOut();
  }

  _signIn() {
    _ensureLoggedIn();
  }

  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) user = await googleSignIn.signIn();

    if (await auth.currentUser() == null) {
      GoogleSignInAuthentication credentials =
          await googleSignIn.currentUser.authentication;
      await auth.signInWithGoogle(
        idToken: credentials.idToken,
        accessToken: credentials.accessToken,
      );
    }
  }
}

class Group extends StatelessWidget {
  Group({this.snapshot, this.animation});

  final DataSnapshot snapshot;
  final Animation animation;

  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(
                  backgroundImage:
                      new NetworkImage(snapshot.value['ownerPhotoUrl'])),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(snapshot.value['name'],
                    style: Theme.of(context).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(snapshot.value['ownerEmail']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
