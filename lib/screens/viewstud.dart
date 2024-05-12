import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsiveapp/screens/oddetailsteach.dart';
class ViewStud extends StatefulWidget {
  const ViewStud({Key? key}) : super(key: key);

  @override
  State<ViewStud> createState() => _ViewStudState();
}

class _ViewStudState extends State<ViewStud> {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<String> studentIds = [];
  List<String> userEmails = [];

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
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('teacherchk')
        .doc(getCurrentUserID())
        .get();

    var collection = FirebaseFirestore.instance.collection('users');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      String data = queryDocumentSnapshot.id;
      userEmails.add(data);
    }
    if (documentSnapshot.exists) {
      // Document exists, you can access the array
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

      // Accessing the array
      List<dynamic> students = data['Students'] ?? [];

      setState(() {
        studentIds = List<String>.from(students);
      });
    }
  }

  Future<String> fetchData(int index) async {
    DocumentSnapshot documentSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(studentIds[index]).get();

    if (documentSnapshot.exists) {
      // Data exists, you can access it
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

      // Access specific fields from the document
      String email = data['email'];
      return email;
    } else {
      // Document does not exist
      return 'Document does not exist';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Students"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            // Use ListView.builder to dynamically build the list
            Expanded(
              child: ListView.builder(
                itemCount: studentIds.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: FutureBuilder<String>(
                            future: fetchData(index),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return RefreshProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Text(snapshot.data ?? '');
                              }
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => oddetailsteach(tid: studentIds[index])));
                          },
                          child: Text("View Details"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _fetchData();
              },
              child: Text("Refresh"),
            ),
          ],
        ),
      ),
    );
  }
}
