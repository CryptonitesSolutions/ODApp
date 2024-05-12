import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:responsiveapp/screens/signin_screen.dart';





var defaultBackgroundColor = Colors.grey[300];
var appBarColor = Colors.grey[900];
var myAppBar = AppBar(
  backgroundColor: appBarColor,

  title: Text(' '),
  centerTitle: false,
);
var drawerTextColor = TextStyle(
  color: Colors.grey[600],
);
var tilePadding = const EdgeInsets.only(left: 8.0, right: 8, top: 8);
var myDrawer = Drawer(
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

        ),
      ),
      Padding(
        padding: tilePadding,
        child: ListTile(
          leading: Icon(Icons.info),
          title: Text(
            'ABOUT',
            style: drawerTextColor,
          ),

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

        ),
      ),
    ],
  ),
);

