import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsiveapp/util/my_box_view.dart';
import 'package:responsiveapp/util/my_tile_rem.dart';
import '/constants.dart';
import '/util/my_box.dart';
import '/util/my_tile.dart';
import '/util/my_tile_rem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:responsiveapp/screens/signin_screen.dart';
import 'package:responsiveapp/responsive/tablet_body.dart';
import 'package:responsiveapp/responsive/desktop_body.dart';
import "package:responsiveapp/responsive/responsive_layout.dart";
import 'package:responsiveapp/screens/to_do.dart';
import 'package:responsiveapp/screens/settings.dart';
import 'package:responsiveapp/screens/aboutus.dart';
class teacherdash extends StatefulWidget {
  const teacherdash({Key? key}) : super(key: key);

  @override
  State<teacherdash> createState() => _teacherdashState();
}

class _teacherdashState extends State<teacherdash> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
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
            // first 4 boxes in grid
            AspectRatio(
              aspectRatio: 1,
              child: SizedBox(
                width: double.infinity,
                child: GridView.builder(
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return MyBox();
                    } else if (index == 1) {
                      return MyBoxview();
                    }
                    else{
                      return Container();
                    }
                  },
                ),
              ),
            ),

            // list of previous days
            Expanded(
              child: ListView.builder(
                itemCount: 2, // Adjust the itemCount to match the number of items
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const MyTile();
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
