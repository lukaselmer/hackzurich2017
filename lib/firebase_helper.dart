import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleSignIn = new GoogleSignIn();
final auth = FirebaseAuth.instance;

DatabaseReference db() {
  return FirebaseDatabase.instance.reference();
}

DatabaseReference groups() {
  return db().child('groups');
}

DatabaseReference userGroups() {
  return db().child('user_groups');
}

DatabaseReference groupUsers() {
  return db().child('group_users');
}

Query myGroups(FirebaseUser user) {
  return db().child('user_groups/${user.hashCode}');
}

Query usersForGroup(String groupId) {
  return db().child('group_users/$groupId');
}

DatabaseReference items() {
  return db().child('barcodes');
}

Future<DataSnapshot> getInfoFor(String itemId) {
  return items().child(itemId).once();
}
