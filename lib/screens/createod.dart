import 'dart:io';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:responsiveapp/screens/ondutymob.dart';
import 'addisp.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
enum Yesno {Yes,No}


class UserData {
  String eventName;
  String collegeName;
  String odType;
  String preOdApplied;
  String date;
  String Pdflink;
  List<String> selectedPeriods;

  UserData({
    required this.eventName,
    required this.collegeName,
    required this.odType,
    required this.preOdApplied,
    required this.date,
    required this.selectedPeriods,
    required this.Pdflink,
  });

  Map<String, dynamic> toJson() {
    return {
      'eventName': eventName,
      'collegeName': collegeName,
      'odType': odType,
      'preOdApplied': preOdApplied,
      'date': date,
      'selectedPeriods': selectedPeriods,
    };
  }
}

String getCurrentUserID() {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  if (user != null) {
    return user.uid;
  } else {
    // Handle the case where the user is not signed in.
    return "User not signed in";
  }
}

class Multiselect extends StatefulWidget {
  final List<String> items;

  Multiselect({Key? key, required this.items}) : super(key: key);


  @override
  _MultiselectState createState() => _MultiselectState();
}

class _MultiselectState extends State<Multiselect> {
  final List<String> _selectedItems = [];

  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: const Text('Select periods'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
            value: _selectedItems.contains(item),
            title: Text(item),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (isChecked) => _itemChange(item, isChecked!),
          ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(onPressed: _cancel, child: const Text("Cancel")),
        ElevatedButton(onPressed: _submit, child: const Text("Submit")),
      ],
    );
  }
}

class Scene extends StatefulWidget {
  @override
  _SceneState createState() => _SceneState();

}

class _SceneState extends State<Scene> {

  BannerAd? _bannerAd;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-1787921379597237/3056758819'
      : 'ca-app-pub-3940256099942544/2934735716';

  @override
  void initState(){
    //TODO: implement initState
    _fetchData();

    super.initState();
    _loadAd();


    var fieldName = 'roll';
    FirebaseFirestore.instance.collection('userData').doc(getCurrentUserID()).update({
      fieldName: FieldValue.delete(),
    });


  }
  String usrmail='';

