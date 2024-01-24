import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_auth.dart';

class CommonFunctions{

  final FirebaseAuthentication _auth = FirebaseAuthentication();

  static bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidPhoneNumber(String phoneNumber) {
    final RegExp phoneRegex = RegExp(
      r'^\d{10}$', // Assumes a 10-digit phone number format
    );
    return phoneRegex.hasMatch(phoneNumber);
  }

  static bool doesNotContainSymbols(String input) {
    final RegExp noSymbolsRegex = RegExp(r'^[a-zA-Z0-9]+$');
    return noSymbolsRegex.hasMatch(input);
  }

  static bool validateInputs(String email, String phoneNumber, String testString) {
    return isValidEmail(email) &&
        isValidPhoneNumber(phoneNumber) &&
        doesNotContainSymbols(testString);
  }

  static Future createUser(username, email, password, contact) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();

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
      // Initialize Firebase
      await Firebase.initializeApp();

      // Reference to the Firestore collection
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      // Perform a query to find documents where the email field matches the given email
      QuerySnapshot querySnapshot = await users.where('email', isEqualTo: email).get();

      // Check if matching documents are found
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first matching document
        DocumentSnapshot matchingDocument = querySnapshot.docs.first;

        // Check the hasVoted field in the matching document
        bool hasVoted = matchingDocument['hasVoted'];

        // Return the value of hasVoted
        return hasVoted;
      } else {
        // No matching documents found
        return false;
      }
    } catch (e) {
      print('Error checking hasVoted by email: $e');
      // Return false in case of an error
      return false;
    }
  }



}