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
  runApp(
    new MaterialApp(
      home: new MyApp(),
      routes: <String, WidgetBuilder>{
        // TODO: implement routes, see https://docs.flutter.io/flutter/material/MaterialApp-class.html
        '/groups': (BuildContext context) => new GroupsPage(),
        '/blabla': (BuildContext context) => new BlablaPage(),
      },
      onGenerateRoute: ((RouteSettings route) {
        if (route.name.startsWith('/groups/')) {
          return new GroupPage(route.name.split('/').last);
        }
        if (route.name.startsWith('/users/')) {
          return new UserPage(route.name.split('/').last);
        }
      }),
    ),
  );
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
    if (!signedIn()) return signInPage();

    return new Scaffold(
      appBar: appBar(),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Flexible(
              child: groupsList(_currentUser),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _createGroupDialog,
        tooltip: 'Create Group',
        child: new Icon(Icons.add),
      ),
    );
  }

  Widget signInPage() {
    return new Scaffold(
      backgroundColor: Colors.primaries[9],
      body: new Center(
        child: new RaisedButton(
          onPressed: _signIn,
          color: Colors.accents[4],
          colorBrightness: Brightness.light,
          child: new Text('Sign in'),
        ),
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
