import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:hackzurich2017/firebase_helper.dart';

Future<Null> afterLogin(String emailHash, String imageUrl) async {
  final DataSnapshot user = await db().child("users/emailHash").once();
  if (user != null) return null;

  final groupId = await _createGroup(emailHash, imageUrl);
  await _createUser(user.value["imageUrl"], emailHash, groupId);
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
