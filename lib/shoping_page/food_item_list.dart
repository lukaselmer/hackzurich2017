import 'package:flutter/material.dart';
import 'package:hackzurich2017/domain/food.dart';
import 'package:hackzurich2017/shoping_page/food_tile.dart';
import 'package:meta/meta.dart';


typedef void OnFoodItemTaped<FoodItem> (FoodItem foodItem, bool selected);

class FoodItemList extends StatefulWidget {
  const FoodItemList({Key key,
    @required this.foodItems : const <FoodItem>[],
    @required this.onFoodItemTaped,
  }): super(key: key);

  final List<FoodItem> foodItems;
  final OnFoodItemTaped onFoodItemTaped;
  @override
  State<StatefulWidget> createState() => new _FoodItemListState();
}

class _FoodItemListState extends State<FoodItemList> {

  @override
  Widget build(BuildContext context) {
    return _getContent();
  }



  Widget _getContent() {
    if(widget.foodItems.isEmpty) {
      return _emptyWidget();
    }
    return _list();
  }
  Widget _emptyWidget() {
    return
      new Row (
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: new Text("Nothing to buy!"),
              ),

              new Text(
                  "Search an itm by name or \n browse the categories below.",
                  textAlign: TextAlign.center,
                  textScaleFactor: 0.8,)
            ],
          )
        ],
      );
  }

  Widget _list() {
    return new GridView.count(
        crossAxisCount: 3,
        padding: const EdgeInsets.all(16.0),
        mainAxisSpacing: 4.0,
        shrinkWrap: true,
        crossAxisSpacing: 4.0,

        children: widget.foodItems.map((FoodItem food){
            return new FoodTile(
                name: food.name,
                icon: food.icon
                , onPressed: (bool state) {
                  food.isSelected = state;
                  widget?.onFoodItemTaped(food, state);
                },
            );
        }).toList(),
    );
  }
}