import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackzurich2017/business_logic.dart';
import 'package:hackzurich2017/info_page.dart';

handleBarcodeScan(BuildContext context, String groupId,
    FirebaseUser currentUser, String itemId) async {
  bool isExcluded = await isExcludedBarcode(groupId, itemId);
  print('----------------------');
  print(isExcluded);
  print('----------------------');
  Navigator.push(context,
      InfoPage.createRoute(context, isExcluded, groupId, currentUser, itemId));
}
