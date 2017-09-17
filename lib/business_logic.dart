import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:firebase_database/firebase_database.dart';
import 'package:hackzurich2017/firebase_helper.dart';

Future<String> afterLogin(String email, String imageUrl) async {
  final emailHash = _emailHash(email);
  final groupId = (await db().child("users/${emailHash}/group").once()).value;
  if (groupId != null) return groupId;

  final newGroupId = await _createGroup(emailHash, imageUrl);
  await _createUser(imageUrl, emailHash, newGroupId);
  return newGroupId;
}

Future<String> _createGroup(emailHash, imageUrl) async {
  final groupReference = db().child("groups").push();
  await groupReference.set({emailHash: imageUrl});
  return groupReference.key;
}

Future<Null> _createUser(String imageUrl, String emailHash, String groupId) {
  return db()
      .child("users/${emailHash}")
      .set({"group": groupId, "imageUrl": imageUrl});
}

//Future<bool> addEmailToMyGroup(FirebaseUser _firebaseUser, String email) async {
//  var myEmailHash = _emailHash(_firebaseUser.email);
//  String groupId =
//      (await db().child("users/${myEmailHash}/group").once()).value;
//  return await _addUser(groupId, email);
//}

Future<bool> addUser(String groupId, String email) async {
  final emailHash = _emailHash(email);
  final user = (await db().child("users/${emailHash}").once()).value;
  if (user == null) return false;
  await _setGroupOfUser(groupId, emailHash);
  await _addUserToGroup(groupId, emailHash, user['imageUrl']);
  return true;
}

Future<Null> _setGroupOfUser(String groupId, String emailHash) async {
  db().child("users/${emailHash}/group").set(groupId);
}

Future<Null> _addUserToGroup(String groupId, String emailHash, imageUrl) async {
  db().child("groups/${groupId}/${emailHash}").set(imageUrl);
}

Future<bool> isExcludedBarcode(String groupId, String barcode) async {
  var path = "excludelist/${groupId}/${barcode}";
  return (await db().child(path).once()).value != null;
}

Future<Null> addToExcluded(
    String groupId, String barcode, String email, String imageUrl) {
  return db()
      .child("excludelist/${groupId}/${barcode}/${_emailHash(email)}")
      .set(imageUrl);
}

String _emailHash(String email) {
  return BASE64
      .encode(email.toLowerCase().codeUnits)
      .replaceAll(new RegExp('[/]'), 'slash');
}

Future<List<String>> groupImages(String groupId) async {
  final map = (await db().child('groups/${groupId}').once()).value;
  return map.values.toList();
}

Stream<Event> groupsStream(String groupId) {
  return db().child('groups/${groupId}').onValue;
}
