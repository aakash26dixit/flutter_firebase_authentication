import 'package:acc_voting_app/CommonFunctions/Commonfunctions.dart';
import 'package:acc_voting_app/firebase_auth.dart';
import 'package:acc_voting_app/landing_page/landing_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final CommonFunctions commonFunctions = CommonFunctions();
  final FirebaseAuthentication _auth = FirebaseAuthentication();

  // Future signUp(
  //     String name, String password, String contact, String email) async {
  //   User? user = await _auth.signUpWithEmailPassword(email, password);
  //
  //   if (user != null) {
  //     Navigator.pushNamed(context, "/login").then((value) =>
  //         ScaffoldMessenger.of(context).showSnackBar(
  //             new SnackBar(content: new Text("Signup successful"))));
  //   } else {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: new Text("Signup error occured")));
  //   }
  // }

  Future createUser(username, email, password, contact) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, "/login");
            },
            child: Icon(Icons.more_vert),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                      hintText: "Username", border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !CommonFunctions.doesNotContainSymbols(value)) {
                      return 'Please enter a valid username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                      hintText: "Password", border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      hintText: "Email", border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                      hintText: "Contact", border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 10) {
                      return 'Please enter a valid contact number';
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                          );
                        },
                        child: const Text('LOGIN'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              // await createUser(
                              //     _usernameController.text,
                              //     _passwordController.text,
                              //     _phoneController.text,
                              //     _emailController.text);

                              // await signUp(
                              //     _usernameController.text,
                              //     _passwordController.text,
                              //     _phoneController.text,
                              //     _emailController.text);

                              FirebaseAuthentication.signUpWithEmailPassword(
                                  _usernameController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                  _phoneController.text,
                                  context
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()),
                              );
                            }
                          } catch (e, s) {
                            print(e);
                          }
                        },
                        child: const Text('REGISTER'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
