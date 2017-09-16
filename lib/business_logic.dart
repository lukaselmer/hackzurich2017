import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:hackzurich2017/firebase_helper.dart';

Future<Null> afterLogin(String emailHash, String imageUrl) async {
  final user = (await db().child("users/emailHash").once()).value;
  if (user != null) return null;

  final groupId = await _createGroup(emailHash, imageUrl);
  await _createUser(user["imageUrl"], emailHash, groupId);
}

Future<String> _createGroup(emailHash, imageUrl) async {
  final groupReference = db().child("groups").push();
  await groupReference.set({emailHash: imageUrl});
  return groupReference.key;
}

Future<Null> _createUser(String imageUrl, String emailHash, String groupId) {
  return db()
      .child("users/${emailHash}")
      .set({"group": emailHash, "imageUrl": imageUrl});
}

Future<Null> addUser(String groupId, String emailHash) async {
  final user = (await db().child("users/${emailHash}").once()).value;
  if (user == null) return;
  await _setGroupOfUser(groupId, emailHash);
  await _addUserToGroup(groupId, emailHash, user['imageUrl']);
}

Future<Null> _setGroupOfUser(String groupId, String emailHash) async {
  db().child("users/${emailHash}/group").set(groupId);
}

Future<Null> _addUserToGroup(String groupId, String emailHash, imageUrl) async {
  db().child("groups/${groupId}/${emailHash}").set(imageUrl);
}

Future<bool> isExcludedBarcode(String groupId, String barcode) async {
  return (await db().child("excludelist/${groupId}/${barcode}").once()) == null;
}

Future<Null> addToExcluded(
    String groupId, String barcode, String emailHash, String imageUrl) {
  return db()
      .child("excludelist/${groupId}/${barcode}/${emailHash}")
      .set(imageUrl);
}
