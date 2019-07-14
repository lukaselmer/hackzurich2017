import 'package:barcodescanner/barcodescanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackzurich2017/business_logic.dart';
import 'package:hackzurich2017/firebase_helper.dart';
import 'package:hackzurich2017/utils.dart';

class InfoPage extends StatefulWidget {
  static MaterialPageRoute createRoute(BuildContext context, bool excludedInfo,
      String groupId, FirebaseUser currentUser, String itemId) {
    return new MaterialPageRoute(
        builder: (BuildContext context) => new InfoPage(
            excludedInfo: excludedInfo,
            groupId: groupId,
            currentUser: currentUser,
            itemId: itemId));
  }

  InfoPage(
      {Key key, this.excludedInfo, this.groupId, this.currentUser, this.itemId})
      : super(key: key);
  final String itemId;
  final FirebaseUser currentUser;
  final bool excludedInfo;
  final String groupId;

  @override
  _InfoPageState createState() {
    return new _InfoPageState(
        isExcluded: excludedInfo,
        groupId: groupId,
        currentUser: currentUser,
        itemId: itemId);
  }
}

class _InfoPageState extends State<InfoPage> {
  String text = '';

  _InfoPageState(
      {this.isExcluded, this.groupId, this.currentUser, this.itemId}) {
    getTextFromBarcode(itemId).then((newText) {
      setState(() {
        text = newText;
      });
    });
  }

  final String itemId;
  final FirebaseUser currentUser;
  final bool isExcluded;
  final String groupId;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("And your result is..."),
      ),
      body: new Center(
        child: new Padding(
          padding: const EdgeInsets.only(
              top: 32.0, left: 64.0, right: 64.0, bottom: 32.0),
          child: new Column(
            children: [
              _getImageAlt(),
              _getImage(),
              _getInfos(),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new RaisedButton(
                  onPressed: _scanBarcode,
                  child: new Text("SCAN NEXT"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new RaisedButton(
                  onPressed: _dislikeProduct,
                  child: new Text("PLEASE DON'T BUY IT 💔"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new RaisedButton(
                  onPressed: _dislikeProduct,
                  child: new Text("PLEASE BUY THIS 😍"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getInfos() {
    return new Text(text);
  }

  Widget _getImage() {
    // print(snapshot.value);
    if (isExcluded)
      return new Icon(Icons.thumb_down, size: 250.0, color: Colors.red[700]);
    return new Icon(Icons.thumb_up, size: 250.0, color: Colors.green[700]);

    /* var sugarValue = snapshot.value['body'];//['data'][0]['nutrients']['sugars']['per_hundred'];
    var sugar = double.parse(sugarValue);
    if(sugar <= 10.0) {
      return new Image.asset("images/ic_good.png");
    } else if(sugar > 10.0 && sugar < 40.0 ) {
      return new Image.asset("images/ic_not_so_good.png");
    } else{
      return
    }*/
  }

  Widget _getImageAlt() {
    if (isExcluded)
      return new Text(
        'Someone does not like this product 😢',
        style: new TextStyle(fontSize: 22.0),
        textAlign: TextAlign.center,
      );
    return new Text('Yay, everyone likes this! 😃',
        style: new TextStyle(fontSize: 22.0), textAlign: TextAlign.center);

    /* var sugarValue = snapshot.value['body'];//['data'][0]['nutrients']['sugars']['per_hundred'];
    var sugar = double.parse(sugarValue);
    if(sugar <= 10.0) {
      return new Image.asset("images/ic_good.png");
    } else if(sugar > 10.0 && sugar < 40.0 ) {
      return new Image.asset("images/ic_not_so_good.png");
    } else{
      return
    }*/
  }

  _scanBarcode() async {
    Map<String, dynamic> barcodeData;
    //barcodeData is a JSON (Map<String,dynamic>) like this:
    //{barcode: '12345', barcodeFormat: 'ean-13'}
    try {
      barcodeData = await Barcodescanner.scanBarcode;
      String newItemId = barcodeData['barcode'];
      if ((await items().child(newItemId).once()).value == null)
        await items().child(newItemId).set(newItemId);
      // var itemSnapshot = await getInfoFor(newItemId);
      Navigator.pop(context);
      await handleBarcodeScan(context, groupId, currentUser, newItemId);
    } catch (_) {
      Navigator.pop(context);
    }
  }

  _dislikeProduct() async {
    await addToExcluded(
        groupId, itemId, currentUser.email, currentUser.photoUrl);
    Navigator.pop(context);
  }
}
