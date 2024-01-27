import 'package:acc_voting_app/CommonFunctions/Commonfunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {

  var selectedValue = 1;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Total Vote count'),
        actions: [
          InkWell(
            onTap: () async {
              try{
                await FirebaseAuth.instance.signOut();
              }catch(e,s){print(e);}
            },
            child: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('voteCount').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          // Process the documents and extract values
          List<String> documentValues = [];
          snapshot.data?.docs.forEach((DocumentSnapshot document) {
            // Adjust the field name based on your Firestore document structure
            String value1 = document['candidate_1'].toString();
            String value2 = document['candidate_2'].toString();
            String value3 = document['candidate_3'].toString();
            String value4 = document['candidate_4'].toString();
            documentValues.add(value1);
            documentValues.add(value2);
            documentValues.add(value3);
            documentValues.add(value4);
          });

          return ListView.builder(
            itemCount: documentValues.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(
                  children: [
                    Text("Candidate ${index + 1} Vote count: "),Text(documentValues[index], style: TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );

  }
}
