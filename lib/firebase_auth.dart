import 'package:acc_voting_app/CommonFunctions/Commonfunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirebaseAuthentication {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User?> signUpWithEmailPassword(String name, String email,
      String password, String contact, context) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await FirebaseAuth.instance.currentUser!.updateEmail(email);
      await CommonFunctions.createUser(name, email, password, contact, "users");

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Signed in successfully.'),
        backgroundColor: Colors.green,
      ));

      return credential.user;
    } on FirebaseAuthException catch (e, s) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
      print(e);
    } catch (e, s) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  static signUpAsAdmin(String email, String password, context) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Assign the "admin" role to the user in Firestore
      // await _firestore.collection('admin').doc(userCredential.user?.uid).set({
      //   'role': 'admin',
      // });

      await CommonFunctions.createUser("", email, password, "", "admin");

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Signed up as admin"),
        backgroundColor: Colors.green,
      ));

      return userCredential.user;
    } on FirebaseAuthException catch (e, s) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
      print(e);
    } catch (e, s) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  static Future<User?> signInWithEmailPassword(
      String email, String password, context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);


      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Signed in successfully'),
        backgroundColor: Colors.green,
      ));

      return userCredential.user;

    } on FirebaseAuthException catch (e, s) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
      print(e);
    } catch (e, s) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  static Future<bool> checkIfAdminExists(
      String email, String password, context) async {
    try {
      await Firebase.initializeApp();

      CollectionReference users =
          FirebaseFirestore.instance.collection('admin');

      QuerySnapshot querySnapshot = await users
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await FirebaseAuthentication.signInWithEmailPassword(
            email, password, context);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Signed in successfully"),
          backgroundColor: Colors.green,
        ));

        return true;
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red,));
        return false;
      }

      return false;
    } on FirebaseAuthException catch (e, s) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
      // print(e);
      return false;
    } catch (e, s) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }
}
