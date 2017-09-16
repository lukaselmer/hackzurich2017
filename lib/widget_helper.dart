import 'package:flutter/material.dart';

AppBar createAppBar(String title) {
  return new AppBar(
    title: new Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: new Text(title),
    ),
  );
}
