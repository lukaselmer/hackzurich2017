import 'package:barcodescanner/barcodescanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackzurich2017/business_logic.dart';
import 'package:hackzurich2017/firebase_helper.dart';

class InfoPage extends StatefulWidget {

  static MaterialPageRoute createRoute(BuildContext context, bool excludedInfo,
      String groupId, FirebaseUser currentUser, String itemId) {
    return new MaterialPageRoute(
        builder: (BuildContext context) => new InfoPage(
            excludedInfo: excludedInfo,
            groupId: groupId,
            currentUser: currentUser, itemId: itemId));
  }

  InfoPage({Key key, this.excludedInfo, this.groupId, this.currentUser, this.itemId})
      : super(key: key);
  final String itemId;
  final FirebaseUser currentUser;
  final bool excludedInfo;
  final String groupId;

  @override
  _InfoPageState createState() {
    return new _InfoPageState(
        isExcluded: excludedInfo, groupId: groupId, currentUser: currentUser, itemId: itemId);
  }
}

class _InfoPageState extends State<InfoPage> {

  _InfoPageState({this.isExcluded, this.groupId, this.currentUser, this.itemId});

  final String itemId;
  final FirebaseUser currentUser;
  final bool isExcluded;
  final String groupId;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Item Infos"),
      ),
      body: new Center(
        child: new Padding(
          padding: const EdgeInsets.only(
              top: 32.0, left: 64.0, right: 64.0, bottom: 32.0),
          child: new Column(
            children: [
              _getImage(),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new RaisedButton(
                  onPressed: _scanBarcode,
                  child: new Text("Scan again"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new RaisedButton(
                  onPressed: _dislikeProduct,
                  child: new Text("I DON'T LIKE IT"),
                ),
              )
            ],
          ),
        ),
      ),
    );
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

  _scanBarcode() async {
    Map<String, dynamic> barcodeData;
    //barcodeData is a JSON (Map<String,dynamic>) like this:
    //{barcode: '12345', barcodeFormat: 'ean-13'}
    barcodeData = await Barcodescanner.scanBarcode;
    String newItemId = barcodeData['barcode'];
    await items().child(newItemId).set(newItemId);
    var itemSnapshot = await getInfoFor(newItemId);
    Navigator.pop(context);
    Navigator.push(context,
        InfoPage.createRoute(context, !isExcluded, groupId, currentUser, newItemId));
  }

  _dislikeProduct() async {
    await addToExcluded(groupId, itemId, currentUser.email, currentUser.photoUrl);
    Navigator.pop(context);
  }
}
