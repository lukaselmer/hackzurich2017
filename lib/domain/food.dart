import 'package:flutter/material.dart';

class FoodItem {
  FoodItem({this.name, this.icon, this.isSelected = false});

  final String name;
  final IconData icon;
  bool isSelected;
}

class FoodCategory {
  FoodCategory({this.name, this.foodItems});

  final String name;
  final List<FoodItem> foodItems;
}

// ignore: non_constant_identifier_names
final List<FoodItem> fruits_and_vegetables = <FoodItem>[
  new FoodItem(name: "Apples", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Apricot", icon: Icons.add),
  new FoodItem(name: "Artichokes", icon: Icons.account_balance),
  new FoodItem(name: "Arugula", icon: Icons.ac_unit),
  new FoodItem(name: "Asparagus", icon: Icons.access_alarm),
  new FoodItem(name: "Avocado", icon: Icons.accessibility),
  new FoodItem(name: "Bananas", icon: Icons.code),
  new FoodItem(name: "Bell pepper", icon: Icons.call),
  new FoodItem(name: "Berries", icon: Icons.cake),
  new FoodItem(name: "Blackberries", icon: Icons.cached),
  new FoodItem(name: "Blueberries", icon: Icons.work),
  new FoodItem(name: "Broccoli", icon: Icons.youtube_searched_for),
  new FoodItem(name: "Cabbage", icon: Icons.radio),
  new FoodItem(name: "Carrots", icon: Icons.radio),
  new FoodItem(name: "Cauliflower", icon: Icons.radio),
  new FoodItem(name: "Celery", icon: Icons.radio),
  new FoodItem(name: "Cherries", icon: Icons.radio),
  new FoodItem(name: "Cherry tomatoes", icon: Icons.radio),
  new FoodItem(name: "Chillies", icon: Icons.radio),
  new FoodItem(name: "Chives", icon: Icons.radio),
  new FoodItem(name: "Cilantro", icon: Icons.radio),
  new FoodItem(name: "Cranberries", icon: Icons.radio),
  new FoodItem(name: "Cucumber", icon: Icons.radio),
  new FoodItem(name: "Dates", icon: Icons.radio),
  new FoodItem(name: "Eggplant", icon: Icons.radio),
  new FoodItem(name: "Fennel", icon: Icons.radio),
  new FoodItem(name: "Fruit", icon: Icons.radio),
  new FoodItem(name: "Garlic", icon: Icons.radio),
  new FoodItem(name: "Ginger", icon: Icons.radio),
  new FoodItem(name: "Grapefruit", icon: Icons.radio),
  new FoodItem(name: "Grapes", icon: Icons.radio),
  new FoodItem(name: "Herbs", icon: Icons.radio),
  new FoodItem(name: "Kiwis", icon: Icons.radio),
  new FoodItem(name: "Leek", icon: Icons.radio),
];

final List<FoodItem> meat = <FoodItem>[
  new FoodItem(name: "Bacon", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Beef", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Bratwurst", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Chicken", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Chicken breast", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Cold cuts", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Gruond meat", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Ham", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Hotdog", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Lamb", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Meat", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Pork", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Prosciutto", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Salami", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Sausage", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Sausages", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Sliced beef", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Steak", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Turkey", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Turkey breast", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Veal", icon: Icons.add_shopping_cart),
];

final List<FoodItem> fish = <FoodItem>[
  new FoodItem(name: "Anchovies", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Fish", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Lobster", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Mussles", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Oysters", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Salmon", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Shrimp", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Tuna", icon: Icons.add_shopping_cart),
];

// ignore: non_constant_identifier_names
final List<FoodItem> bread_and_pastries = <FoodItem>[
  new FoodItem(name: "Bagles", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Baguette", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Bread", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Buns", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Crispbread", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Croissant", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Dinner Rolls", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Muffins", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Pancakes mix", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Pie", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Pizza dough", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Puff pastry", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Pummpkin Pie", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Rolls", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Scone", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Sliced bread", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Toast", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Tortillas", icon: Icons.add_shopping_cart),
  new FoodItem(name: "Waffles", icon: Icons.add_shopping_cart),
];
