import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:responsiveapp/screens/signin_screen.dart';

class SettingsPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _deleteUserData(BuildContext context) async {
    try {
      // Get the current user's ID and email from Firestore
      String userId = _auth.currentUser?.uid ?? '';

      DocumentSnapshot userSnapshot =
      await _firestore.collection('users').doc(userId).get();
      String userEmail = userSnapshot.get('email');
      print(userEmail);

      // Show a confirmation dialog
      bool deleteConfirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Deletion'),
            content: Text('Are you sure you want to delete your account?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // User canceled the deletion
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // User confirmed the deletion
                },
                child: Text('Delete'),
              ),
            ],
          );
        },
      );

      if (deleteConfirmed == true) {
        // Delete Firestore data using email from the 'users' collection
        await _firestore
            .collection('users')
            .where('email', isEqualTo: userEmail)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });

        // Delete Firestore data from the 'userData' collection
        await _firestore.collection('userData').doc(userId).delete();

        // Delete all files within the 'Teachers/ss' folder in Firebase Storage
        final Reference storageReference =
        FirebaseStorage.instance.ref().child('Teachers/ss/$userEmail');
        ListResult result = await storageReference.listAll();
        result.items.forEach((fileReference) async {
          await fileReference.delete();
        });

        // Delete Firebase Authentication user
        await _auth.currentUser?.delete();

        // After deletion, navigate to the login or home screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      }
    } catch (e) {
      print("Error deleting user data: $e");
      await _auth.currentUser?.delete(); // Delete Firebase Authentication user

      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Call the method to show the confirmation dialog
            await _deleteUserData(context);
          },
          child: Text('Delete My Account'),
        ),
      ),
    );
  }
}
