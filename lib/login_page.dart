import 'dart:async';

import 'package:barcodescanner/barcodescanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hackzurich2017/firebase_helper.dart';
import 'package:hackzurich2017/info_page.dart';
import 'package:hackzurich2017/start_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState(title: title);
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseUser _currentUser;

  final String title;
  _MyHomePageState({this.title});


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: new Text(title)),
      ),
      body: _createLogin(),
    );
  }


  Widget _createLogin() {
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

                    ],
                  )
              ),
            ],
          ),
        )
    );
  }

  bool signedIn() {
    return _currentUser != null;
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

    await Navigator.push(context, StartPage.createRoute(context
        , "Start Page"
        , firebaseUser));
  }
}
