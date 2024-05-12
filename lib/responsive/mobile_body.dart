import 'package:flutter/material.dart';
import 'package:responsiveapp/util/my_tile_rem.dart';
import '/constants.dart';
import '/util/my_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:responsiveapp/screens/signin_screen.dart';
import 'package:responsiveapp/screens/settings.dart';
import 'package:responsiveapp/screens/aboutus.dart';
import 'package:responsiveapp/screens/onboding/onboding_screen.dart';
class MobileScaffold extends StatefulWidget {
    const MobileScaffold({Key? key}) : super(key: key);

    @override
    State<MobileScaffold> createState() => _MobileScaffoldState();
  }

  class _MobileScaffoldState extends State<MobileScaffold> {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    Future<void> _signOut() async {
      await _auth.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: defaultBackgroundColor,
        appBar: myAppBar,
        drawer: Drawer(
          backgroundColor: Colors.grey[300],
          elevation: 0,
          child: Column(
            children: [
              DrawerHeader(
                child: Icon(
                  Icons.favorite,
                  size: 64,
                ),
              ),
              Padding(
                padding: tilePadding,
                child: ListTile(
                  leading: Icon(Icons.home),
                  title: Text(
                    'DASHBOARD',
                    style: drawerTextColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: tilePadding,
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text(
                    'SETTINGS',
                    style: drawerTextColor,
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));


                  },
                ),
              ),
              Padding(
                padding: tilePadding,
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text(
                    'About Us',
                    style: drawerTextColor,
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUsPage())); // Navigate to the About screen
                  },
                ),
              ),
              // Padding(
              //   padding: tilePadding,
              //   child: ListTile(
              //     leading: Icon(Icons.attach_money),
              //     title: Text(
              //       'DONATE US',
              //       style: drawerTextColor,
              //     ),
              //     onTap: () {
              //       Navigator.push(context, MaterialPageRoute(builder: (context) => donateus())); // Navigate to the About screen
              //     },
              //   ),
              // ),

              Padding(
                padding: tilePadding,
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(
                    'LOGOUT',
                    style: drawerTextColor,
                  ),
                  onTap: () {
                    _signOut(); // Navigate to the Signin screen
                  },
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [


              // list of previous days
              Expanded(
                child: ListView.builder(
                  itemCount: 2, // Adjust the itemCount to match the number of items
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const MyTile();
                    } else if (index == 1) {
                      return const MyTilerem();
                    } else {
                      return SizedBox(height: 0); // Add a zero-height SizedBox for spacing
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
