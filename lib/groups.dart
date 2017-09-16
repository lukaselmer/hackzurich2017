import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:hackzurich2017/firebase_helper.dart';



Widget groupsList(FirebaseUser user) {
  if (user == null) return new Text('Please login first');

  return new FirebaseAnimatedList(
    query: groups(), // TODO: change this to: myGroups(user),
    sort: (a, b) => b.key.compareTo(a.key),
    padding: new EdgeInsets.all(8.0),
    reverse: true,
    itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation, __) {
      return new GroupListItem(snapshot: snapshot, animation: animation);
    },
  );
}

void createGroup(String name, FirebaseUser user) {
  final newGroup = groups().push();
  final groupId = newGroup.key;
  newGroup.set({
    'name': name,
    'ownerId': user.hashCode.toString(),
    'ownerEmail': user.email,
    'ownerPhotoUrl': user.photoUrl,
  });
  groupUsers().child(groupId).push().set({'id': user.hashCode.toString()});
  userGroups().child(user.hashCode.toString()).push().set({'group': groupId});
}

class GroupListItem extends StatelessWidget {
  GroupListItem({this.snapshot, this.animation});

  final DataSnapshot snapshot;
  final Animation animation;

  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(
                  backgroundImage:
                      new NetworkImage(snapshot.value['ownerPhotoUrl'])),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(snapshot.value['name'],
                    style: Theme.of(context).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(snapshot.value['ownerEmail']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
