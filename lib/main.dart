import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:responsiveapp/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import '/responsive/desktop_body.dart';
import '/responsive/tablet_body.dart';
import '/responsive/mobile_body.dart';
import '/responsive/responsive_layout.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsiveapp/screens/ondutymob.dart';
import 'firebase_options.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:responsiveapp/screens/teacherdash.dart';
import 'package:responsiveapp/screens/verifyemail.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:responsiveapp/screens/onboding/onboding_screen.dart';
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await Hive.initFlutter();
  await Hive.openBox('mybox');
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  Future<void> _signOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        // Check the authentication state when the app starts
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData && snapshot.data != null) {
            User? user = FirebaseAuth.instance.currentUser;
            var kk = FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .get()
                .then((DocumentSnapshot documentSnapshot) {
              if (documentSnapshot.exists) {
                if (!user!.emailVerified) {
                  print("hi");
                   Navigator.push(context,MaterialPageRoute(builder: (context) => VerifyEmailPage()));
                }
                else {
                  if (documentSnapshot.get('roll') == "Teacher") {
                    print("teacherlogin");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => teacherdash(),
                      ),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MobileScaffold(),
                      ),
                    );
                  }
                }
              } else {
                _signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));

              }
            });



            // Add a default return statement
            return Container(); // You can replace this with any other widget as needed
          } else {
            // User is not logged in, show the sign-in screen
            return OnboardingScreen();
          }
        },
      ),
      routes: {
        '/responsive_layout': (context) => ResponsiveLayout(
          mobileBody: const MobileScaffold(),
          tabletBody: const TabletScaffold(),
          desktopBody: const DesktopScaffold(),
        ),
        '/onduty': (context) => OnDuty(),
      },
    );
  }
}