  Future<void> _fetchData() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      String email = queryDocumentSnapshot.data()['email'];
      if (getCurrentUserID() == queryDocumentSnapshot.id) {
        usrmail = email;
      }
    }
    setState(() {});
  }


  String fileName = '';


  String uid = getCurrentUserID();
  String fname ="";
  bool fileUploaded = false; // Track whether a file has been uploaded
  bool fileDeleted = false; // Track whether the uploaded file has been deleted

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> pdfData = [];
  List<String> link = [];
  Future<String?> uploadpdf(String fileName, File file) async {
    final reference = FirebaseStorage.instance.ref().child("Teachers/ss/$usrmail/$fileName");
    final uploadTask = reference.putFile(file);

    await uploadTask.whenComplete(() {});
    final downloadlink = await reference.getDownloadURL();

    final String eventName = _eventNameController.text;

    // Get the existing data from the document
    final DocumentSnapshot documentSnapshot =
    await _firebaseFirestore.collection("pdfs").doc(getCurrentUserID()).get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> existingData = documentSnapshot.data() as Map<String, dynamic>;

      if (existingData.containsKey(eventName)) {
        // Update the existing field if eventName already exists
        await _firebaseFirestore.collection("pdfs").doc(getCurrentUserID()).update({
          '$eventName.name': fileName,
          '$eventName.url': downloadlink,
        });
      } else {
        // Add a new field if eventName doesn't exist
        await _firebaseFirestore.collection("pdfs").doc(getCurrentUserID()).set({
          eventName: {
            "name": fileName,
            "url": downloadlink,
          }
        }, SetOptions(merge: true));
      }
    } else {
      // If the document doesn't exist, create a new one
      await _firebaseFirestore.collection("pdfs").doc(getCurrentUserID()).set({
        eventName: {
          "name": fileName,
          "url": downloadlink,
        }
      });
    }
    link.add(downloadlink);
    return downloadlink;
  }



  Future<void> deletepdf(String fileName) async {
    final reference = FirebaseStorage.instance.ref().child("Teachers/ss/$usrmail/$fileName");
    final ListResult listResult = await reference.list();
    link = [];
    if (listResult.items.isNotEmpty) {
      // Delete files from Firebase Storage
      final Reference delref = listResult.items.first;
      await delref.delete();
      print("Deleted from Firebase Storage");
    }

    // Delete documents from Firestore
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    final CollectionReference pdfsCollection = _firebaseFirestore.collection('pdfs');

    // Get all the documents in the collection
    final QuerySnapshot querySnapshot = await pdfsCollection.get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      // Delete each document in the collection
      await pdfsCollection.doc(doc.id).delete();
    }

    print("Deleted from Firestore");
    setState(() {
      fileUploaded = false; // Set to false when the file is deleted
      fileDeleted = true; // Set to true to indicate that the file has been deleted
    });
    // Refresh the PDF data list
    getAllPdf(fname);
  }





  void pickFile() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (pickedFile != null) {
      File file = File(pickedFile.files.single.path!);

      // Check file size before uploading
      if (file.lengthSync() > 3 * 1024 * 1024) {
        // Show an alert or message to the user that the file is too large
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("File Size Limit Exceeded"),
              content: Text("Please choose a file less than 3MB."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        fileName = pickedFile.files[0].name;
        final downloadlink = await uploadpdf(fileName, file);

        setState(() {
          fileUploaded = true; // Set to true when the file is uploaded
          fileDeleted = false; // Set to false to indicate that the uploaded file has not been deleted
        });

        getAllPdf(fileName);
      }
    }
  }


  Future<String?> getAllPdf(String fname) async {
    final documentReference = _firebaseFirestore.collection("pdfs").doc(getCurrentUserID());

    final snapshot = await documentReference.get();
    if (snapshot.exists) {
      // Document exists, proceed with processing data
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (data.containsKey(_eventNameController.text)) {
        String fileData = data[_eventNameController.text]["name"] as String;
        return fileData;
      } else {
        // The document doesn't contain the key with fname
        return "No File uploaded";
      }
    } else {
      // Document doesn't exist, handle accordingly
      return "No File Uploaded";
    }
  }
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _collegeNameController = TextEditingController();
  TextEditingController _ODTypeController = TextEditingController();

  List<String> _selectedItems = [];
  TextEditingController _datecontroller = TextEditingController();
  Yesno? _yesno;
  void _showMultiselect(BuildContext context) async {

    final List<String> items = [
      'I',
      'II',
      'III',
      'IV',
      'V',
      'VI',
      'VII',
      'VIII',
    ];
    final List<String>? results = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return Multiselect(items: items);
      },
    );

    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(
        title: Text("Create OD",style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,

      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(height: 11),
                TextField(
                  controller: _eventNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(21),
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                    label: Text("Event Name"),
                  ),
                ),
                Container(height: 11),
                TextField(
                  controller: _collegeNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(21),
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                    label: Text("College Name"),
                  ),
                ),
                Container(height: 11),
                TextField(
                  controller: _ODTypeController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(21),
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                    label: Text("OD Type (internal/external)"),
        
                  ),
                ),
                Container(height: 13),
                Text(
                  "PRE-OD applied ?",
                  style: TextStyle(
                    fontSize: 16, // You can adjust the font size
                    fontWeight: FontWeight.bold, // You can set the desired fontWeight
                    color: Colors.black, // You can set the desired text color
                    // You can add more text styling properties as needed
                  ),
                ),
                Container(height: 13),
        
                Row(
                  children: [
        
                    Expanded(
                      child: RadioListTile(contentPadding: EdgeInsets.all(0.0),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)) ,tileColor: Colors.blueGrey.shade50,value: Yesno.Yes, groupValue: _yesno,title: Text("Yes"), onChanged: (val) {
        
                        setState(() {
                          _yesno = val;
                        });
                      }),
                    ),
                    SizedBox(width: 5.0,),
                    Expanded(
                      child: RadioListTile(contentPadding: EdgeInsets.all(0.0),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),tileColor: Colors.blueGrey.shade50,value: Yesno.No, groupValue: _yesno,title: Text("No"), onChanged: (val) {
                        setState(() {
                          _yesno = val;
                        });
                      }),
                    ),
        
                  ],
                ),
        
        
                Container(height: 11),
                TextField(
                  controller: _datecontroller,
        
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(21),
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                    label: Text("Enter Date"),
                  ),
                  readOnly: true,
                  onTap: (){
                    _selectDate();
        
                  },
                ),
                Container(height: 11),
        
                Text(
                  "Select Periods",
                  style: TextStyle(
                    fontSize: 16, // You can adjust the font size
                    fontWeight: FontWeight.bold, // You can set the desired fontWeight
                    color: Colors.black, // You can set the desired text color
                    // You can add more text styling properties as needed
                  ),
                ),
        
                const Divider(
                  height: 15,
        
                ),
                Wrap(
                  children: _selectedItems
                      .map((e) => Chip(
                    label: Text(e),
                  ))
        
                      .toList(),
                ),
                Container(height: 12),
        
                ElevatedButton(
                  onPressed: () => _showMultiselect(context),
                  child: Text("Select duration"),
                ),
                Container(height: 12),
        
                Text(
                  "Upload Proof",
                  style: TextStyle(
                    fontSize: 20, // You can adjust the font size
                    fontWeight: FontWeight.bold, // You can set the desired fontWeight
                    color: Colors.black, // You can set the desired text color
                    // You can add more text styling properties as needed
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder<String?>(
                      future: getAllPdf(fname),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {


                          return CircularProgressIndicator(); // Show a loading indicator while waiting for the result
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if (snapshot.hasData && snapshot.data != null) {
                          // Display the data when available
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.data!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => deletepdf(fileName),
                                child: Icon(Icons.close, color: Colors.red),
                              ),
                            ],
                          );
                        } else {
                          // Handle the case when data is null or unavailable
                          return Text("No file uploaded");
                        }
                      },
                    ),
                  ],
                ),
        
                Container(height: 5),
                ElevatedButton(
                  onPressed: () => pickFile(),
                  child: Text("Upload pdf"),
        
                ),
                Container(height: 12),
                Stack(
              children: [
                if (_bannerAd != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SafeArea(
                      child: SizedBox(
                        width: _bannerAd!.size.width.toDouble(),
                        height: _bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd!),
                      ),
                    ),
                  )
              ],
            ),
        
        
        
              ],
            ),
          ),
        
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () {
                    deletepdf(fname);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OnDuty()));
                  },
                  child: Text("Cancel"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20.0),
                    fixedSize: Size(150,100),
                    textStyle: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),

                    foregroundColor: Colors.black87,
                    elevation: 15,
                  ),
                ),
              ElevatedButton(
              onPressed: () => _submitData(context), // Replace submitData with your submit logic
              child: Text("Submit"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20.0),
                  fixedSize: Size(150,100),
                  textStyle: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.black87,
                  elevation: 15,
                  shadowColor: Colors.blue,
                ),
                ),

              ],
              ),

      ),
          );
  }

  void _loadAd() async {
    BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _bannerAd = ad as BannerAd;
            });
          }
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    ).load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _submitData(BuildContext context) async {
    String uid = getCurrentUserID();
    // Get values from text controllers and other form elements
    final eventName = _eventNameController.text;
    final collegeName = _collegeNameController.text;
    final date = _datecontroller.text;
    print(date);
    final odtype = _ODTypeController.text;
    DocumentReference docref = FirebaseFirestore.instance.collection('userData').doc(uid);
    Map<String, dynamic> data = {
      'eventName': eventName,
      'collegeName': collegeName,
      'odType': odtype,
      'PreODApplied': _yesno.toString(),
      'Date': date,
      'SelectedPeriods': _selectedItems,
      'ProofLink': link[0],
    };
    String customDocumentName = 'OD_${date.split('-')[2]}_${date.split('-')[1]}_${date.split('-')[0].substring(2)}';

    docref.update({customDocumentName: data});


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
                // Navigate to a specified page
                Navigator.of(context).pushNamed("/onduty");
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );

  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));

    if (_picked != null)
      {
        setState(() {
          _datecontroller.text = _picked.toString().split(" ")[0];
        });

      }
  }


}
