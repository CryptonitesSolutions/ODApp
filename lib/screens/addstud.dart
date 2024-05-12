import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsiveapp/screens/teacherdash.dart';

class addstud extends StatefulWidget {
  const addstud({Key? key}) : super(key: key);

  @override
  State<addstud> createState() => _addstudState();
}

class _addstudState extends State<addstud> {
  var collection = FirebaseFirestore.instance.collection("teacherchk");
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<dynamic> items = [];
  List<dynamic> students = [];

  String getCurrentUserID() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      return user.uid;
    } else {
      return "User not signed in";
    }
  }


  @override
  void initState() {
    super.initState();
    _fetchData();
  }


  Future<void> _fetchData() async {
    DocumentSnapshot documentSnapshot = await collection.doc(getCurrentUserID())
        .get();
    if (documentSnapshot.exists) {
      // Document exists, you can access the array
      Map<String, dynamic> data = documentSnapshot.data() as Map<String,
          dynamic>;

      // Accessing the array
      students = data['Students']; // Update the class-level list
    }
    setState(() {
      items = students;
    });
  }


  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Students"),
        centerTitle: true,
      ),
      body: Center(
        child: _buildListView(),
      ),
    );
  }


  Future<String?> getEmail() async {
    CollectionReference docref = FirebaseFirestore.instance.collection('teacherchk');
    String? userid = FirebaseAuth.instance.currentUser?.uid;

    if (userid != null) {
      DocumentSnapshot docSnapshot = await docref.doc(userid).get();
      if (docSnapshot.exists) {
        // Access the 'email' field from the document data
        String email = docSnapshot['email'];
        int atIndex = email.indexOf('@');
        String domain = email.substring(atIndex + 1);
        print(domain);
        return domain;
      } else {
        return 'no id found';
      }
    } else {
      return 'user not authenticated';
    }
  }

  Widget _buildListView() {
    DocumentReference docref = FirebaseFirestore.instance.collection('teacherchk').doc(getCurrentUserID());

    return StreamBuilder(
      stream: _firebaseFirestore.collection('users').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // Extract the currentUserDomain outside the where function
          String currentUserDomain = '';
          snapshot.data!.docs.forEach((document) {
            String docid = document.id;
            bool isCurrentUser = docid == FirebaseAuth.instance.currentUser?.uid;

            if (isCurrentUser) {
              String email = document['email'];
              int atIndex = email.indexOf('@');
              currentUserDomain = email.substring(atIndex + 1);
            }
          });
          List<DocumentSnapshot> filteredDocuments = snapshot.data!.docs
              .where((document) {
            String roll = document['roll'];
            String email = document['email'];
            String docid = document.id;
            bool isStudent = roll == 'Student' && roll != 'teacher';
            bool hasDesiredDomain = email.endsWith(currentUserDomain);

            return isStudent && hasDesiredDomain;
          })
              .toList();


          return ListView(
            children: filteredDocuments.map((DocumentSnapshot document) {
              // Access fields from the document
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              String studentName = data['email'];
              String reason = data['roll'];

              bool conditionMet = students.contains(document.id.toString()); // Replace with your actual condition

              return ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(studentName),
                          Text(reason),
                        ],
                      ),
                    ),

                    // Display the ElevatedButton only if the condition is met
                    if (conditionMet)
                      ElevatedButton(
                        onPressed: () {
                          docref.update({"Students": FieldValue.arrayRemove([document.id.toString()])});
                          print(docref.get());

                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Success"),
                                content: Text("Data removed successfully!"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _fetchData();// Close the dialog
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                          print(document.id.toString());
                        },
                        child: Text("Remove"),
                      )
                    else
                      ElevatedButton(
                        onPressed: () {
                          docref.update({"Students": FieldValue.arrayUnion([document.id.toString()])});
                          print(docref.get());

                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Success"),
                                content: Text("Data submitted successfully!"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                      _fetchData();// Close the dialog
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                          print(document.id.toString());
                        },
                        child: Text("Add"),
                      )
                  ],
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }


}
