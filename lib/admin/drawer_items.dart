import 'package:flutter/material.dart';

class drawer_items extends StatefulWidget {
  _drawer_items createState() => _drawer_items();
}

class _drawer_items extends State<drawer_items> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Welcome'),
          ),
          ListTile(
            title: Text('My Profile'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          Divider(),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
