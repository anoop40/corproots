import 'package:corproots/staff/Templates.dart';
import 'package:flutter/material.dart';

import 'EmailSettings.dart';

class SettingsStaff extends StatefulWidget {
  _SettingsStaff createState() => _SettingsStaff();
}

class _SettingsStaff extends State<SettingsStaff> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgetOptions = <Widget>[
    Templates(),
    EmailSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner),
            label: 'Templates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.email),
            label: 'Email Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
