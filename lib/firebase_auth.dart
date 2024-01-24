import 'package:acc_voting_app/CommonFunctions/Commonfunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirebaseAuthentication {

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User?> signUpWithEmailPassword(String name, String email, String password, String contact, context) async {
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await FirebaseAuth.instance.currentUser!.updateEmail(email);
      await CommonFunctions.createUser(name, email, password, contact);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signed in successfully.')));

    }on FirebaseAuthException catch(e,s){
      print(e);
    } catch (e,s) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }


  static signUpAsAdmin(String email, String password, context) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Assign the "admin" role to the user in Firestore
      await _firestore.collection('admin').doc(userCredential.user?.uid).set({
        'role': 'admin',
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signed up as admin")));


      print('Admin signed up successfully');
    } catch (e) {
      print('Error signing up: $e');
    }
  }

  static Future<User?> signInWithEmailPassword(String email, String password, context) async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signed in successfully')));

    }catch(e,s){
      print(e);
    }
  }

  Future<void> signInAsAdmin(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user's role from Firestore
      String? userRole = await getUserRole(userCredential.user?.uid);

      // Check if the user has the "admin" role
      if (userRole == 'admin') {
        print('Admin signed in successfully');
        // Proceed with any additional logic for admin sign-in
      } else {
        // If the user doesn't have the "admin" role, sign them out
        print('User does not have admin role. Signing out.');
        await _auth.signOut();
      }
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  Future<String?> getUserRole(String? uid) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      if (uid != null) {
        // Retrieve user's role from Firestore
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
        return userDoc['role'];
      }
    } catch (e) {
      print('Error getting user role: $e');
    }
    return null;
  }

}
