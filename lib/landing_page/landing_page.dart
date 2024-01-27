import 'package:acc_voting_app/CommonFunctions/Commonfunctions.dart';
import 'package:acc_voting_app/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  final docUserAdmin = FirebaseFirestore.instance
      .collection('voteCount')
      .doc("JzKlcz1ukiT1Mpbsyvq3");
  final docUserUser = FirebaseFirestore.instance
      .collection('users')
      .doc();

  var candidatesList = [
    "Candidate 1",
    "Candidate 2",
    "Candidate 3",
    "Candidate 4",
  ];

  var selectedValue = 1;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voting Panel"),
        actions: [
          InkWell(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: Icon(Icons.more_vert),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text("Who do you want to vote",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700)),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder<bool>(
            future: CommonFunctions.checkHasVotedByEmail(user!.email),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // If the Future is still running, show a loading indicator
                return const CircularProgressIndicator(
                  color: Colors.orange,
                );
              } else if (snapshot.hasError) {
                // If there is an error, display an error message
                return Text('Error: ${snapshot.error}');
              } else {
                // If the Future is complete, display the result
                bool hasVoted = snapshot.data!;
                return hasVoted
                    ? const Text("Thanks for voting")
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: candidatesList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                title: Text(candidatesList[index]),
                                leading: Radio(
                                  value: index + 1,
                                  groupValue: selectedValue,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value as int;
                                      print("Button value: $value");
                                    });

                                  },
                                ),
                              ),
                            ],
                          );
                        });
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed: () async {
                selectedValue == 1
                    ? await docUserAdmin.update({
                  'candidate_1':
                  FieldValue.increment(1)
                })
                    : selectedValue == 2
                    ? await docUserAdmin.update({
                  'candidate_2':
                  FieldValue.increment(1)
                })
                    : selectedValue == 3
                    ? await docUserAdmin.update({
                  'candidate_3':
                  FieldValue.increment(1)
                })
                    : await docUserAdmin.update({
                  'candidate_4':
                  FieldValue.increment(1)
                });

                await CommonFunctions.updateVotedStatus(user!.email, context);

              }, child: Text("Vote")),
            ],
          )
        ],
      ),
    );
  }
}
