import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class oddetails extends StatefulWidget {
  final String tid;
  oddetails({
    required this.tid,
  });

  @override
  _oddetailsState createState() => _oddetailsState();
}

class _oddetailsState extends State<oddetails> {
  var collection = FirebaseFirestore.instance.collection("userData");
  var usr = FirebaseFirestore.instance.collection("teacherchk");
  var usrname = FirebaseFirestore.instance.collection("users");

  List<Map<String, dynamic>> items = [];
  bool isLoaded = false;


  @override
  void initState() {
    super.initState();
    _fetchData();
    var fieldName = 'roll';
    FirebaseFirestore.instance.collection('userData').doc(widget.tid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists && (documentSnapshot.data() as Map<String, dynamic>)[fieldName] != null) {
        // Field exists, delete it
        FirebaseFirestore.instance.collection('userData').doc(widget.tid).update({
          fieldName: FieldValue.delete(),
        });
      } else {
        print('Field $fieldName does not exist or is already deleted.');
      }
    });
  }


  Future<void> _fetchData() async {

    List<Map<String, dynamic>> tempList = [];
    String uid = widget.tid;
    var chk1 = await usrname.doc(uid).get();
    var data = await collection.get();
    String chk = "";

    if (chk1.exists) {
      Map<String, dynamic> data = chk1.data() as Map<String, dynamic>;
      chk = data["email"];
    } else {
      print('Document does not exist.');
    }

    data.docs.forEach((element) {
      if (element.id == uid) {
        tempList.add(element.data());
      }
    });

    setState(() {
      items = tempList;
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Past OD Entries"),
        centerTitle: true,
      ),
      body: Center(
        child: isLoaded
            ? _buildListView()
            : CircularProgressIndicator(), // Show a loading indicator
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildListTile(index);
      },
    );
  }

  Widget _buildListTile(int index) {
    return Column(
      children: items[index].keys.map((kval) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            leading: const CircleAvatar(
              backgroundColor: Color(0xff6ae792),
              child: Icon(Icons.person),
            ),
            title: Row(
              children: [
                Text("Event Name : " + items[index][kval]["eventName"] ?? "Unknown Name"),
                SizedBox(width: 10),
              ],
            ),
            subtitle: Text("College : " + items[index][kval]["collegeName"] ?? "Unknown College"),
            trailing: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Details"),
                      content: _buildDetailsContent(index, kval),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Close"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.more_vert),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDetailsContent(int index, String kval) {
    String status = items[index][kval]["Status"] ?? ""; // Get status from Firestore or default to empty string
    print("status");
    return Container(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [Text("Event Name : " + items[index][kval]["eventName"] ?? "Unknown Name")],
          ),
          Row(
            children: [Text("College : " + items[index][kval]["collegeName"] ?? "Unknown College")],
          ),
          Row(
            children: [
              Text("Proof Link: "),
              GestureDetector(
                onTap: () {
                  if (items[index][kval]["ProofLink"] != null) {
                    launch(items[index][kval]["ProofLink"]);
                  }
                },
                child: Text(
                  "Link",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [Text("PreODApplied : " + items[index][kval]["PreODApplied"] ?? "Unknown College")],
          ),
          Row(
            children: [Text("Date : " + items[index][kval]["Date"] ?? "Unknown College")],
          ),
          Row(
            children: [Text("odType : " + items[index][kval]["odType"] ?? "Unknown College")],
          ),
          if (status.isNotEmpty) ...{
            Row(
              children: [Text("Status: $status")],
            ),
          }
        ],
      ),
    );
  }
}
