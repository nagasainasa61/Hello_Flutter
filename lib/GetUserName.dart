
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserName extends StatelessWidget {
  final String documentId;

  GetUserName(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('baby');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          if(data != null)
            return Column(
              children: [
                Text("First Name: ${data['first_name']}",
                    style: new TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    )
                ),
                Text("Last Name: ${data['last_name']}"),
              ],
            );
          else
            return Text("Employee does not exist.");
        }

        return Text("Searching...");
      },
    );
  }
}