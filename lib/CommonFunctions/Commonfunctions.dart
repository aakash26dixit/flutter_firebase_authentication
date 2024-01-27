import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_auth.dart';

class CommonFunctions{

  final FirebaseAuthentication _auth = FirebaseAuthentication();

  static bool doesNotContainSymbols(String input) {
    final RegExp noSymbolsRegex = RegExp(r'^[a-zA-Z0-9]+$');
    return noSymbolsRegex.hasMatch(input);
  }

  static Future createUser(username, email, password, contact, collection) async {
    final docUser = FirebaseFirestore.instance.collection(collection == 'users' ? 'users' : 'admin').doc();

    final record = {
      "username": username,
      "email": email,
      "password": password,
      "contact": contact,
      "hasVoted": false
    };

    docUser.set(record);
  }

  static Future updateUser(username, email, password, contact) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();

    docUser.update({
      'hasVoted' : true
    });
  }

  static Future<bool> checkHasVotedByEmail(String? email) async {
    try {
      await Firebase.initializeApp();

      CollectionReference users = FirebaseFirestore.instance.collection('users');

      QuerySnapshot querySnapshot = await users.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {

        DocumentSnapshot matchingDocument = querySnapshot.docs.first;

        bool hasVoted = matchingDocument['hasVoted'];

        return hasVoted;
      } else {
        return false;
      }
    } catch (e) {
      // print('Error checking hasVoted by email: $e');
      return false;
    }
  }

  static Future updateVotedStatus(String? email , context)async{
    try {
      await Firebase.initializeApp();

      CollectionReference users = FirebaseFirestore.instance.collection('users');

      QuerySnapshot querySnapshot = await users.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {

        DocumentSnapshot matchingDocument = querySnapshot.docs.first;

        DocumentReference docRef = matchingDocument.reference;

        await docRef.update({'hasVoted': true}).then((value) =>
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Voted successfully"),
              backgroundColor: Colors.green,
            ))
        );



      } else {
        return false;
      }
    } catch (e) {
      // print('Error checking hasVoted by email: $e');
      return false;
    }
  }
}