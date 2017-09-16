import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';



class InfoPage extends StatefulWidget {

  static MaterialPageRoute createRoute(BuildContext context, DataSnapshot snapshot){
    return new MaterialPageRoute(
        builder: (BuildContext context) => new InfoPage(snapshot:snapshot));
  }

  InfoPage({Key key, this.snapshot}):super(key: key);
  final DataSnapshot snapshot;

  @override
  _InfoPageState createState()  {
    return new _InfoPageState(snapshot: snapshot);
  }
}

class _InfoPageState extends State<InfoPage> {

  _InfoPageState({this.snapshot});
  final DataSnapshot snapshot;


  @override
  Widget build(BuildContext context) {

    return new Scaffold (
      appBar: new AppBar(
        title: new Text("Item Infos"),
      ),
      body: new Center(
        child: new Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 64.0, right: 64.0, bottom: 32.0),
            child: _getImage(),
        )
      )
    );
  }

  Widget _getImage() {
    print(snapshot.value);
    return new Image.asset("images/ic_bad.png");
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
}
