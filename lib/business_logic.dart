import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:hackzurich2017/firebase_helper.dart';

Future<Null> afterLogin(String emailHash) async {

  final DataSnapshot user = await db().child("users/emailHash").once();

  if (user != null) {
    return null;
  }

  final key = createGroup(user.value);
  createUser(user.value["imageUrl"], emailHash, key);
}

createUser(imageUrl, emailHash, key) {
  db().child("users/${emailHash}").set({
    "group": emailHash,
    "imageUrl": imageUrl
  });
}

createGroup(user) {
  final reference = db().child("groups").push();
  reference.set({
    user.emailHash: user.imageUrl
  });
  return reference.key;
}
