import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covi_find/services/authentification/authentification_service.dart';
import 'package:flutter/material.dart';

Future<bool> showSignOutDialog(
  BuildContext context,
  String messege, {
  String positiveResponse = "Yes",
  String negativeResponse = "No",
}) async {
  var result = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(messege),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          FlatButton(
            child: Text(
              positiveResponse,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              AuthentificationService().signOut();
              Navigator.pop(context, true);
            },
          ),
          FlatButton(
            child: Text(
              negativeResponse,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      );
    },
  );
  if (result == null) result = false;
  return result;
}

FirebaseFirestore instance = Firestore.instance;
cancel(id) {
  instance
      .collection('Users')
      .doc(AuthentificationService().currentUser.uid)
      .collection('RaisedReq')
      .doc(id)
      .delete();
}

Future<bool> showCancelDialog(
  BuildContext context,
  String messege,
  id, {
  String positiveResponse = "Yes",
  String negativeResponse = "No",
}) async {
  var result = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(messege),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          FlatButton(
            child: Text(
              positiveResponse,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              cancel(id);
              Navigator.pop(context, true);
            },
          ),
          FlatButton(
            child: Text(
              negativeResponse,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      );
    },
  );

  if (result == null) result = false;
  return result;
}
