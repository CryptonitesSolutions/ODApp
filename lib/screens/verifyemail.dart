import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsiveapp/screens/onboding/onboding_screen.dart';
import 'package:responsiveapp/screens/signin_screen.dart';
import 'package:responsiveapp/screens/teacherdash.dart';
import 'package:responsiveapp/responsive/mobile_body.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      isEmailVerified = currentUser.emailVerified;
      if (!isEmailVerified) {
        sendVerificationEmail();

        timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await currentUser.reload();

      setState(() {
        isEmailVerified = currentUser.emailVerified;
      });

      if (isEmailVerified) {
        timer?.cancel();
      }
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed((Duration(seconds: 5)));
      setState(() => canResendEmail = true);
    } catch (e) {
      print(e.toString());
    }
  }

  Widget route() {
    User? user = FirebaseAuth.instance.currentUser;

    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').doc(user!.uid).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text('Document does not exist on the database');
        }

        if (snapshot.data!.get('roll') == "Teacher") {
          print("teacherlogin");
          return teacherdash();
        } else {
          return MobileScaffold();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? route()
      : Scaffold(
    appBar: AppBar(
      title: Text('Verify Email'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OnboardingScreen()),
          );
        },
      ),
    ),
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "A verification email has been sent to your mail",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50)),
            onPressed: canResendEmail ? sendVerificationEmail : null,
            icon: Icon(Icons.email, size: 32),
            label: Text(
              "Resend Email",
              style: TextStyle(fontSize: 24),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          TextButton(
            style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50)),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OnboardingScreen()));
            },
            child: Text(
              "Cancel",
              style: TextStyle(fontSize: 24),
            ),
          )
        ],
      ),
    ),
  );
}
